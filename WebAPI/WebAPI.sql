USE [master]
GO
/****** Object:  Database [Development]    Script Date: 9/1/2021 12:14:50 AM ******/
CREATE DATABASE [Development]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Development', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSTD2017\MSSQL\DATA\Development.mdf' , SIZE = 440320KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Development_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSTD2017\MSSQL\DATA\Development_log.ldf' , SIZE = 833024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Development] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Development].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Development] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Development] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Development] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Development] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Development] SET ARITHABORT OFF 
GO
ALTER DATABASE [Development] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Development] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Development] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Development] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Development] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Development] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Development] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Development] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Development] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Development] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Development] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Development] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Development] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Development] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [Development] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Development] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Development] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Development] SET RECOVERY FULL 
GO
ALTER DATABASE [Development] SET  MULTI_USER 
GO
ALTER DATABASE [Development] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Development] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Development] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Development] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Development] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Development] SET QUERY_STORE = OFF
GO
USE [Development]
GO
/****** Object:  User [sqluser]    Script Date: 9/1/2021 12:14:51 AM ******/
CREATE USER [sqluser] FOR LOGIN [sqluser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [devuser]    Script Date: 9/1/2021 12:14:51 AM ******/
CREATE USER [devuser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [aceparkuser]    Script Date: 9/1/2021 12:14:51 AM ******/
CREATE USER [aceparkuser] FOR LOGIN [aceparkuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [sqluser]
GO
ALTER ROLE [db_owner] ADD MEMBER [devuser]
GO
ALTER ROLE [db_owner] ADD MEMBER [aceparkuser]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_EncloseColumnNameWithBrackets]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_EncloseColumnNameWithBrackets]
(
	@Column		VARCHAR(256)
)
RETURNS VARCHAR(256)
AS
BEGIN

	IF (@Column = 'Description' OR @Column = 'Group' OR @Column = 'Address' 
	   OR @Column = 'State' OR @Column = 'System' OR @Column = 'Password' OR CHARINDEX(' ', @Column) > 0) BEGIN
		RETURN '[' + @Column + ']'
	END

	RETURN @Column

END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_FlattenTable]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ufn_FlattenTable]
(
	@tableName	VARCHAR(128),
	@options	INT = 0				-- 0 = Generate SQL Query, 1 = Generate Field List for INSERT, 2 = Just fields only
)
RETURNS VARCHAR(2048)
AS
-- This function is a utility function meant to generate a SELECT query or an INSERT query by getting all the 
-- columns for the table so that the fields don't need to typed out.
BEGIN
	DECLARE @columns	VARCHAR(1024)
	DECLARE @sqlquery	VARCHAR(2048)

	SET @columns = ''
	SET @sqlquery = ''

	SELECT @columns = @columns + dbo.ufn_EncloseColumnNameWithBrackets(COLUMN_NAME) + ', ' FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME = @tableName

	IF @options = 0 BEGIN
		SELECT @sqlquery = 'SELECT '
		SELECT @sqlquery = @sqlquery + LEFT(@columns, LEN(@columns) - 1) + ' '
		SELECT @sqlquery = @sqlquery + ' FROM ' + @tableName
	END 
	
	IF @options = 1 BEGIN
		SELECT @sqlquery = '(' + LEFT(@columns, LEN(@columns) - 1) + ') '
	END

	IF @options = 2 BEGIN
		SELECT @sqlquery= LTRIM(RTRIM(LEFT(@columns, LEN(@columns) - 1)))
	END

	RETURN @sqlquery

END
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_RandBetween]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[ufn_RandBetween](@bottom INTEGER, @top INTEGER)
RETURNS VARCHAR(6)
AS
BEGIN
  RETURN CAST((SELECT CAST(ROUND((@top-@bottom) * RandomNumber + @bottom, 0) AS INTEGER) FROM vw_RandomNumber) AS VARCHAR(6))
