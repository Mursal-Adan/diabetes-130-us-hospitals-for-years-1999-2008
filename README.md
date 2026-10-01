# Diabetic Hospital Readmission Analysis

## Business Problem
A hospital network wants to understand which patient, admission, and treatment factors are associated with 30-day readmission, to identify where to focus efforts on reducing preventable readmissions — analyzed using SQL, visualized in Power BI.

## Dataset
**Diabetes 130-US Hospitals (1999–2008)** — 101,766 real patient encounters from 130 US hospitals, 50 columns, plus an ID mapping file for admission type, discharge disposition, and admission source.
Source: [Kaggle](https://www.kaggle.com/datasets/brandao/diabetes) (or [UCI](https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008))

## Tools
MySQL (cleaning, analysis, views) · Power BI (visualization)

## Process
1. **Investigation** — checked structure, row counts, missing value patterns (`?` placeholders), duplicates, category consistency, and referential integrity against 3 lookup tables.
2. **Cleaning** — replaced `?` with "Unknown" in 6 columns, converted 9 numeric and 3 ID columns from text to proper types, flagged `weight` as 96.9% missing rather than dropping it, built a simplified `readmitted_30d` column after tracing and fixing a hidden carriage-return character bug.
3. **Analysis** — answered 7 business questions in SQL (admission type, discharge disposition, length of stay, treatment intensity, prior utilization, diabetes management, age), saved as 8 SQL views.
4. **Visualization** — connected Power BI directly to the MySQL views and built a 2-page, 10-chart dashboard.

## Dashboard

**Page 1 — Admission & Demographics**
![Admission & Demographics](Visuals/Admission%20%26%20Demographics.png)

**Page 2 — Treatment & Utilization**
![Treatment & Utilization](Visuals/Treatment%20%26%20Utilization.png)

## Key Findings

**Strongest patterns**
- Prior healthcare use is the strongest signal: readmitted patients had ~2x the average prior ER visits (0.36 vs 0.18) and ~2.2x the average prior inpatient stays (1.22 vs 0.56).
- Insulin dose changes matter: readmission rate rises from No insulin (10.04%) → Steady (11.13%) → Up (12.99%) → Down (13.90%).

**Moderate patterns**
- Discharge destination: rehab facilities (27.70%) and skilled nursing facilities (14.66%) show notably higher readmission rates than discharge home (9.30%).
- A1C testing status: patients with no A1C test recorded (83% of all patients) had a higher readmission rate (11.42%) than tested patients (9.66%–10.05%).
- Age: lowest readmission rate in the 50–60 group (9.67%), generally rising through the senior years (60–90, ~11–12%).

**Weak or minimal patterns**
- Admission type, length of stay, treatment intensity (medications/labs/diagnoses), and medication change flag — all within a few percentage points.

## Recommendations
- Prioritize discharge planning and follow-up for patients with a history of frequent ER visits or prior inpatient stays.
- Pay closer attention to patients whose insulin dose is decreased during their stay.
- Strengthen post-discharge support for patients going to rehab facilities or SNFs, not just those discharged home.
- Investigate why 83% of patients have no A1C test on record.
- Treat admission type, length of stay, and treatment intensity as weak standalone predictors.

## Files
- `hospital_diabetes.sql` — full SQL script: table creation, cleaning, analysis queries, and views
- `Diabetic_Hospital_Data_Analysis_Dashboard.pbix` — Power BI dashboard
- `Visuals/` — dashboard screenshots

**Note:** the raw dataset (101,766 rows) is not included due to size. Download it from the Kaggle/UCI link above.

## Limitations
- Shows association, not causation
- `weight` (96.9% missing), `payer_code` (39.6%), and `medical_specialty` (49%) have substantial missingness and limited reliability
- Several discharge disposition and admission categories have very small sample sizes (under 100 patients); their rates are not reliable findings
- No formal statistical significance testing (e.g. chi-square) was run on category comparisons
