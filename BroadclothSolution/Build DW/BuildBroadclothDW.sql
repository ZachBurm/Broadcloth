-- Updated on October 15, 2017
-- Broadcloth database developed and written by Amy Phillips
-- BroadclothDW developed and written by Zach B, Cam H, Paul S, & Julia T
-----------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'BroadclothDW')
	CREATE DATABASE BroadclothDW
GO
USE BroadclothDW

-- =======================================
-- Delete existing tables
-- =======================================

--
-- Table FactCompanyProduction
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactCompanyProduction'
       )
	DROP TABLE FactCompanyProduction;
--
-- Table DimShipment
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimShipment'
       )
	DROP TABLE DimShipment;
--
-- Table DimCompliance
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimCompliance'
       )
	DROP TABLE DimCompliance;
--
-- Table DimCustomer
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimCustomer'
       )
	DROP TABLE DimCustomer;
--
-- Table DimDate
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
       )
	DROP TABLE DimDate;
--
-- Table DimProductionBatch
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProductionBatch'
       )
	DROP TABLE DimProductionBatch;


-- ==========================
-- Create tables
-- ===========================

--
-- Table 1 DimProductionBatch
--
CREATE TABLE DimProductionBatch
	(Production_SK INT IDENTITY (1,1) CONSTRAINT pk_Production_SK PRIMARY KEY,
	ItemID INT NOT NULL,
	FactoryID INT NOT NULL,
	Start_date_time DATETIME NOT NULL,
	Est_end_time DATETIME NOT NULL,
	Actual_end_time DATETIME NOT NULL
	);

--
-- Table 2 DimShipment
--
CREATE TABLE DimShipment
	(Shipment_SK INT IDENTITY (1,1) CONSTRAINT pk_Shipment_SK PRIMARY KEY,
	Shipment_AK INT NOT NULL,
	Ship_method NVARCHAR(50) NOT NULL,
	Ship_postal NVARCHAR(12) NOT NULL,
	Ship_state NVARCHAR(20) NOT NULL,
	Ship_nation NVARCHAR(50) NOT NULL,
	Ship_currency NVARCHAR(5) NOT NULL,
	Quantity_shipped INT NOT NULL
	);

--
-- Table 3 DimCompliance
--
CREATE TABLE DimCompliance
	(Compliance_SK INT IDENTITY (1,1) CONSTRAINT pk_Compliance_SK PRIMARY KEY,
	Compliance_AK INT NOT NULL,
	Date_observed DATETIME NOT NULL,
	Overall_rating NUMERIC(18,0) NOT NULL,
	Condition_category NVARCHAR(50) NOT NULL,
	Worker_comments NVARCHAR(1023) NOT NULL,
	Worker_health NVARCHAR (1023) NOT NULL,
	Worker_age NUMERIC(18,0) NOT NULL,
	Worker_gender NVARCHAR(7) NOT NULL,
	Condition_comments NVARCHAR(1023) NOT NULL,
	Age_documents NVARCHAR(150) NOT NULL
	);

--
-- Table 4 DimCustomer
--
CREATE TABLE DimCustomer
	(Customer_SK INT IDENTITY (1,1) CONSTRAINT pk_Customer_SK PRIMARY KEY,
	Customer_AK INT NOT NULL,
	Order_date DATETIME NOT NULL,
	Bill_postal_code NVARCHAR(12) NOT NULL,
	Bill_state NVARCHAR(20) NOT NULL,
	Bill_nation NVARCHAR(50) NOT NULL,
	Order_currency NVARCHAR(20) NOT NULL,
	Base_currency NVARCHAR(20) NOT NULL,
	Price_adjustment NUMERIC(38,4) NOT NULL
	);

--
-- Table 5 DimDate
--
CREATE TABLE dbo.DimDate
	(Date_SK INT PRIMARY KEY, 
	Date DATETIME,
	FullDate CHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth INT, -- Field will hold day number of Month
	DayName VARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear INT,
	DayOfQuarter INT,
	DayOfYear INT,
	WeekOfMonth INT,-- Week Number of Month 
	WeekOfQuarter INT, -- Week Number of the Quarter
	WeekOfYear INT,-- Week Number of the Year
	Month INT, -- Number of the Month 1 to 12{}
	MonthName VARCHAR(9),-- January, February etc
	MonthOfQuarter INT,-- Month Number belongs to Quarter
	Quarter CHAR(2),
	QuarterName VARCHAR(9),-- First,Second..
	Year INT,-- Year value of Date stored in Row
	YearName CHAR(7), -- CY 2015,CY 2016
	MonthYear CHAR(10), -- Jan-2016,Feb-2016
	MMYYYY INT,
	FirstDayOfMonth DATE,
	LastDayOfMonth DATE,
	FirstDayOfQuarter DATE,
	LastDayOfQuarter DATE,
	FirstDayOfYear DATE,
	LastDayOfYear DATE,
	IsHoliday BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday BIT,-- 0=Week End ,1=Week Day
	Holiday VARCHAR(50),--Name of Holiday in US
	Season VARCHAR(10)--Name of Season
	);

--
-- Table 6 FactCompanyProduction
--
CREATE TABLE FactCompanyProduction
	(Date_SK INT CONSTRAINT fk_Date_SK FOREIGN KEY REFERENCES DimDate(Date_SK),
	Customer_SK INT CONSTRAINT fk_Customer_SK FOREIGN KEY REFERENCES DimCustomer(Customer_SK), 
	Shipment_SK INT CONSTRAINT fk_Shipment_SK FOREIGN KEY REFERENCES DimShipment(Shipment_SK),
	Compliance_SK INT CONSTRAINT fk_Compliance_SK FOREIGN KEY REFERENCES DimCompliance(Compliance_SK),
	Production_SK INT CONSTRAINT fk_Production_SK FOREIGN KEY REFERENCES DimProductionBatch(Production_SK),
	Quantity_Produced INT,
	Quality_Rating NUMERIC(18,0),
	Production_Cost NUMERIC(38,4),
	Production_Duration INT,
	CONSTRAINT [pk_CompanyProduction] PRIMARY KEY
   	(Date_SK,
    Customer_SK,
	Shipment_SK,
	Compliance_SK,
	Production_SK)
	);