END
GO
/****** Object:  Table [dbo].[Student]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[StudentId] [varchar](10) NOT NULL,
	[FirstName] [varchar](32) NOT NULL,
	[LastName] [varchar](32) NOT NULL,
	[Address] [varchar](255) NOT NULL,
	[City] [varchar](128) NOT NULL,
	[State] [char](2) NOT NULL,
	[ZipCode] [varchar](5) NOT NULL,
	[Phone] [varchar](10) NOT NULL,
	[Gender] [char](1) NOT NULL,
	[DateOfBirth] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwt_StudentsWest]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vwt_StudentsWest]
AS
SELECT StudentId, FirstName, LastName, [Address], City, [State], ZipCode, Phone, Gender, DateOfBirth 
FROM Student
WHERE [State] IN ('AK', 'AZ', 'CA', 'OR', 'WA')
GO
/****** Object:  View [dbo].[vw_RandomNumber]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_RandomNumber]
AS
  SELECT RAND() AS RandomNumber
GO
/****** Object:  Table [dbo].[Adjustments]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Adjustments](
	[InvoiceNumber] [varchar](32) NULL,
	[Adjustment] [decimal](7, 3) NULL,
	[DateEntered] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AllLocationsWork]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllLocationsWork](
	[Address] [varchar](255) NOT NULL,
	[City] [varchar](64) NOT NULL,
	[State] [varchar](2) NOT NULL,
	[ZipCode] [varchar](12) NOT NULL,
	[Phone] [varchar](12) NOT NULL,
	[Latitude] [numeric](18, 10) NOT NULL,
	[Longitude] [numeric](18, 10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[City]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[CityId] [int] IDENTITY(34134,1) NOT NULL,
	[Name] [varchar](32) NULL,
	[State] [varchar](32) NULL,
	[Population] [varchar](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComputerLanguage]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerLanguage](
	[LanguageId] [int] IDENTITY(1,1) NOT NULL,
	[Language] [varchar](32) NOT NULL,
	[DateEntered] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactId] [int] IDENTITY(2783,1) NOT NULL,
	[FirstName] [varchar](64) NOT NULL,
	[LastName] [varchar](64) NOT NULL,
	[Address] [varchar](255) NOT NULL,
	[City] [varchar](64) NOT NULL,
	[State] [varchar](32) NOT NULL,
	[ZipCode] [varchar](12) NOT NULL,
	[Phone] [varchar](12) NOT NULL,
	[DateEntered] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[CardNumber] [varchar](8) NULL,
	[LastName] [varchar](32) NOT NULL,
	[FirstName] [varchar](32) NOT NULL,
	[EmailAddress] [varchar](255) NULL,
	[StartDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CIDX_FullName]    Script Date: 9/1/2021 12:14:51 AM ******/
