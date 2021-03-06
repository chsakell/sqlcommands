USE [master]
GO
/****** Object:  Database [SchoolDB]    Script Date: 5/1/2014 12:17:38 AM ******/
CREATE DATABASE [SchoolDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SchoolDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SchoolDB.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SchoolDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SchoolDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SchoolDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SchoolDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SchoolDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SchoolDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SchoolDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SchoolDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SchoolDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SchoolDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SchoolDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SchoolDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SchoolDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SchoolDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SchoolDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SchoolDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SchoolDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SchoolDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SchoolDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SchoolDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SchoolDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SchoolDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SchoolDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SchoolDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SchoolDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SchoolDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SchoolDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SchoolDB] SET RECOVERY FULL 
GO
ALTER DATABASE [SchoolDB] SET  MULTI_USER 
GO
ALTER DATABASE [SchoolDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SchoolDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SchoolDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SchoolDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SchoolDB', N'ON'
GO
USE [SchoolDB]
GO
/****** Object:  StoredProcedure [dbo].[AddStudent]    Script Date: 5/1/2014 12:17:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudent]
@studentID int,
@studentName nvarchar(50),
@studentAge int
AS
BEGIN
DECLARE @result int = 0;
DECLARE @tempID int;

SET @tempID = (SELECT StudentID FROM dbo.Students WHERE StudentID = @studentID)

IF @tempID IS NOT NULL 
	SET @result = -1 -- There is already a student with this ID
ELSE IF @studentAge < 5 OR @studentAge > 120 
	SET @result = -2 -- Invalid Age number
ELSE
	INSERT INTO dbo.Students VALUES (@studentID, @studentName, @studentID)
END

SELECT @result ResultCode
GO
/****** Object:  StoredProcedure [dbo].[GetStudents]    Script Date: 5/1/2014 12:17:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStudents]
AS
BEGIN
	SELECT * FROM dbo.Students
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateStudentsName]    Script Date: 5/1/2014 12:17:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateStudentsName]
@studentID int,
@studentNewName nvarchar(50)
AS
BEGIN
	UPDATE dbo.Students SET StudentName = @studentNewName WHERE StudentID = @studentID
END
GO
/****** Object:  Table [dbo].[Students]    Script Date: 5/1/2014 12:17:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[StudentID] [int] NOT NULL,
	[StudentName] [nvarchar](50) NOT NULL,
	[StudentAge] [int] NOT NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentAge]) VALUES (1, N'Chris S.', 28)
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentAge]) VALUES (2, N'Catherin', 23)
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentAge]) VALUES (3, N'Nick', 30)
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentAge]) VALUES (4, N'Maria', 40)
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentAge]) VALUES (5, N'Jason', 5)
USE [master]
GO
ALTER DATABASE [SchoolDB] SET  READ_WRITE 
GO
