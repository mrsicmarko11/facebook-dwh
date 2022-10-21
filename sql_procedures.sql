USE [RDL]
GO

/****** Object:  StoredProcedure [facebook].[usp_Comments]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_Comments](@input_date DATE)
AS
BEGIN
    IF @input_date IS NULL
        SET @input_date = CAST(GETDATE() AS DATE);

    IF OBJECT_ID(N'tempdb..#tmp_Comments') IS NOT NULL
        DROP TABLE #tmp_Comments;

    SELECT CAST(TRIM(commentId) AS BIGINT)     AS Src_Comment_Id,
           TRIM(commentText)                   AS Comment_Text,
           CAST(TRIM(commentTime) AS DATETIME) AS Comment_Time,
           TRIM(commentUrl)                    AS Comment_Url,
           TRIM(commentImage)                  AS Comment_Image,
           LoadDate                            AS Comment_LoadDate
    INTO #tmp_Comments
    FROM stage.telco.FacebookComments
    WHERE CAST(LoadDate AS Date) = CAST(@input_date AS DATE);

    MERGE INTO [facebook].[Comments] AS Target
    USING #tmp_Comments AS Source
    ON Source.Src_Comment_Id = Target.Src_Comment_Id
        AND Target.Comment_Id <> -1
    WHEN NOT MATCHED BY Target THEN
        INSERT (Src_Comment_Id, Comment_Text, Comment_Time, Comment_Url, Comment_Image,
                Comment_LoadDate, Inserted_Datetime, Updated_Datetime)
        VALUES (Source.Src_Comment_Id, Source.Comment_Text, Source.Comment_Time,
                Source.Comment_Url, Source.Comment_Image, Source.Comment_LoadDate,
                GETDATE(), GETDATE())
    WHEN MATCHED AND (Target.Comment_Text <> Source.Comment_Text OR
                      Target.Comment_Time <> Source.Comment_Time OR
                      Target.Comment_Url <> Source.Comment_Url OR
                      Target.Comment_Image <> Source.Comment_Image)
        THEN
        UPDATE
        SET Target.Comment_Text     = Source.Comment_Text,
            Target.Comment_Time     = Source.Comment_Time,
            Target.Comment_Url      = Source.Comment_Url,
            Target.Comment_Image    = Source.Comment_Image,
            Target.Comment_LoadDate = Source.Comment_LoadDate,
            Target.Updated_Datetime = GETDATE();

--facebook.CommentsHist

    MERGE INTO [facebook].[CommentsHist] AS Target
    USING [facebook].[Comments] AS Source
    ON Source.Comment_Id = Target.Comment_Id
        AND Target.Current_Flag = 'Y'
    WHEN NOT MATCHED BY Target AND Source.Comment_Id <> -1 THEN
        INSERT (Comment_Id, Src_Comment_Id, Comment_Text, Comment_Time, Comment_Url,
                Comment_Image, Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
                Updated_Datetime)
        VALUES (Source.Comment_Id, Source.Src_Comment_Id, Source.Comment_Text,
                Source.Comment_Time, Source.Comment_Url, Source.Comment_Image,
                dbo.fn_valid_from_seconds(Comment_LoadDate),
                '3000-01-01', 1, 'Y', GETDATE(), GETDATE())
    WHEN MATCHED AND (Target.Comment_Text <> Source.Comment_Text OR
                      Target.Comment_Time <> Source.Comment_Time OR
                      Target.Comment_Url <> Source.Comment_Url OR
                      Target.Comment_Image <> Source.Comment_Image)
        THEN
        UPDATE
        SET Target.Valid_To         = DATEADD(SECOND, -1, dbo.fn_valid_from_seconds(Source.Comment_LoadDate)),
            Target.Current_Flag     = 'N',
            Target.Updated_Datetime = GETDATE();

    INSERT INTO [facebook].[CommentsHist]
    (Comment_Id, Src_Comment_Id, Comment_Text, Comment_Time, Comment_Url,
     Comment_Image, Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
     Updated_Datetime)
    SELECT Source.Comment_Id,
           Source.Src_Comment_Id,
           Source.Comment_Text,
           Source.Comment_Time,
           Source.Comment_Url,
           Source.Comment_Image,
           dbo.fn_valid_from_seconds(Comment_LoadDate) AS Valid_From,
           '3000-01-01'                                AS Valid_To,
           Seq_ID + 1                                  AS Seq_Id,
           'Y'                                         AS Current_Flag,
           GETDATE()                                   AS Inserted_Datetime,
           GETDATE()                                   AS Updated_Datetime
    FROM [facebook].[CommentsHist] AS Target
             JOIN [facebook].[Comments] AS Source
                  ON Source.Comment_Id = Target.Comment_Id
             JOIN (SELECT Comment_Id, MAX(Seq_Id) Max_Seq_Id
                   FROM [facebook].[CommentsHist]
                   WHERE Comment_Hist_Id <> -1
                   GROUP BY Comment_Id) AS FilterTable
                  ON Target.Comment_Id = FilterTable.Comment_Id AND Target.Seq_Id = FilterTable.Max_Seq_Id
    WHERE (Target.Comment_Text <> Source.Comment_Text OR
           Target.Comment_Time <> Source.Comment_Time OR
           Target.Comment_Url <> Source.Comment_Url OR
           Target.Comment_Image <> Source.Comment_Image)
      AND Target.Comment_Hist_Id <> -1
      AND Source.Comment_Id <> -1;

END;
GO

/****** Object:  StoredProcedure [facebook].[usp_CommentsReactionsHist]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_CommentsReactionsHist] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

         DECLARE @input_datetime DATETIME
	     SET @input_datetime = DATEADD(SECOND,-1, CAST(DATEADD(DAY, 1, @input_date) AS DATETIME))

		IF OBJECT_ID (N'tempdb..#tmp_CommentsReactionsHist') IS NOT NULL
		    DROP TABLE #tmp_CommentsReactionsHist;

		SELECT DISTINCT ISNULL(crt.Comment_Reaction_Type_Id,-1) AS Comment_Reaction_Type_Id,
			   ISNULL(uh.User_Hist_Id,-1) AS User_Hist_Id,
			   ISNULL(ch.Comment_Hist_Id,-1) AS Comment_Hist_Id
            INTO #tmp_CommentsReactionsHist
        FROM stage.[telco].[FacebookCommentsReactions] fcr
        LEFT JOIN [facebook].[UsersHist] uh ON facebook.f_remove_url_reactions(fcr.commentReactionUserUrl) = uh.User_Account_Name
        LEFT JOIN [facebook].[CommentsHist] ch ON TRIM(fcr.commentId) = ch.Src_Comment_Id
        LEFT JOIN [facebook].[CommentsReactionsTypes] crt ON TRIM(fcr.commentReactionUserType) = crt.Comment_Reaction_Type
        where CAST(fcr.LoadDate AS DATE) = CAST('2021-08-28' AS DATE)
        AND @input_datetime BETWEEN ISNULL(ch.Valid_From,'1900-01-01') AND ISNULL(ch.Valid_To,'3000-01-01')
        AND @input_datetime BETWEEN ISNULL(uh.Valid_From,'1900-01-01') AND ISNULL(uh.Valid_To,'3000-01-01');

		MERGE INTO [facebook].[CommentsReactionsHist] AS Target
        USING #tmp_CommentsReactionsHist AS Source
        ON Target.Comment_Hist_Id=Source.Comment_Hist_Id
               AND Target.Comment_Reaction_Type_Id=Source.Comment_Reaction_Type_Id
               AND Target.User_Hist_Id=Source.User_Hist_Id
	    AND Target.Comment_Reaction_Hist_Id <> -1
	    WHEN NOT MATCHED BY Target THEN
		    INSERT (Comment_Reaction_Type_Id, User_Hist_Id, Comment_Hist_Id, Inserted_Datetime)
		    VALUES (Source.Comment_Reaction_Type_Id,Source.User_Hist_Id,Source.Comment_Hist_Id, GETDATE());

	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_CommentsReactionsTypes]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--facebook.CommentsReactionsTypes
CREATE   PROCEDURE [facebook].[usp_CommentsReactionsTypes] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

		IF OBJECT_ID (N'tempdb..#tmp_CommentsReactions') IS NOT NULL
		DROP TABLE #tmp_CommentsReactions

		SELECT TRIM(commentReactionUserType) AS Comment_Reaction_Type
		INTO #tmp_CommentsReactions
		FROM stage.[telco].[FacebookCommentsReactions]
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
		GROUP BY commentReactionUserType

		MERGE INTO [facebook].[CommentsReactionsTypes] AS Target
		USING #tmp_CommentsReactions AS Source
		ON Target.Comment_Reaction_Type = Source.Comment_Reaction_Type
		    AND Target.Comment_Reaction_Type_Id<>-1
		WHEN NOT MATCHED BY Target THEN
			INSERT (Comment_Reaction_Type, Inserted_Datetime)
			VALUES (Source.Comment_Reaction_Type, GETDATE());
	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_CommentsRepliesHist]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_CommentsRepliesHist] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

         DECLARE @input_datetime DATETIME
	     SET @input_datetime = DATEADD(SECOND,-1, CAST(DATEADD(DAY, 1, @input_date) AS DATETIME))

        IF OBJECT_ID (N'tempdb..#tmp_CommentsRepliesHist') IS NOT NULL
		    DROP TABLE #tmp_CommentsRepliesHist;

		SELECT ISNULL(ch.Comment_Hist_Id,-1) AS Comment_Hist_Id,
			   ISNULL(rh.Reply_Hist_Id,-1) AS Reply_Hist_Id
		INTO #tmp_CommentsRepliesHist
		FROM stage.[telco].[FacebookReplies] fr
		LEFT JOIN [facebook].[CommentsHist] ch ON fr.commentId = ch.Src_Comment_Id
		LEFT JOIN [facebook].[RepliesHist] rh ON fr.replyId = rh.Src_Reply_Id
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
		AND @input_datetime BETWEEN ch.Valid_From AND ch.Valid_To
		AND @input_datetime BETWEEN rh.Valid_From AND rh.Valid_To
	    AND rh.Reply_Hist_Id<>-1
	    AND ch.Comment_Hist_Id<>-1;

		MERGE INTO [facebook].[CommentsRepliesHist] AS Target
        USING #tmp_CommentsRepliesHist AS Source
        ON Target.Comment_Hist_Id=Source.Comment_Hist_Id AND Target.Reply_Hist_Id=Source.Reply_Hist_Id
	    AND Target.Comment_Reply_Id <> -1
	    WHEN NOT MATCHED BY Target THEN
	    INSERT   (Comment_Hist_Id, Reply_Hist_Id, Inserted_Datetime)
	    VALUES (Source.Comment_Hist_Id,Source.Reply_Hist_Id,GETDATE());

	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_CommentsUsersHist]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_CommentsUsersHist] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

         DECLARE @input_datetime DATETIME
	     SET @input_datetime = DATEADD(SECOND,-1, CAST(DATEADD(DAY, 1, @input_date) AS DATETIME))

		IF OBJECT_ID (N'tempdb..#tmp_CommentsUsersHist') IS NOT NULL
		    DROP TABLE #tmp_CommentsUsersHist;

		SELECT ISNULL(ch.Comment_Hist_Id,-1) AS Comment_Hist_Id,
			   ISNULL(uh.User_Hist_Id,-1) AS User_Hist_Id
		INTO #tmp_CommentsUsersHist
		FROM stage.[telco].[FacebookComments] fc
		LEFT JOIN [facebook].[CommentsHist] ch ON fc.commentId = ch.Src_Comment_Id
		LEFT JOIN [facebook].[UsersHist] uh ON fc.commenterId = uh.Src_User_Id
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
		AND @input_datetime BETWEEN ch.Valid_From AND ch.Valid_To
		AND @input_datetime BETWEEN uh.Valid_From AND uh.Valid_To
	    AND uh.User_Hist_Id<>-1
	    AND ch.Comment_Hist_Id<>-1;

		MERGE INTO [facebook].[CommentsUsersHist] AS Target
        USING #tmp_CommentsUsersHist AS Source
        ON Target.Comment_Hist_Id=Source.Comment_Hist_Id AND Target.User_Hist_Id=Source.User_Hist_Id
	    AND Target.Comment_User_Id <> -1
	    WHEN NOT MATCHED BY Target THEN
		INSERT (Comment_Hist_Id, User_Hist_Id, Inserted_Datetime)
		VALUES (Source.Comment_Hist_Id,Source.User_Hist_Id,GETDATE());

	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_Companies]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE      PROCEDURE [facebook].[usp_Companies](@input_date DATE)
AS
BEGIN
    -- check input parameter value
    IF @input_date IS NULL
        SET @input_date = CAST(GETDATE() as DATE);

    -- check if temp table exists (drop if it does)
    IF OBJECT_ID(N'tempdb..#tmp_Companies') IS NOT NULL
        DROP TABLE #tmp_Companies;

    -- insert into temp table for a date
    SELECT TRIM(name)                  AS Company_Name,
           TRIM(type)                  AS Company_Type,
           REPLACE(TRIM(url), '/', '') AS Company_Account_Name,
           TRIM(image)                 AS Company_Image,
           TRIM(about)                 AS Company_About,
           CAST(likes AS INT)          AS Company_Likes,
           LoadDate                    AS Company_LoadDate
    INTO #tmp_Companies
    FROM stage.telco.FacebookCompaniesInfo
    WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE);

    -- Action on RDL [facebook].[Companies] table
    MERGE INTO [facebook].[Companies] AS Target
    USING #tmp_Companies AS Source
    ON Source.Company_Account_Name = Target.Company_Account_Name
        AND Target.Company_Id <> -1
    WHEN NOT MATCHED BY Target THEN
        INSERT (Company_Name, Company_Type, Company_Account_Name, Company_Image,
                Company_About, Company_Likes, Company_LoadDate, Inserted_Datetime,
                Updated_Datetime)
        VALUES (Source.Company_Name, Source.Company_Type, Source.Company_Account_Name,
                Source.Company_Image, Source.Company_About, Source.Company_Likes,
                Source.Company_LoadDate, GETDATE(), GETDATE())
    WHEN MATCHED AND (Target.Company_Type <> Source.Company_Type OR
                      Target.Company_Image <> Source.Company_Image OR
                      Target.Company_About <> Source.Company_About OR
                      Target.Company_Likes <> Source.Company_Likes OR
                      Target.Company_Name <> Source.Company_Name)
        THEN
        UPDATE
        SET Target.Company_Type     = Source.Company_Type,
            Target.Company_Image    = Source.Company_Image,
            Target.Company_About    = Source.Company_About,
            Target.Company_Likes    = Source.Company_Likes,
            Target.Company_Name     = Source.Company_Name,
            Target.Company_LoadDate = Source.Company_LoadDate,
            Target.Updated_Datetime = GETDATE();

    -- Action on RDL [facebook].[CompaniesHist] table
    MERGE INTO [facebook].[CompaniesHist] AS Target
    USING [facebook].[Companies] AS Source
    ON Source.Company_Id = Target.Company_Id AND Target.Current_Flag = 'Y'
    WHEN NOT MATCHED BY Target AND Source.Company_Id <> -1 THEN
        INSERT (Company_Id, Company_Name, Company_Type, Company_Account_Name,
                Company_Image, Company_About, Company_Likes, Valid_From, Valid_To,
                Seq_Id, Current_Flag, Inserted_Datetime, Updated_Datetime)
        VALUES (Source.Company_Id, Source.Company_Name, Source.Company_Type,
                Source.Company_Account_Name, Source.Company_Image, Source.Company_About,
                Source.Company_Likes, dbo.fn_valid_from_seconds(Company_LoadDate),
                '3000-01-01', 1, 'Y', GETDATE(), GETDATE())
    WHEN MATCHED AND (Target.Company_Type <> Source.Company_Type OR
                      Target.Company_Image <> Source.Company_Image OR
                      Target.Company_About <> Source.Company_About OR
                      Target.Company_Likes <> Source.Company_Likes OR
                      Target.Company_Name <> Source.Company_Name)
        THEN
        UPDATE
        SET Target.Valid_To         = DATEADD(SECOND, -1,
                                              dbo.fn_valid_from_seconds(Source.Company_LoadDate)), --23:59:58
            Target.Current_Flag     = 'N',
            Target.Updated_Datetime = GETDATE();

    INSERT INTO facebook.CompaniesHist (Company_Id, Company_Name, Company_Type, Company_Account_Name,
                                        Company_Image, Company_About, Company_Likes, Valid_From, Valid_To,
                                        Seq_Id, Current_Flag, Inserted_Datetime, Updated_Datetime)
    SELECT Source.Company_Id,
           Source.Company_Name,
           Source.Company_Type,
           Source.Company_Account_Name,
           Source.Company_Image,
           Source.Company_About,
           Source.Company_Likes,
           dbo.fn_valid_from_seconds(Company_LoadDate) AS Valid_From,
           '3000-01-01'                                AS Valid_To,
           Seq_Id + 1                                  AS Seq_Id,
           'Y'                                         AS Current_Flag,
           GETDATE()                                   AS Inserted_Datetime,
           GETDATE()                                   AS Updated_Datetime
    FROM facebook.CompaniesHist AS Target
             JOIN facebook.Companies AS Source
                  ON Source.Company_Id = Target.Company_Id
             JOIN (SELECT Company_Id, MAX(Seq_Id) Max_Seq_Id
                   FROM facebook.CompaniesHist
                   GROUP BY Company_Id) As FilterTable
                  ON Target.Company_Id = FilterTable.Company_Id AND Target.Seq_Id = FilterTable.Max_Seq_Id
    WHERE (Target.Company_Type <> Source.Company_Type OR
           Target.Company_Image <> Source.Company_Image OR
           Target.Company_About <> Source.Company_About OR
           Target.Company_Likes <> Source.Company_Likes OR
           Target.Company_Name <> Source.Company_Name)
           AND Target.Company_Hist_Id <> -1
           AND Source.Company_Id <> -1;
END;
GO

/****** Object:  StoredProcedure [facebook].[usp_CompaniesPostHist]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_CompaniesPostHist] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

         DECLARE @input_datetime DATETIME
	     SET @input_datetime = DATEADD(SECOND,-1, CAST(DATEADD(DAY, 1, @input_date) AS DATETIME))

		IF OBJECT_ID (N'tempdb..#tmp_CompaniesPostsHist') IS NOT NULL
		    DROP TABLE #tmp_CompaniesPostsHist;

		SELECT ISNULL(ch.Company_Hist_Id,-1) AS Company_Hist_Id,
			   ISNULL(ph.Post_Hist_Id,-1) AS Post_Hist_Id
		INTO #tmp_CompaniesPostsHist
		FROM stage.[telco].[FacebookPosts] fp
		LEFT JOIN [facebook].[CompaniesHist] ch ON fp.accountName = ch.Company_Account_Name
		LEFT JOIN [facebook].[PostsHist] ph ON fp.postID = ph.Src_Post_Id
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
		AND @input_datetime BETWEEN ch.Valid_From AND ch.Valid_To
		AND @input_datetime BETWEEN ph.Valid_From AND ph.Valid_To
	    AND ph.Post_Hist_Id<>-1
	    AND ch.Company_Hist_Id<>-1;

		MERGE INTO [facebook].[CompaniesPostsHist] AS Target
        USING #tmp_CompaniesPostsHist AS Source
        ON Target.Company_Hist_Id=Source.Company_Hist_Id AND Target.Post_Hist_Id=Source.Post_Hist_Id
	    AND Target.Company_Post_Id <> -1
	    WHEN NOT MATCHED BY Target THEN
		    INSERT  (Company_Hist_Id, Post_Hist_Id, Inserted_Datetime)
		    VALUES (Source.Company_Hist_Id,Source.Post_Hist_Id,GETDATE());

	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_delete_data]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_delete_data] 
AS
	BEGIN
				--Linked Hist Tables
		DELETE FROM [facebook].[CompaniesPostsHist]
		DBCC CHECKIDENT ('facebook.CompaniesPostsHist', RESEED, 0)

		DELETE FROM facebook.PostsCommentsHist
		DBCC CHECKIDENT ('facebook.PostsCommentsHist', RESEED, 0)

		DELETE FROM [facebook].[CommentsReactionsHist]
		DBCC CHECKIDENT ('facebook.CommentsReactionsHist', RESEED, 0)

		DELETE FROM [facebook].[CommentsRepliesHist]
		DBCC CHECKIDENT ('facebook.CommentsRepliesHist', RESEED, 0)

		DELETE FROM [facebook].[CommentsUsersHist]
		DBCC CHECKIDENT ('facebook.CommentsUsersHist', RESEED, 0)

		DELETE FROM [facebook].[PostsVideosHist]
		DBCC CHECKIDENT ('facebook.PostsVideosHist', RESEED, 0)

		DELETE FROM [facebook].[RepliesReactionsHist]
		DBCC CHECKIDENT ('facebook.RepliesReactionsHist', RESEED, 0)

		--Hist Tables
		DELETE FROM [facebook].[CommentsHist]
		DBCC CHECKIDENT ('facebook.CommentsHist', RESEED, 0)

		DELETE FROM [facebook].[CompaniesHist]
		DBCC CHECKIDENT ('facebook.CompaniesHist', RESEED, 0)

		DELETE FROM [facebook].[PostsHist]
		DBCC CHECKIDENT ('facebook.PostsHist', RESEED, 0)

		DELETE FROM [facebook].[RepliesHist]
		DBCC CHECKIDENT ('facebook.RepliesHist', RESEED, 0)

		DELETE FROM [facebook].[UsersHist]
		DBCC CHECKIDENT ('facebook.UsersHist', RESEED, 0)

		DELETE FROM [facebook].[VideosHist]
		DBCC CHECKIDENT ('facebook.VideosHist', RESEED, 0)

		--Current Tables
		DELETE FROM [facebook].[Comments]
		DBCC CHECKIDENT ('facebook.Comments', RESEED, 0)

		DELETE FROM [facebook].[Companies]
		DBCC CHECKIDENT ('facebook.Companies', RESEED, 0)

		DELETE FROM [facebook].[Posts]
		DBCC CHECKIDENT ('facebook.Posts', RESEED, 0)

		DELETE FROM [facebook].[Replies]
		DBCC CHECKIDENT ('facebook.Replies', RESEED, 0)

		DELETE FROM [facebook].[Users]
		DBCC CHECKIDENT ('facebook.Users', RESEED, 0)

		DELETE FROM [facebook].[Videos]
		DBCC CHECKIDENT ('facebook.Videos', RESEED, 0)

		--Lookup Tables
		DELETE FROM [facebook].[CommentsReactionsTypes]
		DBCC CHECKIDENT ('facebook.CommentsReactionsTypes', RESEED, 0)

		DELETE FROM [facebook].[RepliesReactionsTypes]
		DBCC CHECKIDENT ('facebook.RepliesReactionsTypes', RESEED, 0)
	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_insert_RDL_tables]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [facebook].[usp_insert_RDL_tables] (@initial_load CHAR(1), @load_date DATE)
AS
	BEGIN
		IF @load_date IS NULL
			SET @load_date = '2021-08-28';

		IF @initial_load IS NULL
		    SET @initial_load = 'N';

		IF @initial_load = 'Y'
		BEGIN
            EXEC facebook.usp_delete_data;
			PRINT('Executing procedure usp_insert_unknown_values');
            EXEC facebook.usp_insert_unknown_values;
		END
		--BEGIN TRY 
			PRINT('Executing facebook.usp_Companies');
			EXEC facebook.usp_Companies @load_date;
			PRINT('Executing facebook.usp_Posts');
			EXEC facebook.usp_Posts @load_date;
			PRINT('Executing facebook.usp_Comments');
			EXEC facebook.usp_Comments @load_date;
			PRINT('Executing facebook.usp_Replies');
			EXEC facebook.usp_Replies @load_date;
			PRINT('Executing facebook.usp_Users');
			EXEC facebook.usp_Users @load_date;
			PRINT('Executing facebook.usp_Videos');
			EXEC facebook.usp_Videos @load_date;
			PRINT('Executing facebook.usp_CommentsReactionsTypes');
			EXEC facebook.usp_CommentsReactionsTypes @load_date;
			PRINT('Executing facebook.usp_RepliesReactionsTypes');
			EXEC facebook.usp_RepliesReactionsTypes @load_date;
			PRINT('Executing facebook.usp_CommentsRepliesHist');
			EXEC facebook.usp_CommentsRepliesHist @load_date;
			PRINT('Executing facebook.usp_CommentsUsersHist');
			EXEC facebook.usp_CommentsUsersHist @load_date;
			PRINT('Executing facebook.usp_PostsCommentsHist');
			EXEC facebook.usp_PostsCommentsHist @load_date;
			PRINT('Executing facebook.usp_CompaniesPostHist');
			EXEC facebook.usp_CompaniesPostHist @load_date;
			PRINT('Executing facebook.usp_PostsVideosHist');
			EXEC facebook.usp_PostsVideosHist @load_date;
			PRINT('Executing facebook.usp_CommentsReactionsHist');
			EXEC facebook.usp_CommentsReactionsHist @load_date;
			PRINT('Executing facebook.usp_RepliesReactionsHist');
			EXEC facebook.usp_RepliesReactionsHist @load_date;	
			PRINT('############################################')
		/*END TRY
		BEGIN CATCH  
		 SELECT   
			 ERROR_NUMBER() AS ErrorNumber  
			,ERROR_MESSAGE() AS ErrorMessage
			, @load_date AS LoadDate
		END CATCH  
			*/
	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_insert_unknown_values]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_insert_unknown_values]
