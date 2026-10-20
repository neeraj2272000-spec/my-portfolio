# Healthcare & NGO Operations: Relational SQL Database & Analytics

## 📋 Project Overview
This project implements a relational SQL database for tracking healthcare projects, NGO funding disbursements, and clinical outcomes across multiple regions. It includes data ingestion scripts via `BULK INSERT` and advanced analytical queries leveraging Common Table Expressions (CTEs), Window Functions, and Cross-Domain Aggregations.

---

## 🏗️ Relational Schema
The database uses a star-like schema centered around the dimension table `dim_projects` linked to two transactional fact tables:
1. **`dim_projects`** (Dimension Table): Stores core project metadata, target diseases, and regions.
2. **`fact_clinical_outcomes`** (Fact Table): Tracks regional screening metrics, detected critical cases, and medical supply distribution.
3. **`fact_funding_disbursement`** (Fact Table): Records financial allocations by fiscal year, quarter, and NGO partner.

---

## ⚙️ SQL Requirements & Analytical Queries

### Requirement 1: Partitioned Running Total Analysis
Computes a continuous running sum of budget allocations that automatically resets at the start of each distinct financial year across consecutive operational quarters.

### Requirement 2: Regional Performance Benchmarking
Ranks each NGO implementing partner based on their total volume of patients screened independently inside each unique district location (implemented via both direct joins and SQL Views).

### Requirement 3: Cross-Domain Operational Metrics
Connects project descriptions, financial transactions, and medical results to compute operational efficiency: **Total Medical Supply Units Distributed per Patient Screened** grouped by state and project name.

---

## 🚀 How to Run
1. Update the file paths in the `BULK INSERT` queries inside `sql/01_schema_and_bulk_insert.sql` to match your local system directory.
2. Run `01_schema_and_bulk_insert.sql` to set up the database, tables, and load the data.
3. Execute `02_analytical_queries.sql` to run the analytical insights.
