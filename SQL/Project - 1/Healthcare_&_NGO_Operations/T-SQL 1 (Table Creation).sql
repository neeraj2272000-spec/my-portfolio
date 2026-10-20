CREATE DATABASE Projects;
GO

USE Projects;
-- 
===============================================================================
IF OBJECT_ID ('dim_projects', 'U') IS NOT NULL 
	DROP TABLE dim_projects;

IF OBJECT_ID ('fact_clinical_outcomes', 'U') IS NOT NULL
	DROP TABLE fact_clinical_outcomes;

IF OBJECT_ID ('fact_funding_disbursement', 'U') IS NOT NULL
	DROP TABLE fact_funding_disbursement;


-- TABLE CREATION
==============================================================================
CREATE TABLE dim_projects (
	Project_ID VARCHAR(20) PRIMARY KEY,
	Project_Name VARCHAR(100),
	Target_Disease VARCHAR(50),
	State_Region VARCHAR(50)
);


CREATE TABLE fact_clinical_outcomes (
	Metric_ID VARCHAR(50) PRIMARY KEY,
	Project_ID VARCHAR(20),
	District_Location VARCHAR(100),
	Patients_Screened INT,
	Critical_Cases_Detected INT,
	Supplies_Distributed_Units INT,
	FOREIGN KEY (Project_ID) REFERENCES dim_projects(Project_ID)
);


CREATE TABLE fact_funding_disbursement (
	Transaction_ID VARCHAR(50) PRIMARY KEY,
	Project_ID VARCHAR(20),
	NGO_Partner_Name VARCHAR(100),
	Financial_Year INT,
	Quarter_Period VARCHAR (20),
	Budget_Allocated DECIMAL (10,2),
	FOREIGN KEY (Project_ID) REFERENCES dim_projects(Project_ID)
);


-- TABLE Insertion (Update paths as needed)

BULK INSERT dim_projects
FROM 'D:\Python YT\PD\dim_projects.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK);


BULK INSERT fact_clinical_outcomes
FROM 'D:\Python YT\PD\fact_clinical_outcomes.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);


BULK INSERT fact_funding_disbursement
FROM 'D:\Python YT\PD\fact_funding_disbursement.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
