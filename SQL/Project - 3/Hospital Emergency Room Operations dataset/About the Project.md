# 🏥 Hospital Emergency Room (ER) Operations & Patient Flow Analytics

## 📌 Project Overview
This project provides an end-to-end operational and clinical analysis of Hospital Emergency Room (ER) performance. By combining raw relational database queries (**T-SQL**) with interactive Power BI dashboards, this project analyzes patient visitation patterns, admission pipeline efficiency, wait times, department referral bottlenecks, and demographic distribution.

The goal is to provide hospital management and operational leaders with data-driven insights to reduce patient wait times, optimize ER doctor/nurse shift schedules, and streamline department transfers.

---

## 🔑 Key Operational Metrics & Findings

* **Total Patient Inflow:** Tracked **9,216 total ER patient visits** across the dataset period.
* **Admission Pipeline Rate:** Exactly **50.04% of patients were admitted** to inpatient wards, while **49.96% were treated and discharged**.
* **Average Wait Time:** Hospital-wide average ER wait time sits at **35.3 minutes**.
* **Target Compliance Rate:** Only about 39% of patients are seen within the 30-minute target window, while about 61% miss the target.
* **Peak Visitation Hours:** Heavy arrival volume occurs in late evening and night shifts (**19:00 to 24:00**), with hourly patient traffic doubling compared to morning slots.
* **Primary Department Referrals:** Over **40% of patients require specialized department transfers**, with **General Practice (1.8K)** and **Orthopedics (1.0K)** receiving the highest referral volume.
* **Patient Satisfaction Score:** Maintained a high overall patient satisfaction rating averaging **5.0 / 5.0**.

---

## 🛠️ Technical Stack & Implementation

* **Database Engine:** SQL Server (T-SQL)
* **Data Modeling & Visualization:** Power BI Desktop (DAX, Dynamic Slicers, Custom Navigation)
* **Data Transformation:** Power Query (Time duration formatting, age binning, conditional column logic)

---

## 💡 Strategic Recommendations

1. **Optimize Peak Shift Staffing:** Increase nursing and triage doctor capacity during peak arrival slots (**19:00 – 24:00**) to lower the 39% missed-target wait time rate.
2. **Streamline Referral Bottlenecks:** Establish fast-track referral pathways between ER triage and high-volume departments (**General Practice & Orthopedics**) to reduce overall room turnover time.
3. **Targeted Care for High-Volume Age Groups:** Ensure dedicated geriatric and youth emergency care pathways, as the 10–39 age brackets represent the largest combined demographic segment.
