-- ===============================================================================
-- Healthcare Funding & Clinical Outcomes: Business Requirements
-- Run "T-SQL 1 (Table Creation).sql" first.
-- ===============================================================================

USE Projects;
GO

-- ===============================================================================
-- Requirement 1: Partitioned running total of budget
-- The running total resets at the start of each financial year.
-- ===============================================================================
WITH Quarter_Summary AS (
    SELECT
        Financial_Year,
        Quarter_Period,
        SUM(Budget_Allocated) AS Quarter_Budget
    FROM fact_funding_disbursement
    GROUP BY Financial_Year, Quarter_Period
)
SELECT
    Financial_Year,
    Quarter_Period,
    FORMAT(Quarter_Budget, 'C', 'en-IN') AS Quarter_Budget,
    FORMAT(
        SUM(Quarter_Budget) OVER (
            PARTITION BY Financial_Year
            ORDER BY Quarter_Period
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 'C', 'en-IN') AS Running_Total
FROM Quarter_Summary
ORDER BY Financial_Year, Quarter_Period;


-- ===============================================================================
-- Requirement 2: Rank NGO partners by patients screened within each district
-- Note: the funding table has many rows per project, so each project is paired
-- with its NGO partner once (DISTINCT) before joining. This avoids counting the
-- same screened patients several times.
-- ===============================================================================

-- Method 1: CTEs and joins
WITH Project_NGO AS (
    SELECT DISTINCT Project_ID, NGO_Partner_Name
    FROM fact_funding_disbursement
),
Total_Patients_Screened AS (
    SELECT
        fc.District_Location AS District,
        pn.NGO_Partner_Name  AS NGO_Partner,
        SUM(fc.Patients_Screened) AS Total_Screened_Patients
    FROM fact_clinical_outcomes fc
    JOIN Project_NGO pn ON fc.Project_ID = pn.Project_ID
    GROUP BY fc.District_Location, pn.NGO_Partner_Name
)
SELECT
    District,
    NGO_Partner,
    Total_Screened_Patients,
    RANK() OVER (
        PARTITION BY District
        ORDER BY Total_Screened_Patients DESC, NGO_Partner
    ) AS Screened_Patients_Rank
FROM Total_Patients_Screened
ORDER BY District, Screened_Patients_Rank;
GO

-- Method 2: reusable VIEW
-- CREATE VIEW must be the first statement in its batch, hence the GO above.
CREATE OR ALTER VIEW Clinic_Data AS
SELECT
    dp.Project_ID,
    dp.Project_Name,
    dp.Target_Disease,
    dp.State_Region,
    fc.Metric_ID,
    fc.District_Location,
    fc.Patients_Screened,
    fc.Critical_Cases_Detected,
    fc.Supplies_Distributed_Units,
    pn.NGO_Partner_Name
FROM fact_clinical_outcomes fc
JOIN dim_projects dp ON fc.Project_ID = dp.Project_ID
JOIN (
    SELECT DISTINCT Project_ID, NGO_Partner_Name
    FROM fact_funding_disbursement
) pn ON fc.Project_ID = pn.Project_ID;
GO

WITH Screened_Patients_Summary AS (
    SELECT
        District_Location AS District,
        NGO_Partner_Name  AS NGO_Name,
        SUM(Patients_Screened) AS Total_Screened_Patients
    FROM Clinic_Data
    GROUP BY District_Location, NGO_Partner_Name
)
SELECT
    District,
    NGO_Name,
    Total_Screened_Patients,
    RANK() OVER (
        PARTITION BY District
        ORDER BY Total_Screened_Patients DESC, NGO_Name
    ) AS Screened_Patients_Rank
FROM Screened_Patients_Summary
ORDER BY District, Screened_Patients_Rank;


-- ===============================================================================
-- Requirement 3: Supply units distributed per patient screened
-- Grouped by state region and project name. Only the clinical and project tables
-- are needed, so no duplication from the funding table.
-- ===============================================================================
SELECT
    dp.State_Region,
    dp.Project_Name,
    SUM(CAST(fc.Supplies_Distributed_Units AS BIGINT)) AS Total_Distributed_Units,
    SUM(CAST(fc.Patients_Screened AS BIGINT))          AS Total_Screened_Patients,
    CAST(
        SUM(CAST(fc.Supplies_Distributed_Units AS BIGINT)) * 1.0 /
        NULLIF(SUM(CAST(fc.Patients_Screened AS BIGINT)), 0)
        AS DECIMAL(10,2)) AS Units_Per_Patient
FROM fact_clinical_outcomes fc
JOIN dim_projects dp ON fc.Project_ID = dp.Project_ID
GROUP BY dp.State_Region, dp.Project_Name
ORDER BY dp.State_Region, dp.Project_Name;
