USE Projects;
GO
-- 📋 Business Requirements
-- • Requirement 1 – Partitioned Running Total Analysis

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
    FORMAT(Quarter_Budget, 'C', 'en_IN') AS Quarter_Budget,
    FORMAT(SUM(Quarter_Budget) OVER(
        PARTITION BY Financial_Year 
        ORDER BY Quarter_Period
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 'C', 'en_IN') AS Running_Total
FROM Quarter_Summary;


-- • Requirement 2 – Regional Performance Benchmarking (Method 1: Direct Joins)

WITH Total_Patients_Screened_T AS (
    SELECT
        fc.District_Location AS District,
        ff.NGO_Partner_Name AS NGO_Partner,
        SUM(fc.Patients_Screened) AS Total_Screened_Patients
    FROM dim_projects dp
    JOIN fact_clinical_outcomes fc ON dp.Project_ID = fc.Project_ID
    JOIN fact_funding_disbursement ff ON dp.Project_ID = ff.Project_ID
    GROUP BY dp.State_Region, fc.District_Location, ff.NGO_Partner_Name
)
SELECT 
    District,
    NGO_Partner,
    Total_Screened_Patients,
    RANK() OVER(PARTITION BY District ORDER BY Total_Screened_Patients DESC) AS NGO_Patients_Screened_Rank
FROM Total_Patients_Screened_T;


-- • Requirement 2 (Method 2: Using a VIEW)

CREATE VIEW Clinic_Data AS
SELECT
    dp.[Project_ID],
    dp.[Project_Name],
    dp.[Target_Disease],
    dp.[State_Region],
    fc.[Metric_ID],
    fc.[District_Location],
    fc.[Patients_Screened],
    fc.[Critical_Cases_Detected],
    fc.[Supplies_Distributed_Units],
    ff.[Transaction_ID],
    ff.[NGO_Partner_Name],
    ff.[Financial_Year],
    ff.[Quarter_Period],
    ff.[Budget_Allocated]
FROM [Projects].[dbo].[fact_funding_disbursement] ff
JOIN [Projects].[dbo].[dim_projects] dp ON ff.[Project_ID] = dp.[Project_ID]
JOIN [Projects].[dbo].[fact_clinical_outcomes] fc ON dp.[Project_ID] = fc.[Project_ID];
GO

-- Querying the View for Rankings
WITH Screened_Patients_Summary AS (
    SELECT
        District_Location AS District,
        NGO_Partner_Name AS NGO_Name,
        SUM(Patients_Screened) AS Total_Screened_Patients
    FROM Clinic_Data
    GROUP BY State_Region, District_Location, NGO_Partner_Name
)
SELECT
    District,
    NGO_Name,
    Total_Screened_Patients,
    RANK() OVER(PARTITION BY District ORDER BY Total_Screened_Patients DESC, NGO_Name) AS Screened_Patients_Rank
FROM Screened_Patients_Summary;


-- • Requirement 3 – Cross-Domain Operational Metrics

SELECT
    State_Region,
    Project_Name,
    SUM(CAST(Supplies_Distributed_Units AS BIGINT)) AS Total_Distributed_Units,
    SUM(CAST(Patients_Screened AS BIGINT)) AS Total_Screened_Patients,
    CAST(SUM(CAST(Supplies_Distributed_Units AS BIGINT)) * 1.0 / 
         NULLIF(SUM(CAST(Patients_Screened AS BIGINT)), 0) AS DECIMAL(10,2)) AS Units_Per_Patient
FROM Clinic_Data
GROUP BY State_Region, Project_Name;
