USE [RDL]
GO

/****** Object:  Table [facebook].[Comments]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[Comments](
	[Comment_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Src_Comment_Id] [bigint] NOT NULL,
	[Comment_Text] [nvarchar](4000) NOT NULL,
	[Comment_Time] [datetime] NOT NULL,
	[Comment_Url] [nvarchar](200) NOT NULL,
	[Comment_Image] [nvarchar](1000) NULL,
	[Comment_LoadDate] [datetime] NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_Comments_Comment_Id] PRIMARY KEY CLUSTERED 
(
	[Comment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_Comments_Src_Comment_Id] UNIQUE NONCLUSTERED 
(
	[Src_Comment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[CommentsHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[CommentsHist](
	[Comment_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comment_Id] [bigint] NOT NULL,
	[Src_Comment_Id] [bigint] NOT NULL,
	[Comment_Text] [nvarchar](4000) NOT NULL,
	[Comment_Time] [datetime] NOT NULL,
	[Comment_Url] [nvarchar](200) NOT NULL,
	[Comment_Image] [nvarchar](1000) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_CommentsHist_Comment_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Comment_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_CommentsHist_Src_Comment_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Comment_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[CommentsReactionsHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[CommentsReactionsHist](
	[Comment_Reaction_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comment_Reaction_Type_Id] [bigint] NOT NULL,
	[User_Hist_Id] [bigint] NOT NULL,
	[Comment_Hist_Id] [bigint] NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_CommentsReactionsHist_Comment_Reaction_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Comment_Reaction_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[CommentsReactionsTypes]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[CommentsReactionsTypes](
	[Comment_Reaction_Type_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comment_Reaction_Type] [nvarchar](50) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_CommentsReactionsTypes_Comment_Reaction_Type_Id] PRIMARY KEY CLUSTERED 
(
	[Comment_Reaction_Type_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_CommentsReactionsTypes_Comment_Reaction_Type] UNIQUE NONCLUSTERED 
(
	[Comment_Reaction_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[CommentsRepliesHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[CommentsRepliesHist](
	[Comment_Reply_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comment_Hist_Id] [bigint] NOT NULL,
	[Reply_Hist_Id] [bigint] NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_CommentsRepliesHist_Comment_Reply_Id] PRIMARY KEY CLUSTERED 
(
	[Comment_Reply_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[CommentsUsersHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[CommentsUsersHist](
	[Comment_User_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comment_Hist_Id] [bigint] NOT NULL,
	[User_Hist_Id] [bigint] NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_CommentsUsersHist_Comment_User_Id] PRIMARY KEY CLUSTERED 
(
	[Comment_User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[Companies]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[Companies](
	[Company_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Company_Name] [nvarchar](200) NOT NULL,
	[Company_Type] [nvarchar](100) NULL,
	[Company_Account_Name] [nvarchar](200) NOT NULL,
	[Company_Image] [nvarchar](1000) NULL,
	[Company_About] [nvarchar](4000) NOT NULL,
	[Company_Likes] [int] NOT NULL,
	[Company_LoadDate] [datetime] NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_Companies_Company_Id] PRIMARY KEY CLUSTERED 
(
	[Company_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_Companies_Company_Account_Name] UNIQUE NONCLUSTERED 
(
	[Company_Account_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[CompaniesHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[CompaniesHist](
	[Company_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Company_Id] [bigint] NOT NULL,
	[Company_Name] [nvarchar](200) NOT NULL,
	[Company_Account_Name] [nvarchar](200) NOT NULL,
	[Company_Type] [nvarchar](100) NULL,
	[Company_Image] [nvarchar](1000) NULL,
	[Company_About] [nvarchar](4000) NOT NULL,
	[Company_Likes] [int] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_CompaniesHist_Company_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Company_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_CompaniesHist_Company_Account_Name_Valid_From] UNIQUE NONCLUSTERED 
(
	[Company_Account_Name] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[CompaniesPostsHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[CompaniesPostsHist](
	[Company_Post_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Company_Hist_Id] [bigint] NOT NULL,
	[Post_Hist_Id] [bigint] NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_CompaniesPostsHist_Company_Post_Id] PRIMARY KEY CLUSTERED 
(
	[Company_Post_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[DIM_Comments]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[DIM_Comments](
	[Dim_Comment_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Comment_Id] [bigint] NOT NULL,
	[Src_Comment_Id] [bigint] NOT NULL,
	[Comment_Text] [nvarchar](4000) NOT NULL,
	[Comment_Time] [datetime] NOT NULL,
	[Comment_Url] [nvarchar](200) NOT NULL,
	[Comment_Image] [nvarchar](1000) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_DIM_Comments_Comment_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Dim_Comment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_DIM_Comments_Src_Comment_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Comment_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[DIM_Companies]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[DIM_Companies](
	[Dim_Company_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Company_Id] [bigint] NOT NULL,
	[Company_Name] [nvarchar](200) NOT NULL,
	[Company_Account_Name] [nvarchar](200) NOT NULL,
	[Company_Type] [nvarchar](100) NULL,
	[Company_Image] [nvarchar](1000) NULL,
	[Company_About] [nvarchar](4000) NOT NULL,
	[Company_Likes] [int] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_Dim_Companies_Company_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Dim_Company_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_DIM_Companies_Company_Account_Name_Valid_From] UNIQUE NONCLUSTERED 
(
	[Company_Account_Name] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[DIM_Posts]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[DIM_Posts](
	[Dim_Post_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Post_Id] [bigint] NOT NULL,
	[Src_Post_Id] [bigint] NOT NULL,
	[Post_Text] [nvarchar](4000) NOT NULL,
	[Post_Time] [datetime] NOT NULL,
	[Post_Url] [nvarchar](2000) NOT NULL,
	[Post_Likes] [int] NOT NULL,
	[Post_Comments] [int] NOT NULL,
	[Post_Shares] [int] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_DIM_Posts_Post_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Dim_Post_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_DIM_Posts_Src_Post_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Post_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[DIM_Replies]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[DIM_Replies](
	[Dim_Reply_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Reply_Id] [bigint] NOT NULL,
	[Src_Reply_Id] [bigint] NOT NULL,
	[Reply_Text] [nvarchar](4000) NOT NULL,
	[Reply_Time] [datetime] NOT NULL,
	[Reply_Url] [nvarchar](200) NOT NULL,
	[Reply_Image] [nvarchar](1000) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_DIM_Replies_Reply_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Dim_Reply_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_DIM_Replies_Src_Reply_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Reply_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[DIM_Users]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[DIM_Users](
	[Dim_User_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[User_Id] [bigint] NOT NULL,
	[Src_User_Id] [bigint] NOT NULL,
	[User_Name] [nvarchar](200) NOT NULL,
	[User_Account_Name] [nvarchar](200) NOT NULL,
	[User_Birthyear] [int] NULL,
	[User_Gender] [nvarchar](20) NULL,
	[User_Education] [nvarchar](200) NULL,
	[User_Current_City] [nvarchar](200) NULL,
	[User_Hometown] [nvarchar](200) NULL,
	[User_Relationship] [nvarchar](200) NULL,
	[User_Profile_Picture] [varchar](1000) NULL,
	[User_Cover_Photo] [varchar](1000) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_DIM_Users_User_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Dim_User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_DIM_Users_Src_User_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_User_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[DIM_Videos]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[DIM_Videos](
	[Dim_Video_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Video_Id] [bigint] NOT NULL,
	[Src_Video_Id] [bigint] NOT NULL,
	[Video] [nvarchar](4000) NOT NULL,
	[Video_Quality] [nvarchar](20) NULL,
	[Video_Size_Mb] [decimal](18, 0) NULL,
	[Video_Duration_Sec] [int] NULL,
	[Video_Watches] [int] NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_DIM_Videos_Video_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Dim_Video_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_DIM_Videos_Src_Video_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Video_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[Posts]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[Posts](
	[Post_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Src_Post_Id] [bigint] NOT NULL,
	[Post_Text] [nvarchar](4000) NOT NULL,
	[Post_Time] [datetime] NOT NULL,
	[Post_Url] [nvarchar](2000) NOT NULL,
	[Post_Likes] [int] NOT NULL,
	[Post_Comments] [int] NOT NULL,
	[Post_Shares] [int] NOT NULL,
	[Post_LoadDate] [datetime] NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_Posts_Post_Id] PRIMARY KEY CLUSTERED 
(
	[Post_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_Posts_Src_Post_Id] UNIQUE NONCLUSTERED 
(
	[Src_Post_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[PostsCommentsHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[PostsCommentsHist](
	[Post_Comment_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Post_Hist_Id] [bigint] NOT NULL,
	[Comment_Hist_Id] [bigint] NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_PostsCommentsHist_Post_Comment_Id] PRIMARY KEY CLUSTERED 
(
	[Post_Comment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[PostsHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[PostsHist](
	[Post_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Post_Id] [bigint] NOT NULL,
	[Src_Post_Id] [bigint] NOT NULL,
	[Post_Text] [nvarchar](4000) NOT NULL,
	[Post_Time] [datetime] NOT NULL,
	[Post_Url] [nvarchar](2000) NOT NULL,
	[Post_Likes] [int] NOT NULL,
	[Post_Comments] [int] NOT NULL,
	[Post_Shares] [int] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_PostsHist_Post_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Post_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_PostsHist_Src_Post_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Post_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[PostsVideosHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[PostsVideosHist](
	[Post_Video_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Post_Hist_Id] [bigint] NOT NULL,
	[Video_Hist_Id] [bigint] NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_PostsVideosHist_Post_Video_Id] PRIMARY KEY CLUSTERED 
(
	[Post_Video_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[Replies]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[Replies](
	[Reply_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Src_Reply_Id] [bigint] NOT NULL,
	[Reply_Text] [nvarchar](4000) NOT NULL,
	[Reply_Time] [datetime] NOT NULL,
	[Reply_Url] [nvarchar](200) NOT NULL,
	[Reply_Image] [nvarchar](1000) NULL,
	[Reply_LoadDate] [datetime] NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_Replies_Reply_Id] PRIMARY KEY CLUSTERED 
(
	[Reply_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_Replies_Src_Reply_Id] UNIQUE NONCLUSTERED 
(
	[Src_Reply_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[RepliesHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[RepliesHist](
	[Reply_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Reply_Id] [bigint] NOT NULL,
	[Src_Reply_Id] [bigint] NOT NULL,
	[Reply_Text] [nvarchar](4000) NOT NULL,
	[Reply_Time] [datetime] NOT NULL,
	[Reply_Url] [nvarchar](200) NOT NULL,
	[Reply_Image] [nvarchar](1000) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_RepliesHist_Reply_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Reply_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_RepliesHist_Src_Reply_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Reply_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[RepliesReactionsHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[RepliesReactionsHist](
	[Reply_Reaction_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Reply_Reaction_Type_Id] [bigint] NOT NULL,
	[User_Hist_Id] [bigint] NOT NULL,
	[Reply_Hist_Id] [bigint] NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_RepliesReactionsHist_Reply_Reaction_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Reply_Reaction_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[RepliesReactionsTypes]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[RepliesReactionsTypes](
	[Reply_Reaction_Type_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Reply_Reaction_Type] [nvarchar](50) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
 CONSTRAINT [pk_RepliesReactionsTypes_Reply_Reaction_Type_Id] PRIMARY KEY CLUSTERED 
(
	[Reply_Reaction_Type_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_RepliesReactionsTypes_Reply_Reaction_Type] UNIQUE NONCLUSTERED 
(
	[Reply_Reaction_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[Table_Checking]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[Table_Checking](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SQL_Query] [nvarchar](max) NULL,
	[Expected_Result] [tinyint] NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [facebook].[Users]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[Users](
	[User_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Src_User_Id] [bigint] NOT NULL,
	[User_Name] [nvarchar](200) NOT NULL,
	[User_Account_Name] [nvarchar](200) NOT NULL,
	[User_Birthyear] [int] NULL,
	[User_Gender] [nvarchar](20) NULL,
	[User_Education] [nvarchar](200) NULL,
	[User_Current_City] [nvarchar](200) NULL,
	[User_Hometown] [nvarchar](200) NULL,
	[User_Relationship] [nvarchar](200) NULL,
	[User_Profile_Picture] [nvarchar](1000) NULL,
	[User_Cover_Photo] [nvarchar](1000) NULL,
	[User_LoadDate] [datetime] NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_Users_User_Id] PRIMARY KEY CLUSTERED 
(
	[User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_Users_Src_User_Id] UNIQUE NONCLUSTERED 
(
	[Src_User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[UsersHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[UsersHist](
	[User_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[User_Id] [bigint] NOT NULL,
	[Src_User_Id] [bigint] NOT NULL,
	[User_Name] [nvarchar](200) NOT NULL,
	[User_Account_Name] [nvarchar](200) NOT NULL,
	[User_Birthyear] [int] NULL,
	[User_Gender] [nvarchar](20) NULL,
	[User_Education] [nvarchar](200) NULL,
	[User_Current_City] [nvarchar](200) NULL,
	[User_Hometown] [nvarchar](200) NULL,
	[User_Relationship] [nvarchar](200) NULL,
	[User_Profile_Picture] [varchar](1000) NULL,
	[User_Cover_Photo] [varchar](1000) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_UsersHist_User_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[User_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_UsersHist_Src_User_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_User_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[Videos]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[Videos](
	[Video_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Src_Video_Id] [bigint] NOT NULL,
	[Video] [nvarchar](4000) NOT NULL,
	[Video_Quality] [nvarchar](20) NULL,
	[Video_Size_Mb] [decimal](18, 0) NULL,
	[Video_Duration_Sec] [int] NULL,
	[Video_Watches] [int] NULL,
	[Video_LoadDate] [datetime] NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_Videos_Video_Id] PRIMARY KEY CLUSTERED 
(
	[Video_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_Videos_Src_Video_Id] UNIQUE NONCLUSTERED 
(
	[Src_Video_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [facebook].[VideosHist]    Script Date: 21.10.2022. 13:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [facebook].[VideosHist](
	[Video_Hist_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Video_Id] [bigint] NOT NULL,
	[Src_Video_Id] [bigint] NOT NULL,
	[Video] [nvarchar](4000) NOT NULL,
	[Video_Quality] [nvarchar](20) NULL,
	[Video_Size_Mb] [decimal](18, 0) NULL,
	[Video_Duration_Sec] [int] NULL,
	[Video_Watches] [int] NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Seq_Id] [int] NOT NULL,
	[Current_Flag] [char](5) NOT NULL,
	[Inserted_Datetime] [datetime] NULL,
	[Updated_Datetime] [datetime] NULL,
 CONSTRAINT [pk_VideosHist_Video_Hist_Id] PRIMARY KEY CLUSTERED 
(
	[Video_Hist_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [unq_VideosHist_Src_Video_Id_Valid_From] UNIQUE NONCLUSTERED 
(
	[Src_Video_Id] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [RDL]
GO

/****** Object:  Table [dbo].[FACT_Facebook_Count]    Script Date: 21.10.2022. 13:12:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FACT_Facebook_Count](
	[Date_Id] [date] NULL,
	[Dim_Post_Id] [bigint] NOT NULL,
	[Dim_Comment_Id] [bigint] NOT NULL,
	[Dim_Reply_Id] [bigint] NOT NULL,
	[Dim_User_Id] [bigint] NOT NULL,
	[Dim_Company_Id] [bigint] NOT NULL,
	[Dim_Video_Id] [bigint] NOT NULL,
	[Records_Count] [int] NULL
) ON [PRIMARY]
GO



ALTER TABLE [facebook].[CommentsHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsHist_Comment_Id] FOREIGN KEY([Comment_Id])
REFERENCES [facebook].[Comments] ([Comment_Id])
GO

ALTER TABLE [facebook].[CommentsHist] CHECK CONSTRAINT [fk_CommentsHist_Comment_Id]
GO

ALTER TABLE [facebook].[CommentsReactionsHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsReactionsHist_Comment_Hist_Id] FOREIGN KEY([Comment_Hist_Id])
REFERENCES [facebook].[CommentsHist] ([Comment_Hist_Id])
GO

ALTER TABLE [facebook].[CommentsReactionsHist] CHECK CONSTRAINT [fk_CommentsReactionsHist_Comment_Hist_Id]
GO

ALTER TABLE [facebook].[CommentsReactionsHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsReactionsHist_Comment_Reaction_Type_Id] FOREIGN KEY([Comment_Reaction_Type_Id])
REFERENCES [facebook].[CommentsReactionsTypes] ([Comment_Reaction_Type_Id])
GO

ALTER TABLE [facebook].[CommentsReactionsHist] CHECK CONSTRAINT [fk_CommentsReactionsHist_Comment_Reaction_Type_Id]
GO

ALTER TABLE [facebook].[CommentsReactionsHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsReactionsHist_User_Hist_Id] FOREIGN KEY([User_Hist_Id])
REFERENCES [facebook].[UsersHist] ([User_Hist_Id])
GO

ALTER TABLE [facebook].[CommentsReactionsHist] CHECK CONSTRAINT [fk_CommentsReactionsHist_User_Hist_Id]
GO

ALTER TABLE [facebook].[CommentsRepliesHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsRepliesHist_Comment_Hist_Id] FOREIGN KEY([Comment_Hist_Id])
REFERENCES [facebook].[CommentsHist] ([Comment_Hist_Id])
GO

ALTER TABLE [facebook].[CommentsRepliesHist] CHECK CONSTRAINT [fk_CommentsRepliesHist_Comment_Hist_Id]
GO

ALTER TABLE [facebook].[CommentsRepliesHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsRepliesHist_Reply_Hist_Id] FOREIGN KEY([Reply_Hist_Id])
REFERENCES [facebook].[RepliesHist] ([Reply_Hist_Id])
GO

ALTER TABLE [facebook].[CommentsRepliesHist] CHECK CONSTRAINT [fk_CommentsRepliesHist_Reply_Hist_Id]
GO

ALTER TABLE [facebook].[CommentsUsersHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsUsersHist_Comment_Hist_id] FOREIGN KEY([Comment_Hist_Id])
REFERENCES [facebook].[CommentsHist] ([Comment_Hist_Id])
GO

ALTER TABLE [facebook].[CommentsUsersHist] CHECK CONSTRAINT [fk_CommentsUsersHist_Comment_Hist_id]
GO

ALTER TABLE [facebook].[CommentsUsersHist]  WITH CHECK ADD  CONSTRAINT [fk_CommentsUsersHist_User_Hist_Id] FOREIGN KEY([User_Hist_Id])
REFERENCES [facebook].[UsersHist] ([User_Hist_Id])
GO

ALTER TABLE [facebook].[CommentsUsersHist] CHECK CONSTRAINT [fk_CommentsUsersHist_User_Hist_Id]
GO

ALTER TABLE [facebook].[CompaniesHist]  WITH CHECK ADD  CONSTRAINT [fk_CompaniesHist_Company_Id] FOREIGN KEY([Company_Id])
REFERENCES [facebook].[Companies] ([Company_Id])
GO

ALTER TABLE [facebook].[CompaniesHist] CHECK CONSTRAINT [fk_CompaniesHist_Company_Id]
GO

ALTER TABLE [facebook].[CompaniesPostsHist]  WITH CHECK ADD  CONSTRAINT [fk_CompaniesPostsHist_Company_Hist_Id] FOREIGN KEY([Company_Hist_Id])
REFERENCES [facebook].[CompaniesHist] ([Company_Hist_Id])
GO

ALTER TABLE [facebook].[CompaniesPostsHist] CHECK CONSTRAINT [fk_CompaniesPostsHist_Company_Hist_Id]
GO

ALTER TABLE [facebook].[CompaniesPostsHist]  WITH CHECK ADD  CONSTRAINT [fk_CompaniesPostsHist_Post_Hist_Id] FOREIGN KEY([Post_Hist_Id])
REFERENCES [facebook].[PostsHist] ([Post_Hist_Id])
GO

ALTER TABLE [facebook].[CompaniesPostsHist] CHECK CONSTRAINT [fk_CompaniesPostsHist_Post_Hist_Id]
GO

ALTER TABLE [facebook].[PostsCommentsHist]  WITH CHECK ADD  CONSTRAINT [fk_PostsCommentsHist_Comment_Hist_Id] FOREIGN KEY([Comment_Hist_Id])
REFERENCES [facebook].[CommentsHist] ([Comment_Hist_Id])
GO

ALTER TABLE [facebook].[PostsCommentsHist] CHECK CONSTRAINT [fk_PostsCommentsHist_Comment_Hist_Id]
GO

ALTER TABLE [facebook].[PostsCommentsHist]  WITH CHECK ADD  CONSTRAINT [fk_PostsCommentsHist_Post_Hist_Id] FOREIGN KEY([Post_Hist_Id])
REFERENCES [facebook].[PostsHist] ([Post_Hist_Id])
GO

ALTER TABLE [facebook].[PostsCommentsHist] CHECK CONSTRAINT [fk_PostsCommentsHist_Post_Hist_Id]
GO

ALTER TABLE [facebook].[PostsHist]  WITH CHECK ADD  CONSTRAINT [fk_PostsHist_Post_Id] FOREIGN KEY([Post_Id])
REFERENCES [facebook].[Posts] ([Post_Id])
GO

ALTER TABLE [facebook].[PostsHist] CHECK CONSTRAINT [fk_PostsHist_Post_Id]
GO

ALTER TABLE [facebook].[PostsVideosHist]  WITH CHECK ADD  CONSTRAINT [fk_PostsVideosHist_Post_Hist_Id] FOREIGN KEY([Post_Hist_Id])
REFERENCES [facebook].[PostsHist] ([Post_Hist_Id])
GO

ALTER TABLE [facebook].[PostsVideosHist] CHECK CONSTRAINT [fk_PostsVideosHist_Post_Hist_Id]
GO

ALTER TABLE [facebook].[PostsVideosHist]  WITH CHECK ADD  CONSTRAINT [fk_PostsVideosHist_Video_Hist_Id] FOREIGN KEY([Video_Hist_Id])
REFERENCES [facebook].[VideosHist] ([Video_Hist_Id])
GO

ALTER TABLE [facebook].[PostsVideosHist] CHECK CONSTRAINT [fk_PostsVideosHist_Video_Hist_Id]
GO

ALTER TABLE [facebook].[RepliesHist]  WITH CHECK ADD  CONSTRAINT [fk_RepliesHist_Reply_Id] FOREIGN KEY([Reply_Id])
REFERENCES [facebook].[Replies] ([Reply_Id])
GO

ALTER TABLE [facebook].[RepliesHist] CHECK CONSTRAINT [fk_RepliesHist_Reply_Id]
GO

ALTER TABLE [facebook].[RepliesReactionsHist]  WITH CHECK ADD  CONSTRAINT [fk_RepliesReactionsHist_Reply_Hist_Id] FOREIGN KEY([Reply_Hist_Id])
REFERENCES [facebook].[RepliesHist] ([Reply_Hist_Id])
GO

ALTER TABLE [facebook].[RepliesReactionsHist] CHECK CONSTRAINT [fk_RepliesReactionsHist_Reply_Hist_Id]
GO

ALTER TABLE [facebook].[RepliesReactionsHist]  WITH CHECK ADD  CONSTRAINT [fk_RepliesReactionsHist_Reply_Reaction_Type_Id] FOREIGN KEY([Reply_Reaction_Type_Id])
REFERENCES [facebook].[RepliesReactionsTypes] ([Reply_Reaction_Type_Id])
GO

ALTER TABLE [facebook].[RepliesReactionsHist] CHECK CONSTRAINT [fk_RepliesReactionsHist_Reply_Reaction_Type_Id]
GO

ALTER TABLE [facebook].[RepliesReactionsHist]  WITH CHECK ADD  CONSTRAINT [fk_RepliesReactionsHist_User_Hist_Id] FOREIGN KEY([User_Hist_Id])
REFERENCES [facebook].[UsersHist] ([User_Hist_Id])
GO

ALTER TABLE [facebook].[RepliesReactionsHist] CHECK CONSTRAINT [fk_RepliesReactionsHist_User_Hist_Id]
GO

ALTER TABLE [facebook].[UsersHist]  WITH CHECK ADD  CONSTRAINT [fk_UsersHist_User_Id] FOREIGN KEY([User_Id])
REFERENCES [facebook].[Users] ([User_Id])
GO

ALTER TABLE [facebook].[UsersHist] CHECK CONSTRAINT [fk_UsersHist_User_Id]
GO

ALTER TABLE [facebook].[VideosHist]  WITH CHECK ADD  CONSTRAINT [fk_VideosHist_Video_Id] FOREIGN KEY([Video_Id])
REFERENCES [facebook].[Videos] ([Video_Id])
GO

ALTER TABLE [facebook].[VideosHist] CHECK CONSTRAINT [fk_VideosHist_Video_Id]
GO

ALTER TABLE [facebook].[CommentsHist]  WITH CHECK ADD  CONSTRAINT [ck_CommentsHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[CommentsHist] CHECK CONSTRAINT [ck_CommentsHist_Current_Flag]
GO

ALTER TABLE [facebook].[CompaniesHist]  WITH CHECK ADD  CONSTRAINT [ck_CompaniesHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[CompaniesHist] CHECK CONSTRAINT [ck_CompaniesHist_Current_Flag]
GO

ALTER TABLE [facebook].[CompaniesHist]  WITH CHECK ADD  CONSTRAINT [ck_DimCompaniesHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[CompaniesHist] CHECK CONSTRAINT [ck_DimCompaniesHist_Current_Flag]
GO

ALTER TABLE [facebook].[DIM_Comments]  WITH CHECK ADD  CONSTRAINT [ck_DimCommentsHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[DIM_Comments] CHECK CONSTRAINT [ck_DimCommentsHist_Current_Flag]
GO

ALTER TABLE [facebook].[PostsHist]  WITH CHECK ADD  CONSTRAINT [ck_DimPostsHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[PostsHist] CHECK CONSTRAINT [ck_DimPostsHist_Current_Flag]
GO

ALTER TABLE [facebook].[PostsHist]  WITH CHECK ADD  CONSTRAINT [ck_PostsHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[PostsHist] CHECK CONSTRAINT [ck_PostsHist_Current_Flag]
GO

ALTER TABLE [facebook].[RepliesHist]  WITH CHECK ADD  CONSTRAINT [ck_DimRepliesHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[RepliesHist] CHECK CONSTRAINT [ck_DimRepliesHist_Current_Flag]
GO

ALTER TABLE [facebook].[RepliesHist]  WITH CHECK ADD  CONSTRAINT [ck_RepliesHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[RepliesHist] CHECK CONSTRAINT [ck_RepliesHist_Current_Flag]
GO

ALTER TABLE [facebook].[UsersHist]  WITH CHECK ADD  CONSTRAINT [ck_DimUsersHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[UsersHist] CHECK CONSTRAINT [ck_DimUsersHist_Current_Flag]
GO

ALTER TABLE [facebook].[UsersHist]  WITH CHECK ADD  CONSTRAINT [ck_UsersHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[UsersHist] CHECK CONSTRAINT [ck_UsersHist_Current_Flag]
GO

ALTER TABLE [facebook].[VideosHist]  WITH CHECK ADD  CONSTRAINT [ck_DimVideosHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[VideosHist] CHECK CONSTRAINT [ck_DimVideosHist_Current_Flag]
GO

ALTER TABLE [facebook].[VideosHist]  WITH CHECK ADD  CONSTRAINT [ck_VideosHist_Current_Flag] CHECK  (([Current_Flag]='Y' OR [Current_Flag]='N'))
GO

ALTER TABLE [facebook].[VideosHist] CHECK CONSTRAINT [ck_VideosHist_Current_Flag]
GO