CREATE CLUSTERED INDEX [CIDX_FullName] ON [dbo].[Employee]
(
	[LastName] ASC,
	[FirstName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Export]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Export](
	[MemberNumber] [nvarchar](15) NULL,
	[LastName] [nvarchar](75) NULL,
	[FirstName] [nvarchar](75) NULL,
	[DateOfBirth] [nvarchar](15) NULL,
	[CinNumber] [nvarchar](15) NULL,
	[ServiceDate] [nvarchar](15) NULL,
	[NormalizedDrugName] [nvarchar](15) NULL,
	[CurrentProcedureCode] [nvarchar](15) NULL,
	[VaccineCode] [nvarchar](15) NULL,
	[CptModifier1] [nvarchar](10) NULL,
	[CptModifier2] [nvarchar](10) NULL,
	[CurrentProcedureCodeCategory] [nvarchar](15) NULL,
	[Hcpcs] [nvarchar](15) NULL,
	[RevenueCode] [nvarchar](15) NULL,
	[PlaceOfServiceCode] [nvarchar](15) NULL,
	[ICDFormat] [nvarchar](10) NULL,
	[DiagnosisCode1] [nvarchar](75) NULL,
	[DiagnosisCode2] [nvarchar](75) NULL,
	[DiagnosisCode3] [nvarchar](75) NULL,
	[DiagnosisCode4] [nvarchar](75) NULL,
	[PrincipalProcedureCode] [nvarchar](15) NULL,
	[SecondaryProcedureCode] [nvarchar](15) NULL,
	[PrescriptionNDCCode] [nvarchar](15) NULL,
	[PrescriptionDaysSupply] [nvarchar](10) NULL,
	[PrescriptionMetricQuantity] [nvarchar](15) NULL,
	[LoincCode] [nvarchar](10) NULL,
	[LabValue] [nvarchar](15) NULL,
	[LabScreening] [nvarchar](5) NULL,
	[AgeServiceDate] [nvarchar](3) NULL,
	[Gender] [nvarchar](1) NULL,
	[ProviderLastName] [nvarchar](50) NULL,
	[ProviderFirstName] [nvarchar](50) NULL,
	[ProviderNumber] [nvarchar](15) NULL,
	[ClaimPracticeTypeId] [nvarchar](15) NULL,
	[Systolic] [nvarchar](3) NULL,
	[Diastolic] [nvarchar](3) NULL,
	[Height] [nvarchar](10) NULL,
	[Weight] [nvarchar](10) NULL,
	[BodyMassIndex] [nvarchar](10) NULL,
	[BodyMassIndexPercentile] [nvarchar](10) NULL,
	[UnitType] [nvarchar](10) NULL,
	[EmrRecordNumber] [nvarchar](100) NULL,
	[FileId] [nvarchar](15) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoursOfOperation]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoursOfOperation](
	[HOId] [int] IDENTITY(1,1) NOT NULL,
	[LotNumber] [varchar](6) NOT NULL,
	[Active] [bit] NOT NULL,
	[DayOfWeek] [varchar](32) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HyphenTestTable]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HyphenTestTable](
	[account_name] [varchar](512) NULL,
	[account_id] [bigint] NULL,
	[org_id] [bigint] NULL,
	[subdivision] [varchar](512) NULL,
	[job_num] [bigint] NULL,
	[job_name] [varchar](256) NULL,
	[address1] [varchar](256) NULL,
	[address2] [varchar](256) NULL,
	[city] [varchar](256) NULL,
	[state_code] [varchar](128) NULL,
	[postal_code] [varchar](128) NULL,
	[lot] [varchar](128) NULL,
	[block] [varchar](512) NULL,
	[start_date] [smalldatetime] NULL,
	[primary_first_name] [varchar](256) NULL,
	[primary_last_name] [varchar](256) NULL,
	[primary_phone_number] [varchar](256) NULL,
	[primary_email_address] [varchar](256) NULL,
	[modified] [varchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InspectionOrder]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InspectionOrder](
	[OrderId] [varchar](12) NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](32) NULL,
	[ZipCode] [varchar](12) NULL,
	[WorkCode] [varchar](255) NULL,
	[DueDate] [datetime] NULL,
	[Latitude] [decimal](18, 10) NULL,
	[Longitude] [decimal](18, 10) NULL,
	[BatchId] [uniqueidentifier] NULL,
	[DownloadDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[InvoiceNumber] [varchar](32) NULL,
	[Customer] [varchar](32) NULL,
	[Description] [varchar](255) NULL,
	[Amount] [decimal](7, 3) NULL,
	[DateEntered] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Keycard]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Keycard](
	[CardNumber] [varchar](12) NOT NULL,
	[ResidentId] [int] NOT NULL,
	[IssueDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[Amount] [decimal](6, 2) NOT NULL,
UNIQUE NONCLUSTERED 
(
	[CardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MagUser]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MagUser](
	[MagUserId] [int] IDENTITY(2834,1) NOT NULL,
	[Username] [varchar](32) NOT NULL,
	[EmailAddress] [varchar](255) NOT NULL,
	[DateEntered] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_MagUserId] PRIMARY KEY CLUSTERED 
(
	[MagUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MealPreferences]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MealPreferences](
	[MealPreferenceId] [int] IDENTITY(348,1) NOT NULL,
	[RegistrationId] [int] NOT NULL,
	[MealPreference] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MealPreferenceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Member]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Member](
	[MemId] [int] NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[EffDate] [datetime] NOT NULL,
	[TermDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Numbers]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Numbers](
	[NumericPortion] [int] NULL,
	[Used] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_rep]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_rep](
	[iteNag] [varchar](10) NULL,
	[mnth] [int] NULL,
	[year] [int] NULL,
	[ordermade] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PCP]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PCP](
	[PCPId] [int] NOT NULL,
	[MemId] [int] NOT NULL,
	[EffDate] [datetime] NOT NULL,
	[TermDate] [datetime] NOT NULL,
	[ProvId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PCPId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Provider]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Provider](
	[ProvId] [int] NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProvId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Registration]    Script Date: 9/1/2021 12:14:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Registration](
	[RegistrationId] [int] IDENTITY(734,1) NOT NULL,
	[Username] [varchar](25) NOT NULL,
	[Email] [varchar](255) NULL,
	[Password] [varchar](64) NOT NULL,
	[DateOfBirth] [datetime2](7) NULL,
	[Country] [varchar](128) NOT NULL,
	[Gender] [varchar](12) NULL,
	[DateEntered] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Resident]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resident](
	[ResidentId] [int] IDENTITY(7341,1) NOT NULL,
	[FirstName] [varchar](32) NOT NULL,
	[LastName] [varchar](32) NOT NULL,
	[Address] [varchar](255) NOT NULL,
	[City] [varchar](64) NOT NULL,
	[State] [varchar](2) NOT NULL,
	[ZipCode] [varchar](12) NOT NULL,
	[DateEntered] [datetime] NOT NULL,
 CONSTRAINT [PK_ResidentId] PRIMARY KEY CLUSTERED 
(
	[ResidentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Response]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Response](
	[PartyGuid] [uniqueidentifier] NULL,
	[ApplicationGuid] [uniqueidentifier] NULL,
	[AltJobId] [varchar](50) NULL,
	[AccountName] [varchar](50) NULL,
	[AccountId] [varchar](50) NULL,
	[OrgId] [varchar](50) NULL,
	[OrgName] [varchar](50) NULL,
	[JobName] [varchar](50) NULL,
	[Address1] [varchar](255) NULL,
	[Address2] [varchar](255) NULL,
	[City] [varchar](50) NULL,
	[StateCode] [varchar](50) NULL,
	[PostalCode] [varchar](50) NULL,
	[Lot] [varchar](50) NULL,
	[PrimaryFirstName] [varchar](50) NULL,
	[PrimaryLastName] [varchar](50) NULL,
	[PrimaryPhoneNumber] [varchar](50) NULL,
	[PrimaryEmailAddress] [varchar](255) NULL,
	[DateStart] [datetime] NULL,
	[Modified] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SampleTable]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SampleTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[Value] [varchar](100) NULL,
	[DateChanged] [datetime] NULL,
 CONSTRAINT [PK_SampleTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SimpleRate]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SimpleRate](
	[BaseRateId] [int] IDENTITY(1,1) NOT NULL,
	[LotNumber] [varchar](6) NOT NULL,
	[StallType] [varchar](12) NOT NULL,
	[Description] [varchar](128) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Amount] [money] NOT NULL,
	[IsPortalRate] [bit] NOT NULL,
	[DateEntered] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SoldWidgets]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SoldWidgets](
	[DateSold] [datetime] NULL,
	[Amount] [decimal](6, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatesMeta]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatesMeta](
	[StateName] [varchar](64) NULL,
	[Abbreviation] [varchar](12) NULL,
	[Capital] [varchar](64) NULL,
	[Population] [int] NULL,
	[Area] [int] NULL,
	[DateEntered] [datetime] NULL,
	[DateRank] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentGroupings]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentGroupings](
	[RowNumber] [int] IDENTITY(1,1) NOT NULL,
	[State] [varchar](50) NULL,
	[Occurrences] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentRoster]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentRoster](
	[StudentId] [int] IDENTITY(2341,1) NOT NULL,
	[LastName] [varchar](32) NOT NULL,
	[LanguageId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LastName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentsWestCA]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentsWestCA](
	[RowNumber] [int] NULL,
	[State] [varchar](50) NULL,
	[Occurrences] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentTransform]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentTransform](
	[StudentId] [varchar](10) NULL,
	[FullName] [nvarchar](65) NULL,
	[Age] [int] NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](128) NULL,
	[State] [varchar](2) NULL,
	[ZipCode] [varchar](5) NULL,
	[Phone] [varchar](10) NULL,
	[Gender] [varchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TempImport]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempImport](
	[MemberNumber] [nvarchar](15) NULL,
	[LastName] [nvarchar](75) NULL,
	[FirstName] [nvarchar](75) NULL,
	[DateOfBirth] [nvarchar](15) NULL,
	[CinNumber] [nvarchar](15) NULL,
	[ServiceDate] [nvarchar](15) NULL,
	[NormalizedDrugName] [nvarchar](15) NULL,
	[CurrentProcedureCode] [nvarchar](15) NULL,
	[VaccineCode] [nvarchar](15) NULL,
	[CptModifier1] [nvarchar](10) NULL,
	[CptModifier2] [nvarchar](10) NULL,
	[CurrentProcedureCodeCategory] [nvarchar](15) NULL,
	[Hcpcs] [nvarchar](15) NULL,
	[RevenueCode] [nvarchar](15) NULL,
	[PlaceOfServiceCode] [nvarchar](15) NULL,
	[ICDFormat] [nvarchar](10) NULL,
	[DiagnosisCode1] [nvarchar](75) NULL,
	[DiagnosisCode2] [nvarchar](75) NULL,
	[DiagnosisCode3] [nvarchar](75) NULL,
	[DiagnosisCode4] [nvarchar](75) NULL,
	[PrincipalProcedureCode] [nvarchar](15) NULL,
	[SecondaryProcedureCode] [nvarchar](15) NULL,
	[PrescriptionNDCCode] [nvarchar](15) NULL,
	[PrescriptionDaysSupply] [nvarchar](10) NULL,
	[PrescriptionMetricQuantity] [nvarchar](15) NULL,
	[LoincCode] [nvarchar](10) NULL,
	[LabValue] [nvarchar](15) NULL,
	[LabScreening] [nvarchar](5) NULL,
	[AgeServiceDate] [nvarchar](3) NULL,
	[Gender] [nvarchar](1) NULL,
	[ProviderLastName] [nvarchar](50) NULL,
	[ProviderFirstName] [nvarchar](50) NULL,
	[ProviderNumber] [nvarchar](15) NULL,
	[ClaimPracticeTypeId] [nvarchar](15) NULL,
	[Systolic] [nvarchar](3) NULL,
	[Diastolic] [nvarchar](3) NULL,
	[Height] [nvarchar](10) NULL,
	[Weight] [nvarchar](10) NULL,
	[BodyMassIndex] [nvarchar](10) NULL,
	[BodyMassIndexPercentile] [nvarchar](10) NULL,
	[UnitType] [nvarchar](10) NULL,
	[EmrRecordNumber] [nvarchar](100) NULL,
	[FileId] [nvarchar](15) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transformation]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transformation](
	[StudentId] [varchar](10) NULL,
	[FullName] [varchar](65) NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](128) NULL,
	[State] [varchar](2) NULL,
	[ZipCode] [varchar](5) NULL,
	[Phone] [varchar](10) NULL,
	[Gender] [varchar](1) NULL,
	[Age] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(3000,1) NOT NULL,
	[FirstName] [varchar](32) NULL,
	[LastName] [varchar](32) NULL,
	[Email] [varchar](128) NULL,
	[Role] [varchar](32) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(2341,1) NOT NULL,
	[Name] [varchar](65) NOT NULL,
	[Age] [int] NULL,
	[Country] [int] NULL,
	[EmailAddress] [varchar](255) NULL,
	[Married] [bit] NULL,
	[DateEntered] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USState]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USState](
	[Abbreviation] [char](2) NOT NULL,
	[State] [varchar](32) NOT NULL,
	[Capital] [varchar](32) NOT NULL,
	[CapitalPop] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Abbreviation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HoursOfOperation] ADD  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Keycard] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Keycard] ADD  DEFAULT ((1)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[Keycard] ADD  DEFAULT ((0.0)) FOR [Amount]
GO
ALTER TABLE [dbo].[Registration] ADD  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SampleTable] ADD  DEFAULT (getdate()) FOR [DateChanged]
GO
ALTER TABLE [dbo].[SimpleRate] ADD  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[Keycard]  WITH NOCHECK ADD  CONSTRAINT [FK_Keycard_Resident] FOREIGN KEY([ResidentId])
REFERENCES [dbo].[Resident] ([ResidentId])
GO
ALTER TABLE [dbo].[Keycard] CHECK CONSTRAINT [FK_Keycard_Resident]
GO
ALTER TABLE [dbo].[MealPreferences]  WITH CHECK ADD  CONSTRAINT [FK_MealPreferences_Registration] FOREIGN KEY([RegistrationId])
REFERENCES [dbo].[Registration] ([RegistrationId])
GO
ALTER TABLE [dbo].[MealPreferences] CHECK CONSTRAINT [FK_MealPreferences_Registration]
GO
ALTER TABLE [dbo].[PCP]  WITH NOCHECK ADD  CONSTRAINT [FK_Member_PCP_MemId] FOREIGN KEY([MemId])
REFERENCES [dbo].[Member] ([MemId])
GO
ALTER TABLE [dbo].[PCP] CHECK CONSTRAINT [FK_Member_PCP_MemId]
GO
ALTER TABLE [dbo].[PCP]  WITH NOCHECK ADD  CONSTRAINT [FK_Member_PCP_ProvId] FOREIGN KEY([ProvId])
REFERENCES [dbo].[Provider] ([ProvId])
GO
ALTER TABLE [dbo].[PCP] CHECK CONSTRAINT [FK_Member_PCP_ProvId]
GO
ALTER TABLE [dbo].[Student]  WITH NOCHECK ADD  CONSTRAINT [FK_Student_USState] FOREIGN KEY([State])
REFERENCES [dbo].[USState] ([Abbreviation])
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_USState]
GO
ALTER TABLE [dbo].[StudentRoster]  WITH CHECK ADD  CONSTRAINT [FK_Student_ComputerLanguage] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[ComputerLanguage] ([LanguageId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StudentRoster] CHECK CONSTRAINT [FK_Student_ComputerLanguage]
GO
ALTER TABLE [dbo].[Student]  WITH NOCHECK ADD CHECK  (([Gender]='M' OR [Gender]='F'))
GO
/****** Object:  StoredProcedure [dbo].[GetAllUsers]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllUsers]
AS
SET NOCOUNT ON
SELECT Id, FirstName, LastName, Email, [Role] FROM [User]
SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[InsertStatesMeta]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertStatesMeta]
(
	@StateName		[varchar](64) NULL,
	@Abbreviation	[varchar](12) NULL,
	@Capital		[varchar](64) NULL,
	@Population		[int] NULL,
	@Area			[int] NULL,
	@DateEntered	[datetime] NULL,
	@DateRank		[int] NULL
)
AS
SET NOCOUNT ON

INSERT INTO StatesMeta (StateName, Abbreviation, Capital, [Population], Area, DateEntered, DateRank)
VALUES (@StateName, @Abbreviation, @Capital, @Population, @Area, @DateEntered, @DateRank)

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_AddNewUser]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_AddNewUser]
(
	@Name			VARCHAR(65),
	@Age			INT,
	@Country		INT,
	@EmailAddress	VARCHAR(255),
	@Married		BIT
)
AS
SET NOCOUNT ON

INSERT INTO Users (Name, Age, Country, EmailAddress, Married, DateEntered) VALUES (@Name, @Age, @Country, @EmailAddress, @Married, GETUTCDATE())

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_CompareTables]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_CompareTables]
(
	@table1 varchar(100),
	@table2 Varchar(100), 
	@T1ColumnList varchar(1000),
	@T2ColumnList varchar(1000) = ''
)
AS
-- Source:  http://weblogs.sqlteam.com/jeffs/archive/2004/11/10/2737.aspx
 
-- Table1, Table2 are the tables or views to compare.
-- T1ColumnList is the list of columns to compare, from table1.
-- Just list them comma-separated, like in a GROUP BY clause.
-- If T2ColumnList is not specified, it is assumed to be the same
-- as T1ColumnList.  Otherwise, list the columns of Table2 in
-- the same order as the columns in table1 that you wish to compare.
--
-- The result is all rows from either table that do NOT match
-- the other table in all columns specified, along with which table that
-- row is from.
 
declare @SQL varchar(8000);
 
IF @t2ColumnList = '' SET @T2ColumnList = @T1ColumnList
 
set @SQL = 'SELECT ''' + @table1 + ''' AS TableName, ' + @t1ColumnList +
 ' FROM ' + @Table1 + ' UNION ALL SELECT ''' + @table2 + ''' As TableName, ' +
 @t2ColumnList + ' FROM ' + @Table2
 
set @SQL = 'SELECT Max(TableName) as TableName, ' + @t1ColumnList +
 ' FROM (' + @SQL + ') A GROUP BY ' + @t1ColumnList +
 ' HAVING COUNT(*) = 1'
 
exec ( @SQL)
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteContact]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_DeleteContact]
(
	@ContactId	INT
)
AS
SET NOCOUNT ON

DECLARE @RowsModified	INT = 0

DELETE FROM Contact WHERE ContactId = @ContactId

SELECT @RowsModified = @@ROWCOUNT

RETURN @RowsModified

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteUser]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_DeleteUser]
(
	@UserId			INT
)
AS
SET NOCOUNT ON

DELETE FROM Users WHERE UserId = @UserId 

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_DoThis]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_DoThis]
(
	@FirstName	VARCHAR(64),
	@LastName	VARCHAR(64),
	@Size		INT,
	@Val		DECIMAL(8, 2)
)
AS
SET NOCOUNT ON

DECLARE @procName	VARCHAR(255),
		@params		VARCHAR(4000) = 'SELECT ',
		@rezuts		NVARCHAR(4000)

SELECT @procName = OBJECT_NAME(@@PROCID)

SELECT @procName

SELECT SCHEMA_NAME(SCHEMA_ID) AS [Schema],
SO.name AS [ObjectName],
SO.Type_Desc AS [ObjectType (UDF/SP)],
P.parameter_id AS [ParameterID],
P.name AS [ParameterName],
TYPE_NAME(P.user_type_id) AS [ParameterDataType],
P.max_length AS [ParameterMaxBytes],
P.is_output AS [IsOutPutParameter]
FROM sys.objects AS SO
INNER JOIN sys.parameters AS P
ON SO.OBJECT_ID = P.OBJECT_ID
WHERE SO.OBJECT_ID IN ( SELECT OBJECT_ID
FROM sys.objects
WHERE TYPE IN ('P','FN')) AND SO.Name = 'usp_DoThis'
ORDER BY [Schema], SO.name, P.parameter_id

-- SELECT @params = @params + CASE WHEN TYPE_NAME(P.user_type_id) = 'varchar' THEN P.name WHEN P.user_type_id) = 'int' THEN CAST(
SELECT @params = @params + P.[name] + ', '
FROM sys.objects AS SO
INNER JOIN sys.parameters AS P
ON SO.OBJECT_ID = P.OBJECT_ID
WHERE SO.OBJECT_ID IN ( SELECT OBJECT_ID
FROM sys.objects
WHERE TYPE IN ('P','FN')) AND SO.Name = 'usp_DoThis'
ORDER BY P.parameter_id

SELECT LEFT(@params, LEN(@params) - 1) AS Params

-- EXEC sp_executesql @rezuts

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllUsers]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetAllUsers]
AS
SET NOCOUNT ON

SELECT [Name], Age, Country, EmailAddress, Married FROM Users

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertContact]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_InsertContact]
(
	@FirstName	VARCHAR(64),
	@LastName	VARCHAR(64),
	@Address	VARCHAR(255),
	@City		VARCHAR(64),
	@State		VARCHAR(32),
	@ZipCode	VARCHAR(12),
	@Phone		VARCHAR(12)
)
AS
SET NOCOUNT ON

DECLARE @RowsModified	INT = 0

INSERT INTO Contact (FirstName, LastName, [Address], City, [State], ZipCode, Phone, DateEntered)
VALUES (@FirstName, @LastName, @Address, @City, @State, @ZipCode, @Phone, GETUTCDATE())

SELECT @RowsModified = @@ROWCOUNT

RETURN @RowsModified

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_SelectAllContacts]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_SelectAllContacts]
AS
SET NOCOUNT ON

SELECT ContactId, FirstName, LastName, [Address], City, [State], ZipCode, Phone, CONVERT(VARCHAR(10), DateEntered, 110) AS DateEntered FROM Contact

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_SelectContactById]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[usp_SelectContactById]
(
	@ContactId	INT
)
AS 
SET NOCOUNT ON

SELECT ContactId, FirstName, LastName, [Address], City, [State], ZipCode, Phone, DateEntered FROM Contact WHERE ContactId = @ContactId

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_TagRecords]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TagRecords]
AS
SET NOCOUNT ON

DECLARE @Id		UNIQUEIDENTIFIER

SET @Id = NEWID()

UPDATE InspectionOrder SET DownloadDate = GETDATE(), BatchId = @Id WHERE BatchId IS NULL

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateContact]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[usp_UpdateContact]
(
	@ContactId	INT,
	@FirstName	VARCHAR(64),
	@LastName	VARCHAR(64),
	@Address	VARCHAR(255),
	@City		VARCHAR(64),
	@State		VARCHAR(32),
	@ZipCode	VARCHAR(12),
	@Phone		VARCHAR(12)
)
AS
SET NOCOUNT ON

DECLARE @RowsModified	INT = 0

UPDATE Contact SET
	FirstName = @FirstName,
	LastName = @LastName,
	Address = @Address,
	City = @City,
	State = @State,
	ZipCode = @ZipCode,
	Phone = @Phone,
	DateEntered = GETUTCDATE()
WHERE ContactId = @ContactId

SELECT @RowsModified = @@ROWCOUNT

RETURN @RowsModified

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUser]    Script Date: 9/1/2021 12:14:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_UpdateUser]
(
	@UserId			INT,
	@Name			VARCHAR(65),
	@Age			INT,
	@Country		INT,
	@EmailAddress	VARCHAR(255),
	@Married		BIT
)
AS
SET NOCOUNT ON

UPDATE Users SET
	[Name] = @Name,
	Age = @Age,
	Country = @Country,
	EmailAddress = @EmailAddress,
	Married = @Married, 
	DateEntered = GETUTCDATE()
WHERE UserId = @UserId

SET NOCOUNT OFF
GO
USE [master]
GO
ALTER DATABASE [Development] SET  READ_WRITE 
GO
