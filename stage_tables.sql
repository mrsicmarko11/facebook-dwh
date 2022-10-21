USE [Stage]
GO

/****** Object:  Table [telco].[FacebookComments]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookComments](
	[commentId] [nvarchar](200) NULL,
	[commentImage] [nvarchar](4000) NULL,
	[commentText] [nvarchar](max) NULL,
	[commentTime] [nvarchar](100) NULL,
	[commentUrl] [nvarchar](4000) NULL,
	[commenterId] [nvarchar](200) NULL,
	[commenterName] [nvarchar](100) NULL,
	[commenterUrl] [nvarchar](4000) NULL,
	[postId] [nvarchar](200) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [telco].[FacebookCommentsReactions]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookCommentsReactions](
	[commentId] [nvarchar](200) NULL,
	[commentReactionUserName] [nvarchar](100) NULL,
	[commentReactionUserType] [nvarchar](100) NULL,
	[commentReactionUserUrl] [nvarchar](4000) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [telco].[FacebookCompaniesInfo]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookCompaniesInfo](
	[about] [nvarchar](max) NULL,
	[followers] [nvarchar](100) NULL,
	[image] [nvarchar](4000) NULL,
	[likes] [nvarchar](100) NULL,
	[name] [nvarchar](100) NULL,
	[type] [nvarchar](100) NULL,
	[url] [nvarchar](200) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [telco].[FacebookPosts]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookPosts](
	[accountName] [nvarchar](50) NULL,
	[postID] [nvarchar](200) NULL,
	[postText] [nvarchar](4000) NULL,
	[postTime] [nvarchar](100) NULL,
	[postURL] [nvarchar](200) NULL,
	[postLikes] [nvarchar](100) NULL,
	[postComments] [nvarchar](100) NULL,
	[postShares] [nvarchar](100) NULL,
	[postScrapeDate] [nvarchar](200) NULL,
	[video] [nvarchar](4000) NULL,
	[videoId] [nvarchar](100) NULL,
	[videoQuality] [nvarchar](100) NULL,
	[videoSizeMb] [nvarchar](100) NULL,
	[videoThumbnail] [nvarchar](4000) NULL,
	[videoDurationSeconds] [nvarchar](100) NULL,
	[videoWatches] [nvarchar](100) NULL,
	[imageLowQuality] [nvarchar](4000) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [telco].[FacebookReplies]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookReplies](
	[commentId] [nvarchar](200) NULL,
	[postId] [nvarchar](200) NULL,
	[replierId] [nvarchar](200) NULL,
	[replierMeta] [nvarchar](100) NULL,
	[replierName] [nvarchar](200) NULL,
	[replierUrl] [nvarchar](4000) NULL,
	[replyId] [nvarchar](200) NULL,
	[replyImage] [nvarchar](4000) NULL,
	[replyText] [nvarchar](max) NULL,
	[replyTime] [nvarchar](100) NULL,
	[replyUrl] [nvarchar](4000) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [telco].[FacebookRepliesReactions]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookRepliesReactions](
	[replyReactionUserName] [nvarchar](100) NULL,
	[replyReactionUserType] [nvarchar](100) NULL,
	[replyReactionUserUrl] [nvarchar](4000) NULL,
	[replyId] [nvarchar](200) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [telco].[FacebookUsers]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookUsers](
	[userAccountName] [nvarchar](2000) NULL,
	[userAbout] [nvarchar](4000) NULL,
	[userBasicInfo] [nvarchar](2000) NULL,
	[userCoverPhoto] [nvarchar](4000) NULL,
	[userCoverPhotoText] [nvarchar](2000) NULL,
	[userEducation] [nvarchar](2000) NULL,
	[userFamilyMembers] [nvarchar](2000) NULL,
	[userId] [nvarchar](2000) NULL,
	[userLifeEvents] [nvarchar](2000) NULL,
	[userName] [nvarchar](2000) NULL,
	[userPlacesLived] [nvarchar](2000) NULL,
	[userProfilePicture] [nvarchar](4000) NULL,
	[userRelationship] [nvarchar](2000) NULL,
	[userReligiousViews] [nvarchar](2000) NULL,
	[userWork] [nvarchar](4000) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [telco].[FacebookUsersImageData]    Script Date: 21.10.2022. 13:10:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [telco].[FacebookUsersImageData](
	[account_name] [nvarchar](2000) NULL,
	[description_results] [nvarchar](4000) NULL,
	[categories_results] [nvarchar](2000) NULL,
	[tag_results] [nvarchar](4000) NULL,
	[object_results] [nvarchar](2000) NULL,
	[faces_results] [nvarchar](2000) NULL,
	[LoadDate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [telco].[FacebookComments] ADD  CONSTRAINT [def_FacebookComments]  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [telco].[FacebookCommentsReactions] ADD  CONSTRAINT [def_FacebookCommentReaction]  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [telco].[FacebookCompaniesInfo] ADD  CONSTRAINT [def_FacebookCompaniesInfo]  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [telco].[FacebookPosts] ADD  CONSTRAINT [def_FacebookPosts]  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [telco].[FacebookReplies] ADD  CONSTRAINT [def_FacebookReplies]  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [telco].[FacebookRepliesReactions] ADD  CONSTRAINT [def_FacebookRepliesReactions]  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [telco].[FacebookUsers] ADD  CONSTRAINT [def_FacebookUser]  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [telco].[FacebookUsersImageData] ADD  CONSTRAINT [def_FacebookUserImageData]  DEFAULT (getdate()) FOR [LoadDate]
GO

