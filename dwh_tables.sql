

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


