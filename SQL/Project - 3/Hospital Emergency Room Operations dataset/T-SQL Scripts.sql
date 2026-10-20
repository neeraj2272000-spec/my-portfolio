-- ====================================================================
-- Project: Hospital Emergency Room (ER) Operations & Patient Flow Analytics
-- Author: Neeraj
-- Tech Stack: SQL Server (T-SQL)
-- Description: End-to-end database schema, data transformations, and 
--              KPI calculations for ER patient admissions and wait times.
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. DATABASE & TABLE SETUP
-- --------------------------------------------------------------------
CREATE TABLE er_patient_data (
    patient_id VARCHAR(50) PRIMARY KEY,
    patient_gender VARCHAR(20),
    patient_age INT,
    patient_race VARCHAR(50),
    department_referral VARCHAR(100),
    admission_status VARCHAR(50), -- 'Admitted' or 'Not Admitted'
    wait_time_minutes INT,
    seen_within_30_mins VARCHAR(20), -- 'Within Target' or 'Missed Target'
    patient_satisfaction_score DECIMAL(3,1),
    arrival_date DATE,
    arrival_time TIME
);

-- --------------------------------------------------------------------
-- 2. EXECUTIVE OVERVIEW KPIs
-- --------------------------------------------------------------------

-- Total Patients, Total Admitted, Avg Wait Time & Patient Satisfaction
SELECT 
    COUNT(patient_id) AS total_patients,
    SUM(CASE WHEN admission_status = 'Admitted' THEN 1 ELSE 0 END) AS total_admitted,
    SUM(CASE WHEN department_referral IS NOT NULL AND department_referral <> 'None' THEN 1 ELSE 0 END) AS total_referred,
    ROUND(AVG(CAST(wait_time_minutes AS FLOAT)), 1) AS avg_wait_time_mins,
    ROUND(AVG(CAST(patient_satisfaction_score AS FLOAT)), 1) AS avg_satisfaction_score
FROM er_patient_data;


-- --------------------------------------------------------------------
-- 3. ADMISSION PIPELINE ANALYSIS
-- --------------------------------------------------------------------

-- Admission vs. Non-Admission Breakdown and Percentage
SELECT 
    admission_status,
    COUNT(patient_id) AS patient_count,
    ROUND(CAST(COUNT(patient_id) AS FLOAT) * 100.0 / SUM(COUNT(patient_id)) OVER(), 2) AS pct_of_admission
FROM er_patient_data
GROUP BY admission_status;


-- --------------------------------------------------------------------
-- 4. WAIT TIME BENCHMARK COMPLIANCE (30-MIN TARGET)
-- --------------------------------------------------------------------

-- Percentage of Patients Seen Within 30 Minutes
SELECT 
    seen_within_30_mins,
    COUNT(patient_id) AS patient_count,
    ROUND(CAST(COUNT(patient_id) AS FLOAT) * 100.0 / SUM(COUNT(patient_id)) OVER(), 2) AS percentage
FROM er_patient_data
GROUP BY seen_within_30_mins;


-- --------------------------------------------------------------------
-- 5. DEPARTMENTAL REFERRAL ANALYSIS
-- --------------------------------------------------------------------

-- Patient Referral Counts across Specialty Departments
SELECT 
    ISNULL(department_referral, 'None') AS department_referral,
    COUNT(patient_id) AS patient_count
FROM er_patient_data
GROUP BY department_referral
ORDER BY patient_count DESC;


-- --------------------------------------------------------------------
-- 6. DEMOGRAPHIC & PATIENT SEGMENTATION
-- --------------------------------------------------------------------

-- Patient Distribution by Age Buckets
SELECT 
    CASE 
        WHEN patient_age BETWEEN 0 AND 9 THEN '0-9'
        WHEN patient_age BETWEEN 10 AND 19 THEN '10-19'
        WHEN patient_age BETWEEN 20 AND 29 THEN '20-29'
        WHEN patient_age BETWEEN 30 AND 39 THEN '30-39'
        WHEN patient_age BETWEEN 40 AND 49 THEN '40-49'
        WHEN patient_age BETWEEN 50 AND 59 THEN '50-59'
        WHEN patient_age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70-79'
    END AS age_group,
    COUNT(patient_id) AS total_patients
FROM er_patient_data
GROUP BY 
    CASE 
        WHEN patient_age BETWEEN 0 AND 9 THEN '0-9'
        WHEN patient_age BETWEEN 10 AND 19 THEN '10-19'
        WHEN patient_age BETWEEN 20 AND 29 THEN '20-29'
        WHEN patient_age BETWEEN 30 AND 39 THEN '30-39'
        WHEN patient_age BETWEEN 40 AND 49 THEN '40-49'
        WHEN patient_age BETWEEN 50 AND 59 THEN '50-59'
        WHEN patient_age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70-79'
    END
ORDER BY age_group;

-- Patient Volume by Gender
SELECT 
    patient_gender,
    COUNT(patient_id) AS patient_count,
    ROUND(CAST(COUNT(patient_id) AS FLOAT) * 100.0 / SUM(COUNT(patient_id)) OVER(), 2) AS percentage
FROM er_patient_data
GROUP BY patient_gender;

-- Patient Inflow by Race / Ethnicity
SELECT 
    patient_race,
    COUNT(patient_id) AS patient_count
FROM er_patient_data
GROUP BY patient_race
ORDER BY patient_count DESC;


-- --------------------------------------------------------------------
-- 7. PEAK VISITATION & HOURLY HEATMAP MATRIX
-- --------------------------------------------------------------------

-- Patient Traffic by Hour of Day and Day of Week
SELECT 
    DATEPART(HOUR, arrival_time) AS arrival_hour,
    DATENAME(WEEKDAY, arrival_date) AS day_of_week,
    COUNT(patient_id) AS total_arrivals
FROM er_patient_data
GROUP BY DATEPART(HOUR, arrival_time), DATENAME(WEEKDAY, arrival_date)
ORDER BY arrival_hour, day_of_week;
