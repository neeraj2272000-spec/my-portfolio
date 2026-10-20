# Social Sector Impact Analysis: SQL Database & NGO Performance Reporting

## 📋 Project Overview
This project evaluates social sector and NGO project outcomes across multiple districts. Using T-SQL, it analyzes financial variances, partner efficiencies, per-beneficiary costs, project status distributions, and risk assessments for delayed initiatives.

---

## 🏗️ Core Analysis Requirements
1. **Financial Variance**: Compares budget allocations against actual expenses grouped by district to flag over-spending areas.
2. **Partner Efficiency**: Ranks implementing NGO partners by average target-met percentages and total budgets handled.
3. **Cost Per Beneficiary**: Computes operational efficiency by dividing total expenses by total beneficiaries reached.
4. **Risk Assessment**: Filters and isolates delayed projects where target completion percentages fall below 30%.
5. **Status-Wise Tracking**: Summarizes total projects, expenses, and target performance metrics across various project statuses.

---

## 🚀 How to Run
1. Ensure your SQL Server instance has the `Projects` database and `large_social_sector_impact_data` table populated.
2. Run the script inside the `sql/` folder in SQL Server Management Studio (SSMS).
