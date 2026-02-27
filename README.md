Oncology Survival Modeling

Simulated Phase III Breast Cancer Trial (Hybrid R + Python)

Executive Summary

This project simulates a Phase III breast cancer clinical trial (n = 2000) and evaluates recurrence-free survival using both classical biostatistical methods and machine learning survival models.

The objective is to demonstrate an end-to-end hybrid clinical analytics workflow applicable to oncology trials, translational research, and regulatory survival modeling.

Study Design (Simulated)

Sample size: 2000 patients
Endpoint: Recurrence-Free Survival (time-to-event)
Comparison: Standard vs Dose-Dense Treatment
Censoring: Administrative censoring applied

Clinical Covariates Modeled

Treatment arm

Age

Hormone receptor (HR) status

HER2 status

Triple-negative status

Tumor size

Lymph node involvement

Tumor grade

Statistical Survival Modeling (R)

Kaplan–Meier survival estimation

Log-rank test

Multivariable Cox Proportional Hazards model

Treatment × HER2 interaction analysis

Harrell’s Concordance Index

Performance:

C-index (Cox Model): ~0.61

Interpretation: Moderate discrimination consistent with structured clinical covariate modeling.

Machine Learning Survival Modeling (Python)

Random Survival Forest

Out-of-bag concordance estimation

Feature importance ranking

Performance:

C-index (RSF): ~0.58

Interpretation: Comparable but slightly lower discrimination relative to classical Cox modeling in this structured dataset.

Key Findings

Dose-dense treatment demonstrates survival benefit

HER2 status modifies treatment effect

Cox regression provides better discrimination than Random Survival Forest under proportional hazards assumptions

Interaction modeling enhances clinical interpretability

Methodological Strengths

Integration of statistical and machine learning survival models

Explicit interaction modeling (Treatment × HER2)

Cross-platform validation (R and Python)

Discrimination assessment using C-index

Reproducible hybrid analytics workflow

Technical Stack

R:

survival

survminer

Python:

scikit-survival

lifelines

pandas

numpy

Repository Structure

breast_cancer_survival_modeling.R — Cox regression and survival analysis in R

python_survival_modeling.ipynb — Random Survival Forest implementation in Python

trial_data.csv — Simulated Phase III clinical dataset

Practical Relevance

This workflow mirrors real-world analytics tasks in:

Clinical trial data analysis

Oncology outcomes research

Pharma biostatistics support

Real-world evidence modeling

Regulatory survival analysis pipelines

## Model Diagnostics

The proportional hazards assumption was assessed using Schoenfeld residuals.  
The global test was non-significant (p = 0.46).  
Time-varying coefficient modeling was explored but did not improve discrimination, supporting retention of the standard Cox model.
