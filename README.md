Oncology Survival Modeling — Simulated Phase III Breast Cancer Trial
Project Overview

This project simulates a Phase III breast cancer clinical trial (n = 2000) and evaluates recurrence-free survival using both classical biostatistical methods and machine learning survival models.

The objective is to demonstrate hybrid clinical analytics workflows applicable to oncology trials and translational research.

Dataset Characteristics

Sample size: 2000 patients

Endpoint: Recurrence-Free Survival

Covariates:

Treatment arm (standard vs dose-dense)

Age

HR status

HER2 status

Triple-negative status

Tumor size

Lymph node involvement

Tumor grade

Statistical Modeling (R)

Kaplan–Meier survival curves

Multivariable Cox proportional hazards model

Interaction modeling (Treatment × HER2)

Harrell’s C-index evaluation

C-index (Cox Model): ~0.61

Machine Learning Modeling (Python)

Random Survival Forest

Out-of-bag concordance index

Feature importance ranking

C-index (RSF): ~0.58

Key Insights

Treatment arm shows survival benefit

HER2 interaction modifies treatment effect

Classical Cox model outperforms RSF in this structured dataset

Clinical Relevance

Demonstrates hybrid modeling strategy relevant to:

Clinical trial analytics

Oncology outcomes research

Pharma data science workflows

Regulatory survival analysis pipelines
