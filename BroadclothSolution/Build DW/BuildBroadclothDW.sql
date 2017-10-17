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
	(Production_SK INT CONSTRAINT pk_Production_SK PRIMARY KEY,
	ItemID INT NOT NULL,
	FactoryID INT NOT NULL,
	Start_date_time NVARCHAR(40) NOT NULL,
	Est_end_time NVARCHAR(120) NOT NULL,
	Actual_end_time NVARCHAR(20) NOT NULL
	);

--
-- Table 2 DimShipment
--
CREATE TABLE DimShipment
	(Shipment_SK INT CONSTRAINT pk_Shipment_SK PRIMARY KEY,
	Shipment_AK INT NOT NULL,
	Ship_method NVARCHAR(40) NOT NULL,
	Ship_postal INT NOT NULL,
	Ship_state NVARCHAR(40) NOT NULL,
	Ship_nation NVARCHAR(60) NOT NULL,
	Ship_currency NVARCHAR(40) NOT NULL,
	Quantity_shipped INT NOT NULL
	);

--
-- Table 3 DimCompliance
--
CREATE TABLE DimCompliance
	(Compliance_SK INT CONSTRAINT pk_Compliance_SK PRIMARY KEY,
	Compliance_AK INT NOT NULL,
	Date_observed NVARCHAR(40) NOT NULL,
	Overall_rating NVARCHAR(120) NOT NULL,
	Condition_catagory NVARCHAR(20) NOT NULL,
	Worker_comments NVARCHAR(120) NOT NULL,
	Worker_health NVARCHAR (16) NOT NULL,
	Worker_age INT NOT NULL,
	Worker_gender NVARCHAR(16) NOT NULL,
	Condition_comments NVARCHAR(120) NOT NULL,
	Age_documents INT NOT NULL
	);

--
-- Table 4 DimCustomer
--
CREATE TABLE DimCustomer
	(Customer_SK INT CONSTRAINT pk_Customer_SK PRIMARY KEY,
	Customer_AK INT NOT NULL,
	Order_date NVARCHAR(40) NOT NULL,
	Bill_postal_code NVARCHAR(120) NOT NULL,
	Bill_state NVARCHAR(2) NOT NULL,
	Bill_nation NVARCHAR(20) NOT NULL,
	Order_currency NVARCHAR(20) NOT NULL,
	Base_currency NVARCHAR(20) NOT NULL,
	Price_adjustment NUMERIC(38,4) NOT NULL
	);

--
-- Table 5 DimDate
--
CREATE TABLE DimDate
	(Date_SK INT CONSTRAINT pk_Date_SK PRIMARY KEY,
	Year NVARCHAR(40) NOT NULL,
	Quarter NVARCHAR(120) NOT NULL,
	Month NVARCHAR(20) NOT NULL,
	Day_of_week NVARCHAR(20) NOT NULL,
	Day_of_month NVARCHAR(2) NOT NULL,
	Day_of_year NVARCHAR(3) NOT NULL,
	Season NVARCHAR(20) NOT NULL
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
	Quantity_Produced INT NOT NULL,
	Quality_Rating NUMERIC(18,0) NOT NULL,
	Production_Cost NUMERIC(38,4) NOT NULL,
	Production_Duration INT NOT NULL,
	CONSTRAINT [pk_CompanyProduction] PRIMARY KEY
   	(Date_SK,
    Customer_SK,
	Shipment_SK,
	Compliance_SK,
	Production_SK)
	);