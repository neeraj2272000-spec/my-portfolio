-- Database Creation & USE 
CREATE DATABASE Projects;
GO

USE Projects;
GO

-- Finding the Table from the Database
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';


SELECT * FROM large_social_sector_impact_data;
SELECT COUNT(*) FROM large_social_sector_impact_data;

/* This is a report of NGO's Project outcomes, tracking multiple districts and NGOs, including:
 - Budgets vs. Actual vs. Report
 - Number of beneficiaries impacted
 - Per-beneficiary cost
 - All records of delayed projects
 - Number of projects by status */


-- • Requirement 1 – Financial Variance: Calculate the difference between Budget_Allocated_INR and Actual_Expenses_INR grouped by District (Identifies over-spending areas).

SELECT 
	district,
	FORMAT(SUM(Budget_Allocated_INR), 'C', 'en-IN') AS Total_Budget_Allocated,
	FORMAT(SUM(Actual_Expenses_INR), 'C' , 'en-IN') AS Total_Actual_Expenses,
	FORMAT(SUM(Budget_Allocated_INR) - SUM(Actual_Expenses_INR), 'C', 'en-IN') AS Budget_vs_Actual_Diff,
	CASE 
		WHEN SUM(Actual_Expenses_INR) > SUM(Budget_Allocated_INR) THEN 'YES' 
		ELSE 'No'
	END AS Over_Spending_Area_Yes_No 
FROM large_social_sector_impact_data
GROUP BY District
ORDER BY Over_Spending_Area_Yes_No;


-- • Requirement 2 – Partner Efficiency: Calculate total budget handled and AVG(Target_Met_Percentage) grouped by NGO_Partner_Implementing (Identifies best-performing NGOs).

SELECT 
	NGO_Partner_Implementing,
	FORMAT(SUM(Budget_Allocated_INR), 'C', 'en-IN') AS Total_Budget,
	FORMAT(SUM(Actual_Expenses_INR), 'C' , 'en-IN') AS Total_Budget_Handled,
	CONCAT(CAST(AVG(Target_Met_Percentage) AS DECIMAL(10,2)), '%') AS AVG_Met_Percentage
FROM large_social_sector_impact_data
GROUP BY NGO_Partner_Implementing
ORDER BY AVG_Met_Percentage DESC;


-- • Requirement 3 – Cost Per Beneficiary: Calculate efficiency by dividing total expenses by total beneficiaries reached.

SELECT
	SUM(Actual_Expenses_INR) AS Total_Actual_Expenses,
	SUM(Beneficiaries_Impacted) AS Total_Beneficiaries_Impacted,
	SUM(Actual_Expenses_INR) / NULLIF(SUM(Beneficiaries_Impacted), 0) AS Per_Beneficiary_Cost
FROM large_social_sector_impact_data;


-- • Requirement 4 – Risk Assessment: Filter and list all records where Project_Status is 'Delayed' AND Target_Percent_Met is below 30%.

SELECT TOP (1000) 
	[Record_ID],
    [Project_Name],
    [District],
    [NGO_Partner_Implementing],
    FORMAT([Budget_Allocated_INR], 'C' , 'en-IN') AS Budget_Allocated,
    FORMAT([Actual_Expenses_INR], 'C', 'en-IN') AS Actual_Expenses,
    [Beneficiaries_Impacted],
    [Project_Status],
    CONCAT(CAST([Target_Met_Percentage] AS DECIMAL(10,2)), '%') AS Target_Met_Percentage
FROM [Projects].[dbo].[large_social_sector_impact_data]
WHERE Project_Status = 'Delayed' 
  AND Target_Met_Percentage < 30
ORDER BY Target_Met_Percentage DESC;


-- • Requirement 5 – Status-Wise Total Projects

SELECT
	Project_Status,
	COUNT(Project_Status) AS Total_Projects,
	FORMAT(SUM(Actual_Expenses_INR), 'C', 'en-IN') AS Total_Expenses,
	CONCAT(CAST(AVG(Target_Met_Percentage) AS DECIMAL(10,2)), '%') AS Avg_Target_Met_Percentage
FROM large_social_sector_impact_data
GROUP BY Project_Status;


-- • Summary Report by NGO Partner

SELECT 
	NGO_Partner_Implementing,
	COUNT(Record_ID) AS Total_Projects_Handled,
	FORMAT(SUM(Budget_Allocated_INR), 'C', 'en-IN') AS Total_Budget,
	FORMAT(SUM(Actual_Expenses_INR), 'C', 'en-IN') AS Total_Expenses,
	CONCAT(CAST(AVG(Target_Met_Percentage) AS DECIMAL (10,2)), '%') AS Avg_Met_Percentage
FROM large_social_sector_impact_data
GROUP BY NGO_Partner_Implementing
ORDER BY Avg_Met_Percentage DESC;