AS
	BEGIN
		--facebook.Comments and facebook.CommentsHist
		SET IDENTITY_INSERT facebook.Comments ON;
		INSERT INTO facebook.Comments (Comment_Id, Src_Comment_Id, Comment_Text, Comment_Time, Comment_Url, Comment_Image, Comment_LoadDate, Inserted_Datetime, Updated_Datetime)
		VALUES (-1,-1,'Unknown','1900-01-01','Unknown','Unknown','1900-01-01','1900-01-01','1900-01-01');
		SET IDENTITY_INSERT facebook.Comments OFF;

		SET IDENTITY_INSERT facebook.CommentsHist ON;
		insert into facebook.CommentsHist (Comment_Hist_Id, Comment_Id, Src_Comment_Id, Comment_Text, Comment_Time, Comment_Url,
								  Comment_Image, Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
								  Updated_Datetime)
		VALUES (-1,-1,-1,'Unknown','1900-01-01','Unknown','Unknown','1900-01-01','3000-01-01',1,'Y','1900-01-01','1900-01-01');
		SET IDENTITY_INSERT facebook.CommentsHist OFF;

		--facebook.Companies and facebook.CompaniesHist
		SET IDENTITY_INSERT facebook.Companies ON;
		insert into facebook.Companies (Company_Id, Company_Name, Company_Type, Company_Account_Name, Company_Image,
										Company_About, Company_Likes, Company_LoadDate, Inserted_Datetime, Updated_Datetime)
		values (-1,'Unknown','Unknown','Unknown', 'Unknown', 'Unknown', -1, '1900-01-01', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.Companies OFF;

		SET IDENTITY_INSERT facebook.CompaniesHist ON;
		insert into facebook.CompaniesHist (Company_Hist_Id, Company_Id, Company_Name, Company_Account_Name, Company_Type, Company_Image,
											Company_About, Company_Likes, Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
											Updated_Datetime)
		values (-1, -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', -1, '1900-01-01', '3000-01-01', 1, 'Y', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.CompaniesHist OFF;

		--facebook.Posts and facebook.PostsHist
		SET IDENTITY_INSERT facebook.Posts ON;
		insert into facebook.Posts (Post_Id, Src_Post_Id, Post_Text, Post_Time, Post_Url, Post_Likes,
									Post_Comments, Post_Shares, Post_LoadDate, Inserted_Datetime, Updated_Datetime)
		values (-1, -1,'Unknown', '1900-01-01', 'Unknown', -1, -1, -1, '1900-01-01', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.Posts OFF;

		SET IDENTITY_INSERT facebook.PostsHist ON;
		insert into facebook.PostsHist (Post_Hist_Id, Post_Id, Src_Post_Id, Post_Text, Post_Time, Post_Url, Post_Likes,
										Post_Comments, Post_Shares, Valid_From, Valid_To, Seq_Id, Current_Flag,
										Inserted_Datetime, Updated_Datetime)
		values (-1, -1, -1, 'Unknown', '1900-01-01', 'Unknown', -1, -1, -1, '1900-01-01', '3000-01-01', 1, 'Y', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.PostsHist OFF;

		--facebook.Replies and facebook.RepliesHist
		SET IDENTITY_INSERT facebook.Replies ON;
		insert into facebook.Replies (Reply_Id, Src_Reply_Id, Reply_Text, Reply_Time, Reply_Url, Reply_Image, Reply_LoadDate,
									  Inserted_Datetime, Updated_Datetime)
		values (-1, -1, 'Unknown', '1900-01-01', 'Unknown', 'Unknown', '1900-01-01', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.Replies OFF;

		SET IDENTITY_INSERT facebook.RepliesHist ON;
		insert into facebook.RepliesHist (Reply_Hist_Id, Reply_Id, Src_Reply_Id, Reply_Text, Reply_Time, Reply_Url, Reply_Image,
										  Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime, Updated_Datetime)
		values (-1, -1, -1, 'Unknown', '1900-01-01', 'Unknown', 'Unknown', '1900-01-01', '3000-01-01', 1, 'Y', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.RepliesHist OFF;

		--facebook.Users and facebook.UsersHist
		SET IDENTITY_INSERT facebook.Users ON;
		insert into facebook.Users (User_Id, Src_User_Id, User_Name, User_Account_Name, User_Birthyear, User_Gender, User_Education,
									User_Current_City, User_Hometown, User_Relationship, User_Profile_Picture, User_Cover_Photo,
									User_LoadDate, Inserted_Datetime, Updated_Datetime)
		values (-1, -1, 'Unknown', 'Unknown', -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown',
			   '1900-01-01', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.Users OFF;

		SET IDENTITY_INSERT facebook.UsersHist ON;
		insert into facebook.UsersHist (User_Hist_Id, User_Id, Src_User_Id, User_Name, User_Account_Name, User_Birthyear, User_Gender, User_Education,
										User_Current_City, User_Hometown, User_Relationship, User_Profile_Picture, User_Cover_Photo,
										Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime, Updated_Datetime)
		values (-1, -1, -1, 'Unknown', 'Unknown', -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown',
				'1900-01-01', '3000-01-01', 1, 'Y', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.UsersHist OFF;

		--facebook.Videos and facebook.VideosHist
		SET IDENTITY_INSERT facebook.Videos ON;
		insert into facebook.Videos (Video_Id, Src_Video_Id, Video, Video_Quality, Video_Size_Mb, Video_Duration_Sec, Video_Watches,
									 Video_LoadDate, Inserted_Datetime, Updated_Datetime)
		values (-1, -1, 'Unknown', 'Unknown', -1, -1, -1, '1900-01-01', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.Videos OFF;

		SET IDENTITY_INSERT facebook.VideosHist ON;
		insert into facebook.VideosHist (Video_Hist_Id, Video_Id, Src_Video_Id, Video, Video_Quality, Video_Size_Mb, Video_Duration_Sec, Video_Watches,
										 Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime, Updated_Datetime)
		values (-1, -1, -1, 'Unknown', 'Unknown', -1, -1, -1, '1900-01-01', '3000-01-01', 1, 'Y', '1900-01-01', '1900-01-01');
		SET IDENTITY_INSERT facebook.VideosHist OFF;

		--Lookup tables
		SET IDENTITY_INSERT facebook.CommentsReactionsTypes ON;
		insert into facebook.CommentsReactionsTypes (Comment_Reaction_Type_Id, Comment_Reaction_Type, Inserted_Datetime)
		values (-1, 'Unknown', '1900-01-01');
		SET IDENTITY_INSERT facebook.CommentsReactionsTypes OFF;

		SET IDENTITY_INSERT facebook.RepliesReactionsTypes ON;
		insert into facebook.RepliesReactionsTypes (Reply_Reaction_Type_Id, Reply_Reaction_Type, Inserted_Datetime)
		values (-1, 'Unknown', '1900-01-01');
		SET IDENTITY_INSERT facebook.RepliesReactionsTypes OFF;

		----connection tables
		SET IDENTITY_INSERT facebook.CommentsReactionsHist ON;
		insert into facebook.CommentsReactionsHist (Comment_Reaction_Hist_Id, Comment_Reaction_Type_Id, User_Hist_Id, Comment_Hist_Id,
													Inserted_Datetime)
		values (-1, -1, -1, -1, '1900-01-01');
		SET IDENTITY_INSERT facebook.CommentsReactionsHist OFF;

		SET IDENTITY_INSERT facebook.CommentsRepliesHist ON;
		insert into facebook.CommentsRepliesHist (Comment_Reply_Id, Comment_Hist_Id, Reply_Hist_Id, Inserted_Datetime)
		values (-1, -1, -1, '1900-01-01');
		SET IDENTITY_INSERT facebook.CommentsRepliesHist OFF;

		SET IDENTITY_INSERT facebook.CommentsUsersHist ON;
		insert into facebook.CommentsUsersHist (Comment_User_Id, Comment_Hist_Id, User_Hist_Id, Inserted_Datetime)
		values (-1, -1, -1, '1900-01-01');
		SET IDENTITY_INSERT facebook.CommentsUsersHist OFF;

		SET IDENTITY_INSERT facebook.CompaniesPostsHist ON;
		insert into facebook.CompaniesPostsHist (Company_Post_Id, Company_Hist_Id, Post_Hist_Id, Inserted_Datetime)
		values (-1, -1, -1, '1900-01-01');
		SET IDENTITY_INSERT facebook.CompaniesPostsHist OFF;

		SET IDENTITY_INSERT facebook.PostsCommentsHist ON;
		insert into facebook.PostsCommentsHist (Post_Comment_Id, Post_Hist_Id, Comment_Hist_Id, Inserted_Datetime)
		values (-1, -1, -1, '1900-01-01');
		SET IDENTITY_INSERT facebook.PostsCommentsHist OFF;

		SET IDENTITY_INSERT facebook.PostsVideosHist ON;
		insert into facebook.PostsVideosHist (Post_Video_Id, Post_Hist_Id, Video_Hist_Id, Inserted_Datetime)
		values (-1, -1, -1, '1900-01-01');
		SET IDENTITY_INSERT facebook.PostsVideosHist OFF;

		SET IDENTITY_INSERT facebook.RepliesReactionsHist ON;
		insert into facebook.RepliesReactionsHist (Reply_Reaction_Hist_Id, Reply_Reaction_Type_Id, User_Hist_Id, Reply_Hist_Id,
												   Inserted_Datetime)
		values (-1, -1, -1, -1, '1900-01-01');
		SET IDENTITY_INSERT facebook.RepliesReactionsHist OFF;
	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_Posts]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_Posts](@input_date DATE)
AS
BEGIN
    IF @input_date IS NULL
        SET @input_date = CAST(GETDATE() AS DATE);

    IF OBJECT_ID(N'tempdb..#tmp_Posts') IS NOT NULL
        DROP TABLE #tmp_Posts

    SELECT CAST(TRIM(postID) AS BIGINT)     AS Src_Post_Id,
           TRIM(postText)                   AS Post_Text,
           CAST(TRIM(postTIme) AS DATETIME) AS Post_Time,
           TRIM(postURL)                    AS Post_Url,
           CAST(TRIM(postLikes) AS INT)     AS Post_Likes,
           CAST(TRIM(postComments) AS INT)  AS Post_Comments,
           CAST(TRIM(postShares) AS INT)    AS Post_Shares,
           LoadDate                         AS Post_LoadDate
    INTO #tmp_Posts
    FROM stage.telco.FacebookPosts
    WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE);

    MERGE INTO facebook.Posts AS Target
    USING #tmp_Posts AS Source
    ON Source.Src_Post_Id = Target.Src_Post_Id
        AND Target.Post_Id <> -1
    WHEN NOT MATCHED BY Target THEN
        INSERT (Src_Post_Id, Post_Text, Post_Time, Post_Url, Post_Likes, Post_Comments,
                Post_Shares, Post_LoadDate, Inserted_Datetime, Updated_Datetime)
        VALUES (Source.Src_Post_Id, Source.Post_Text, Source.Post_Time, Source.Post_Url,
                Source.Post_Likes, Source.Post_Comments, Source.Post_Shares,
                Source.Post_LoadDate, GETDATE(), GETDATE())
    WHEN MATCHED AND (Target.Post_Text <> Source.Post_Text OR
                      Target.Post_Time <> Source.Post_Time OR
                      Target.Post_Url <> Source.Post_Url OR
                      Target.Post_Likes <> Source.Post_Likes OR
                      Target.Post_Comments <> Source.Post_Comments OR
                      Target.Post_Shares <> Source.Post_Shares)
        THEN
        UPDATE
        SET Target.Post_Text        = Source.Post_Text,
            Target.Post_Time        = Source.Post_Time,
            Target.Post_Url         = Source.Post_Url,
            Target.Post_Likes       = Source.Post_Likes,
            Target.Post_Comments    = Source.Post_Comments,
            Target.Post_Shares      = Source.Post_Shares,
            Target.Post_LoadDate    = Source.Post_LoadDate,
            Target.Updated_Datetime = GETDATE();

--facebook.PostsHist
    MERGE INTO [facebook].[PostsHist] AS Target
    USING [facebook].[Posts] AS Source
    ON Source.Post_Id = Target.Post_Id AND Target.Current_Flag = 'Y'
    WHEN NOT MATCHED BY Target AND Source.Post_Id <> -1 THEN
        INSERT (Post_Id, Src_Post_Id, Post_Text, Post_Time, Post_Url, Post_Likes, Post_Comments,
                Post_Shares, Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
                Updated_Datetime)
        VALUES (Source.Post_Id, Source.Src_Post_Id, Source.Post_Text, Source.Post_Time,
                Source.Post_Url, Source.Post_Likes, Source.Post_Comments,
                Source.Post_Shares, dbo.fn_valid_from_seconds(Post_LoadDate),
                '3000-01-01', 1, 'Y', GETDATE(), GETDATE())

    WHEN MATCHED AND (Target.Post_Text <> Source.Post_Text OR
                      Target.Post_Time <> Source.Post_Time OR
                      Target.Post_Url <> Source.Post_Url OR
                      Target.Post_Likes <> Source.Post_Likes OR
                      Target.Post_Comments <> Source.Post_Comments OR
                      Target.Post_Shares <> Source.Post_Shares)
        THEN
        UPDATE
        SET Target.Valid_To         = DATEADD(SECOND, -1, dbo.fn_valid_from_seconds(Source.Post_LoadDate)),
            Target.Current_Flag     = 'N',
            Target.Updated_Datetime = GETDATE();

    INSERT INTO facebook.PostsHist (Post_Id, Src_Post_Id, Post_Text, Post_Time, Post_Url,
                                    Post_Likes, Post_Comments, Post_Shares, Valid_From,
                                    Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
                                    Updated_Datetime)
    SELECT Source.Post_Id,
           Source.Src_Post_Id,
           Source.Post_Text,
           Source.Post_Time,
           Source.Post_Url,
           Source.Post_Likes,
           Source.Post_Comments,
           Source.Post_Shares,
           dbo.fn_valid_from_seconds(Post_LoadDate) AS Valid_From,
           '3000-01-01'                             AS Valid_To,
           Seq_Id + 1                               AS Seq_Id,
           'Y'                                      AS Current_Flag,
           GETDATE()                                AS Inserted_Datetime,
           GETDATE()                                AS Updated_Datetime
    FROM [facebook].[PostsHist] AS Target
             JOIN [facebook].[Posts] AS Source
                  ON Source.Post_Id = Target.Post_Id
             JOIN (SELECT Post_Id, MAX(Seq_Id) Max_Seq_Id
                   FROM [facebook].[PostsHist]
                   GROUP BY Post_Id) AS FilterTable
                  ON Target.Post_Id = FilterTable.Post_Id AND Target.Seq_Id = FilterTable.Max_Seq_Id
    WHERE (Target.Post_Text <> Source.Post_Text OR
           Target.Post_Time <> Source.Post_Time OR
           Target.Post_Url <> Source.Post_Url OR
           Target.Post_Likes <> Source.Post_Likes OR
           Target.Post_Comments <> Source.Post_Comments OR
           Target.Post_Shares <> Source.Post_Shares)
      AND Target.Post_Hist_Id <> -1
      AND Source.Post_Id <> -1;
END;
GO

/****** Object:  StoredProcedure [facebook].[usp_PostsCommentsHist]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--facebook.PostsCommentsHist
CREATE   PROCEDURE [facebook].[usp_PostsCommentsHist] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

         DECLARE @input_datetime DATETIME
	     SET @input_datetime = DATEADD(SECOND,-1, CAST(DATEADD(DAY, 1, @input_date) AS DATETIME))

		IF OBJECT_ID (N'tempdb..#tmp_Videos') IS NOT NULL
		    DROP TABLE #tmp_PostsCommentsHist;

        SELECT  ISNULL(ph.Post_Hist_Id,-1) AS Post_Hist_id,
                ISNULL(ch.Comment_Hist_Id,-1) AS Comment_Hist_Id
        INTO #tmp_PostsCommentsHist
        FROM stage.telco.FacebookComments fc
        LEFT JOIN [facebook].[PostsHist] ph ON fc.postId = ph.Src_Post_Id
        LEFT JOIN [facebook].[CommentsHist] ch ON fc.commentId = ch.Src_Comment_Id
        WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
        AND @input_datetime BETWEEN ph.Valid_From AND ph.Valid_To
        AND @input_datetime BETWEEN ch.Valid_From AND ch.Valid_To
        AND ph.Post_Hist_Id<>-1
        AND ch.Comment_Hist_Id<>-1;

		MERGE INTO [facebook].[PostsCommentsHist] AS Target
        USING #tmp_PostsCommentsHist AS Source
		ON Target.Post_Hist_Id = Source.Post_Hist_id
		       AND Target.Comment_Hist_Id = Source.Comment_Hist_Id
		    AND Target.Post_Comment_Id <> -1
		WHEN NOT MATCHED BY Target THEN
		INSERT (Post_Hist_Id, Comment_Hist_Id, Inserted_Datetime)
		VALUES (Source.Post_Hist_id,Source.Comment_Hist_Id,GETDATE());
	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_PostsVideosHist]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_PostsVideosHist] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

         DECLARE @input_datetime DATETIME
	     SET @input_datetime = DATEADD(SECOND,-1, CAST(DATEADD(DAY, 1, @input_date) AS DATETIME))

		IF OBJECT_ID (N'tempdb..#tmp_PostsVideosHist') IS NOT NULL
		    DROP TABLE #tmp_PostsVideosHist;

		SELECT ISNULL(ph.Post_Hist_Id,-1) AS Post_Hist_Id,
			   ISNULL(vh.Video_Hist_Id,-1) AS Video_Hist_Id
        INTO #tmp_PostsVideosHist
		FROM stage.[telco].[FacebookPosts] fp
		LEFT JOIN [facebook].[PostsHist] ph ON fp.postID = ph.Src_Post_Id
		LEFT JOIN [facebook].[VideosHist] vh ON fp.videoId = vh.Src_Video_Id
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
		AND @input_datetime BETWEEN ph.Valid_From AND ph.Valid_To
		AND @input_datetime BETWEEN vh.Valid_From AND vh.Valid_To
	    AND ph.Post_Hist_Id<>-1
	    AND vh.Video_Hist_Id<>-1;

        MERGE INTO [facebook].[PostsVideosHist] AS Target
        USING #tmp_PostsVideosHist AS Source
        ON Target.Post_Hist_Id=Source.Post_Hist_Id AND Target.Video_Hist_Id=Source.Video_Hist_Id
	    AND Target.Post_Video_Id <> -1
	    WHEN NOT MATCHED BY Target THEN
				INSERT  (Post_Hist_Id, Video_Hist_Id, Inserted_Datetime)
				VALUES (Source.Post_Hist_Id,Source.Video_Hist_Id,GETDATE());

	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_Replies]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_Replies](@input_date DATE)
AS
BEGIN
    IF @input_date IS NULL
        SET @input_date = CAST(GETDATE() AS DATE)

    IF OBJECT_ID(N'tempdb..#tmp_Replies') IS NOT NULL
        DROP TABLE #tmp_Replies

    SELECT CAST(TRIM(replyId) AS BIGINT)     AS Src_Reply_Id,
           TRIM(replyText)                   AS Reply_Text,
           CAST(TRIM(replyTime) AS DATETIME) AS Reply_Time,
           TRIM(replyUrl)                    AS Reply_Url,
           TRIM(replyImage)                  AS Reply_Image,
           LoadDate                          AS Reply_LoadDate
    INTO #tmp_Replies
    FROM stage.telco.FacebookReplies
    WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)

    MERGE INTO [facebook].[Replies] AS Target
    USING #tmp_Replies AS Source
    ON Source.Src_Reply_Id = Target.Src_Reply_Id
        AND Target.Reply_Id <> -1
    WHEN NOT MATCHED THEN
        INSERT (Src_Reply_Id, Reply_Text, Reply_Time, Reply_Url, Reply_Image, Reply_LoadDate,
                Inserted_Datetime, Updated_Datetime)
        VALUES (Source.Src_Reply_Id, Source.Reply_Text, Source.Reply_Time, Source.Reply_Url,
                Source.Reply_Image, Source.Reply_LoadDate, GETDATE(), GETDATE())
    WHEN MATCHED AND (Target.Reply_Text <> Source.Reply_Text OR
                      Target.Reply_Time <> Source.Reply_Time OR
                      Target.Reply_Url <> Source.Reply_Url OR
                      Target.Reply_Image <> Source.Reply_Image)
        THEN
        UPDATE
        SET Target.Reply_Text       = Source.Reply_Text,
            Target.Reply_Time       = Source.Reply_Time,
            Target.Reply_Url        = Source.Reply_Url,
            Target.Reply_Image      = Source.Reply_Image,
            Target.Reply_LoadDate   = Source.Reply_LoadDate,
            Target.Updated_Datetime = GETDATE();

--facebook.RepliesHist
    MERGE INTO [facebook].[RepliesHist] AS Target
    USING [facebook].[Replies] AS Source
    ON Source.Reply_Id = Target.Reply_Id AND Target.Current_Flag = 'Y'
    WHEN NOT MATCHED BY Target AND Source.Reply_Id <> -1 THEN
        INSERT (Reply_Id, Src_Reply_Id, Reply_Text, Reply_Time, Reply_Url, Reply_Image,
                Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
                Updated_Datetime)
        VALUES (Source.Reply_Id, Source.Src_Reply_Id, Source.Reply_Text,
                Source.Reply_Time, Source.Reply_Url, Source.Reply_Image,
                dbo.fn_valid_from_seconds(Reply_LoadDate),
                '3000-01-01', 1, 'Y', GETDATE(), GETDATE())
    WHEN MATCHED AND (Target.Reply_Text <> Source.Reply_Text OR
                      Target.Reply_Time <> Source.Reply_Time OR
                      Target.Reply_Url <> Source.Reply_Url OR
                      Target.Reply_Image <> Source.Reply_Image)
        THEN
        UPDATE
        SET Target.Valid_To         = DATEADD(SECOND, -1, dbo.fn_valid_from_seconds(Source.Reply_LoadDate)),
            Target.Current_Flag     = 'N',
            Target.Updated_Datetime = GETDATE();

    INSERT INTO [facebook].[RepliesHist]
    (Reply_Id, Src_Reply_Id, Reply_Text, Reply_Time, Reply_Url, Reply_Image,
     Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime,
     Updated_Datetime)
    SELECT Source.Reply_Id,
           Source.Src_Reply_Id,
           Source.Reply_Text,
           Source.Reply_Time,
           Source.Reply_Url,
           Source.Reply_Image,
           dbo.fn_valid_from_seconds(Reply_LoadDate) AS Valid_From,
           '3000-01-01'                              AS Valid_To,
           Seq_Id + 1                                AS Seq_Id,
           'Y'                                       AS Current_Flag,
           GETDATE()                                 AS Inserted_Datetime,
           GETDATE()                                 AS Updated_Datetime
    FROM [facebook].[RepliesHist] AS Target
             JOIN [facebook].[Replies] AS Source
                  ON Source.Reply_Id = Target.Reply_Id
             JOIN (SELECT Reply_Id, MAX(Seq_id) AS Max_Seq_id
                   FROM [facebook].[RepliesHist]
                   GROUP BY Reply_Id) AS FilterTable
                  ON Target.Reply_Id = FilterTable.Reply_Id AND Target.Seq_Id = FilterTable.Max_Seq_id
    WHERE (Target.Reply_Text <> Source.Reply_Text OR
           Target.Reply_Time <> Source.Reply_Time OR
           Target.Reply_Url <> Source.Reply_Url OR
           Target.Reply_Image <> Source.Reply_Image)
      AND Target.Reply_Hist_Id <> -1
      AND Source.Reply_Id <> -1;
END;
GO

/****** Object:  StoredProcedure [facebook].[usp_RepliesReactionsHist]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_RepliesReactionsHist] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

         DECLARE @input_datetime DATETIME
	     SET @input_datetime = DATEADD(SECOND,-1, CAST(DATEADD(DAY, 1, @input_date) AS DATETIME))

		IF OBJECT_ID (N'tempdb..#tmp_RepliesReactionsHist') IS NOT NULL
		    DROP TABLE #tmp_RepliesReactionsHist;

        SELECT DISTINCT ISNULL(rrt.Reply_Reaction_Type_Id,-1) AS Reply_Reaction_Type_Id,
                   ISNULL(uh.User_Hist_Id,-1) AS User_Hist_Id,
                   ISNULL(rh.Reply_Hist_Id,-1) AS Reply_Hist_Id
		INTO #tmp_RepliesReactionsHist
		FROM stage.[telco].[FacebookRepliesReactions] frr
		LEFT JOIN [facebook].[RepliesHist] rh ON frr.replyId = rh.Src_Reply_Id
		LEFT JOIN [facebook].[UsersHist] uh ON facebook.f_remove_url_reactions(frr.replyReactionUserUrl) = uh.User_Account_Name
		LEFT JOIN [facebook].[RepliesReactionsTypes] rrt ON frr.replyReactionUserType = rrt.Reply_Reaction_Type
		WHERE CAST(frr.LoadDate AS DATE) = CAST('2021-08-28' AS DATE)
		AND @input_datetime BETWEEN ISNULL(rh.Valid_From,'1900-01-01') AND ISNULL(rh.Valid_To,'3000-01-01')
		AND @input_datetime BETWEEN ISNULL(uh.Valid_From,'1900-01-01') AND ISNULL(uh.Valid_To,'3000-01-01');

		MERGE INTO [facebook].[RepliesReactionsHist] AS Target
        USING #tmp_RepliesReactionsHist AS Source
        ON Target.Reply_Reaction_Type_Id=Source.Reply_Reaction_Type_Id
               AND Target.Reply_Hist_Id=Source.Reply_Hist_Id
               AND Target.User_Hist_Id=Source.User_Hist_Id
	    AND Target.Reply_Reaction_Hist_Id <> -1
	    WHEN NOT MATCHED BY Target THEN
		INSERT   (Reply_Reaction_Type_Id, User_Hist_Id, Reply_Hist_Id, Inserted_Datetime)
		VALUES (Source.Reply_Reaction_Type_Id,Source.User_Hist_Id,Source.Reply_Hist_Id,GETDATE());

	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_RepliesReactionsTypes]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--facebook.RepliesReactionsTypes
CREATE   PROCEDURE [facebook].[usp_RepliesReactionsTypes] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

		IF OBJECT_ID (N'tempdb..#tmp_RepliesReactions') IS NOT NULL
		DROP TABLE #tmp_RepliesReactions

		SELECT TRIM(replyReactionUserType) AS Reply_Reaction_Type
		INTO #tmp_RepliesReactions
		FROM stage.[telco].[FacebookRepliesReactions]
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
		GROUP BY replyReactionUserType

		MERGE INTO [facebook].[RepliesReactionsTypes] AS Target
		USING #tmp_RepliesReactions AS Source
		ON Target.Reply_Reaction_Type = Source.Reply_Reaction_Type
		    AND Target.Reply_Reaction_Type_Id<>-1
		WHEN NOT MATCHED BY Target THEN
			INSERT (Reply_Reaction_Type, Inserted_Datetime)
			VALUES (Source.Reply_Reaction_Type, GETDATE());
	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_run_load_of_RDL]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [facebook].[usp_run_load_of_RDL] AS
	BEGIN
	--1. deklariranje obične varijable
	DECLARE @date DATE  
	DECLARE @flag CHAR(1) = 'Y'

	--2. deklariranje kursora
	DECLARE db_cursor CURSOR FOR  
	SELECT DISTINCT CAST(LoadDate AS DATE)
	FROM stage.telco.FacebookUsers
	--GROUP BY CAST(LoadDate AS DATE)
	ORDER BY CAST(LoadDate AS DATE)

	--3. otvaranje kursora
	OPEN db_cursor

	--4. dohvaćanje prvog reda iz kursora i spremanje u običnu varijablu
	FETCH NEXT FROM db_cursor INTO @date

	--5. While petlja (dok ima redova, ostaje u while petlji)
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		IF @date <> '2021-08-28'
			SET @flag = 'N'
		PRINT 'LoadDate is ' + CAST(@date AS VARCHAR)
		BEGIN TRY
			EXEC [facebook].[usp_insert_RDL_tables] @flag, @date
		END TRY 
		BEGIN CATCH
		SELECT   
			 ERROR_NUMBER() AS ErrorNumber  
			,ERROR_MESSAGE() AS ErrorMessage
			, @date AS LoadDate
			BREAK;
		END CATCH
	--6. dohvaćanje sljedećeg reda
		FETCH NEXT FROM db_cursor INTO @date
	END
	--7. zatvaranje kursora
	CLOSE db_cursor 
	--8. Brisanje iz memorije
	DEALLOCATE db_cursor
END
GO

/****** Object:  StoredProcedure [facebook].[usp_Users]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_Users] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE)

		IF OBJECT_ID (N'tempdb..#tmp_Users') IS NOT NULL
		DROP TABLE #tmp_Users

		SELECT CAST(TRIM(userId) AS BIGINT) AS Src_User_Id,
			   TRIM(userName) AS User_Name,
			   TRIM(userAccountName) AS User_Account_Name,
				dbo.fn_extract_year_from_userbasicinfo (userBasicInfo) AS User_BirthYear,
			   CASE WHEN userBasicInfo LIKE '%Female%' THEN 'Female'
					WHEN userBasicInfo LIKE '%Male%' THEN 'Male' 
					ELSE dbo.fn_convert_name_to_gender (TRIM(userName)) END AS User_Gender,
			  CASE WHEN userEducation like '%College%' THEN 'College'
					WHEN userEducation like '%fakultet%' THEN 'College'
					WHEN userEducation like '%Graduate School%' THEN 'College'
					WHEN userEducation like '%High School%' THEN 'High School'
			   ELSE 'Unknown' END AS User_Education,
			   [dbo].[fn_extract_city_hometown] (userPlacesLived,'Current City') as User_Current_City,
			   [dbo].[fn_extract_city_hometown] (userPlacesLived,'Hometown') as User_Hometown,
			   CASE WHEN userRelationship LIKE '%Married%' THEN 'Married'
					WHEN userRelationship LIKE '%relationship%' THEN 'In a relationship'
					WHEN userRelationship LIKE '%Engaged%' THEN 'Engaged'
					WHEN userRelationship LIKE '%civil union' THEN 'In a civil union'
					WHEN userRelationship LIKE '%Widowed%' THEN 'Widowed'
					WHEN userRelationship LIKE '%Divorced%' THEN 'Divorced'
					ELSE 'Unknown' END AS User_Relationship,
				CASE WHEN userProfilePicture IS NOT NULL THEN TRIM(userProfilePicture)
					 ELSE 'Unknown' END AS User_Profile_Picture,
				CASE WHEN userCoverPhoto IS NOT NULL THEN TRIM(userProfilePicture)
					 ELSE 'Unknown' END AS User_Cover_Photo,
				LoadDate AS User_LoadDate
		INTO #tmp_Users
		FROM stage.telco.FacebookUsers
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)

		MERGE INTO [facebook].[Users] AS Target
		USING #tmp_Users AS Source
		ON Target.Src_User_Id = Source.Src_User_Id
		    AND Target.User_Id <> -1
		WHEN NOT MATCHED BY Target THEN
			INSERT (Src_User_Id, User_Name, User_Account_Name, User_Birthyear, User_Gender,
					User_Education, User_Current_City, User_Hometown, User_Relationship, 
					User_Profile_Picture, User_Cover_Photo, User_LoadDate,
					Inserted_Datetime, Updated_Datetime)
			VALUES (Source.Src_User_Id, Source.User_Name, Source.User_Account_Name, 
					Source.User_Birthyear, Source.User_Gender, Source.User_Education,
					Source.User_Current_City, Source.User_Hometown, Source.User_Relationship,
					Source.User_Profile_Picture, Source.User_Cover_Photo,
					Source.User_LoadDate, GETDATE(), GETDATE())
		WHEN MATCHED AND (Target.User_Name <> Source.User_Name OR
						  Target.User_Account_Name <> Source.User_Account_Name OR
						  Target.User_Birthyear <> Source.User_Birthyear OR
						  Target.User_Gender <> Source.User_Gender OR
						  Target.User_Education <> Source.User_Education OR
						  Target.User_Current_City <> Source.User_Current_City OR
						  Target.User_Hometown <> Source.User_Hometown OR
						  Target.User_Relationship <> Source.User_Relationship OR
						  Target.User_Profile_Picture <> Source.User_Profile_Picture OR
						  Target.User_Cover_Photo <> Source.User_Cover_Photo)
		THEN UPDATE SET 
		Target.User_Name = Source.User_Name,
		Target.User_Account_Name = Source.User_Account_Name,
		Target.User_Birthyear = Source.User_Birthyear,
		Target.User_Gender = Source.User_Gender,
		Target.User_Education = Source.User_Education,
		Target.User_Current_City = Source.User_Current_City,
		Target.User_Hometown = Source.User_Hometown,
		Target.User_Relationship = Source.User_Relationship,
		Target.User_Profile_Picture = Source.User_Profile_Picture,
		Target.User_Cover_Photo = Source.User_Cover_Photo,
		Target.User_LoadDate = Source.User_LoadDate,
		Target.Updated_Datetime = GETDATE();

--facebook.UsersHist
		MERGE INTO [facebook].[UsersHist] AS Target
		USING [facebook].[Users] AS Source
		ON Source.User_Id = Target.User_Id AND Target.Current_Flag = 'Y'
		WHEN NOT MATCHED BY Target AND Source.User_Id <> -1 THEN
			INSERT (User_Id, Src_User_Id, User_Name, User_Account_Name, User_Birthyear, User_Gender,
					User_Education, User_Current_City, User_Hometown, User_Relationship, 
					User_Profile_Picture, User_Cover_Photo, 
					Valid_From, Valid_To, Seq_Id, Current_Flag, Inserted_Datetime, Updated_Datetime)
			VALUES (Source.User_Id, Source.Src_User_Id, Source.User_Name, Source.User_Account_Name, 
					Source.User_Birthyear, Source.User_Gender, Source.User_Education,
					Source.User_Current_City, Source.User_Hometown, Source.User_Relationship,
					Source.User_Profile_Picture, Source.User_Cover_Photo,
					dbo.fn_valid_from_seconds(User_LoadDate),
					'3000-01-01', 1, 'Y', GETDATE(), GETDATE())
		WHEN MATCHED AND (Target.User_Name <> Source.User_Name OR
						  Target.User_Account_Name <> Source.User_Account_Name OR
						  Target.User_Birthyear <> Source.User_Birthyear OR
						  Target.User_Gender <> Source.User_Gender OR
						  Target.User_Education <> Source.User_Education OR
						  Target.User_Current_City <> Source.User_Current_City OR
						  Target.User_Hometown <> Source.User_Hometown OR
						  Target.User_Relationship <> Source.User_Relationship OR
						  Target.User_Profile_Picture <> Source.User_Profile_Picture OR
						  Target.User_Cover_Photo <> Source.User_Cover_Photo)
		THEN UPDATE SET
			Target.Valid_To = DATEADD(SECOND,-1,dbo.fn_valid_from_seconds(Source.User_LoadDate)), 
			Target.Current_Flag = 'N',
			Target.Updated_Datetime = GETDATE();

		INSERT INTO [facebook].[UsersHist] 
									 (User_Id, Src_User_Id, User_Name, User_Account_Name, 
									  User_Birthyear, User_Gender, User_Education, User_Current_City, 
									  User_Hometown, User_Relationship,
									  User_Profile_Picture, User_Cover_Photo, Valid_From, Valid_To, 
									  Seq_Id, Current_Flag, Inserted_Datetime, Updated_Datetime)
		SELECT Source.User_Id, 
			   Source.Src_User_Id, 
			   Source.User_Name, 
			   Source.User_Account_Name, 
			   Source.User_Birthyear, 
			   Source.User_Gender, 
			   Source.User_Education,
			   Source.User_Current_City, 
			   Source.User_Hometown, 
			   Source.User_Relationship, 
			   Source.User_Profile_Picture, 
			   Source.User_Cover_Photo,
			   dbo.fn_valid_from_seconds(User_LoadDate) AS Valid_From,
			   '3000-01-01' AS Valid_To,
			   Seq_Id+1 AS Seq_Id,
			   'Y' AS Current_Flag,
			   GETDATE() AS Inserted_Datetime,
			   GETDATE() AS Updated_Datetime
		FROM facebook.UsersHist AS Target
		JOIN facebook.Users AS Source
		ON Source.User_Id = Target.User_Id
		JOIN (SELECT User_Id, MAX(Seq_Id) AS Max_Seq_Id
			  FROM facebook.UsersHIst
			  GROUP BY User_Id) AS FilterTable
		ON Target.User_Id = FilterTable.User_Id AND Target.Seq_Id = FilterTable.Max_Seq_Id
		WHERE (Target.User_Name <> Source.User_Name OR
			   Target.User_Account_Name <> Source.User_Account_Name OR
			   Target.User_Birthyear <> Source.User_Birthyear OR
			   Target.User_Gender <> Source.User_Gender OR
			   Target.User_Education <> Source.User_Education OR
			   Target.User_Current_City <> Source.User_Current_City OR
			   Target.User_Hometown <> Source.User_Hometown OR
			   Target.User_Relationship <> Source.User_Relationship OR
			   Target.User_Profile_Picture <> Source.User_Profile_Picture OR
			   Target.User_Cover_Photo <> Source.User_Cover_Photo)
	          AND Target.User_Hist_Id <> -1
      AND Source.User_Id <> -1;
	END;
GO

/****** Object:  StoredProcedure [facebook].[usp_Videos]    Script Date: 21.10.2022. 13:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [facebook].[usp_Videos] (@input_date DATE)
AS
	BEGIN
		IF @input_date IS NULL
			SET @input_date = CAST(GETDATE() AS DATE);

		IF OBJECT_ID (N'tempdb..#tmp_Videos') IS NOT NULL
		DROP TABLE #tmp_Videos;

		SELECT CAST(TRIM(videoId) AS BIGINT) AS Src_Video_Id,
			   TRIM(video) AS Video,
			   TRIM(videoQuality) AS Video_Quality,
			   CAST(TRIM(videoSizeMb) AS DECIMAL) AS Video_Size_Mb,
			   CAST(TRIM(videoDurationSeconds) AS INT) AS Video_Duration_Sec,
			   CAST(TRIM(videoWatches) AS INT) AS Video_Watches,
			   LoadDate AS Video_LoadDate
		INTO #tmp_Videos
		FROM stage.telco.FacebookPosts
		WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)
		AND videoId is not null;

		MERGE INTO [facebook].[Videos] AS Target
		USING #tmp_Videos AS Source
		ON Target.Src_Video_Id = Source.Src_Video_Id
		    AND Target.Video_Id <> -1
		WHEN NOT MATCHED BY Target THEN
			INSERT (Src_Video_Id, Video, Video_Quality, Video_Size_Mb, Video_Duration_Sec, Video_Watches,
					Video_LoadDate, Inserted_Datetime, Updated_Datetime)
			VALUES (Source.Src_Video_Id, Source.Video, Source.Video_Quality, Source.Video_Size_Mb,
					Source.Video_Duration_Sec, Source.Video_Watches, Source.Video_LoadDate,
					GETDATE(), GETDATE())
		WHEN MATCHED AND (Target.Video <> Source.Video OR
						  Target.Video_Quality <> Source.Video_Quality OR
						  Target.Video_Size_Mb <> Source.Video_Size_Mb OR
						  Target.Video_Duration_Sec <> Source.Video_Duration_Sec OR
						  Target.Video_Watches <> Source.Video_Watches)
		THEN UPDATE SET
			Target.Video = Source.Video,
			Target.Video_Quality = Source.Video_Quality,
			Target.Video_Size_Mb = Source.Video_Size_Mb,
			Target.Video_Duration_Sec = Source.Video_Duration_Sec,
			Target.Video_Watches = Source.Video_Watches,
			Target.Video_LoadDate = Source.Video_LoadDate,
			Target.Updated_Datetime = GETDATE();

--facebook.VideosHist
		MERGE INTO [facebook].[VideosHist] AS Target
		USING [facebook].[Videos] AS Source
		ON Target.Video_Id = Source.Video_Id AND Target.Current_Flag = 'Y'
		WHEN NOT MATCHED BY Target AND Source.Video_Id <> -1 THEN
			INSERT (Video_Id, Src_Video_Id, Video, Video_Quality, Video_Size_Mb, Video_Duration_Sec,
					Video_Watches, Valid_From, Valid_To, Seq_Id, Current_Flag, 
					Inserted_Datetime, Updated_Datetime)
			VALUES (Source.Video_Id, Source.Src_Video_Id, Source.Video, Source.Video_Quality,
					Source.Video_Size_Mb, Source.Video_Duration_Sec, Source.Video_Watches,
					dbo.fn_valid_from_seconds(Video_LoadDate), '3000-01-01', 1, 'Y', 
					GETDATE(), GETDATE())
		WHEN MATCHED AND (Target.Video <> Source.Video OR
						  Target.Video_Quality <> Source.Video_Quality OR
						  Target.Video_Size_Mb <> Source.Video_Size_Mb OR
						  Target.Video_Duration_Sec <> Source.Video_Duration_Sec OR
						  Target.Video_Watches <> Source.Video_Watches)

		THEN UPDATE SET
			Target.Valid_To = DATEADD(SECOND,-1,dbo.fn_valid_from_seconds(Source.Video_LoadDate)), 
			Target.Current_Flag = 'N',
			Target.Updated_Datetime = GETDATE();

		INSERT INTO [facebook].[VideosHist] 
			(Video_Id, Src_Video_Id, Video, Video_Quality, Video_Size_Mb, Video_Duration_Sec,
			 Video_Watches, Valid_From, Valid_To, Seq_Id, Current_Flag, 
			 Inserted_Datetime, Updated_Datetime)
		SELECT Source.Video_Id,
			   Source.Src_Video_Id,
			   Source.Video,
			   Source.Video_Quality,
			   Source.Video_Size_Mb,
			   Source.Video_Duration_Sec,
			   Source.Video_Watches,
			   dbo.fn_valid_from_seconds(Source.Video_LoadDate) AS Valid_From,
			   '3000-01-01' AS Valid_To,
			   Seq_Id+1 AS Seq_Id,
			   'Y' AS Current_Flag,
			   GETDATE() AS Inserted_Datetime,
			   GETDATE() AS Updated_Datetime
		FROM [facebook].[VideosHist] AS Target
		JOIN [facebook].[Videos] AS Source
		ON Source.Video_Id = Target.Video_Id
		JOIN (SELECT Video_Id, MAX(Seq_Id) Max_Seq_Id
			  FROM [facebook].[VideosHist]
			  GROUP BY Video_Id) AS FilterTable
		ON Target.Video_Id = FilterTable.Video_Id AND Target.Seq_Id = FilterTable.Max_Seq_Id
		WHERE (Target.Video <> Source.Video OR
			   Target.Video_Quality <> Source.Video_Quality OR
			   Target.Video_Size_Mb <> Source.Video_Size_Mb OR
			   Target.Video_Duration_Sec <> Source.Video_Duration_Sec OR
			   Target.Video_Watches <> Source.Video_Watches)
	    	          AND Target.Video_Hist_Id <> -1
      AND Source.Video_Id <> -1;
	END;
GO

USE [RDL]
GO

/****** Object:  UserDefinedFunction [facebook].[f_remove_url_reactions]    Script Date: 21.10.2022. 13:08:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [facebook].[f_remove_url_reactions] (@user_url NVARCHAR(100))
RETURNS NVARCHAR(100) AS
BEGIN
RETURN
    REPLACE (
        REPLACE(
            REPLACE(
                REPLACE(TRIM(@user_url),'https://www.facebook.com/',''),'https://facebook.com/','')
        ,'?fref=pb',''),
    '/','')
END
GO

