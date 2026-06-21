# Oncology Survival Modeling Project Evolution

## Project Overview

This project began as a simulated Phase III breast cancer survival analysis exercise and evolved into a modular clinical AI system incorporating statistical survival modeling, machine learning survival analysis, validation frameworks, deployment infrastructure, and agentic workflows.

Across ten development cycles, the project progressed through five major stages:

1. Clinical Trial Analytics
2. Real-World Survival Modeling
3. Model Validation and Decision Support
4. Production-Oriented Engineering
5. Agentic Clinical Intelligence

The objective was not merely to build a predictive model, but to explore the complete lifecycle of a healthcare AI system—from data generation and survival analysis to deployment and clinical interpretation.


## Week 1

Simulating a Phase III Oncology Trial - Hybrid Survival Modeling (R + Python)

### Key Outcome

Established a complete oncology survival modeling workflow integrating Kaplan–Meier analysis, Cox regression, and Random Survival Forests. The project demonstrated treatment efficacy assessment, risk stratification, and interaction modeling while highlighting the continued value of interpretable survival models in clinically structured datasets.

### Artifacts

* 01_KM_Treatment_Effect.png
* 02_Cox_Hazard_Ratios.png
* 03_RSF_Risk_Stratification.png
* 04_RSF_Permutation_Importance.png


---

## Week 2

Survival Benefit vs Toxicity

### Key Outcome

Expanded the Phase III trial simulation to include time-to-adverse-event modeling and benefit–risk assessment. The resulting framework demonstrated how survival benefit and treatment toxicity can be evaluated together, reflecting the real-world trade-offs underlying oncology treatment decisions.

### Artifacts

* ae_cox_forest_plot.png
* benefit_risk_profile.png
* cox_risk_stratification.png

---

## Week 3

Real-World Breast Cancer Survival Analysis (SEER)

### Key Outcome

Established a real-world oncology survival modeling pipeline using SEER data and compared Cox PH, Random Survival Forest, and XGBoost survival models. Results showed that machine learning improved discrimination marginally, but interpretable statistical models remained strong performers for clinical risk prediction.

### Artifacts

* model_performance_cindex.png
* model_risk_stratification.png
* risk_score_correlation.png
* rsf_feature_importance.png
* rsf_survival_stratification.png

---

## Week 4

Model Credibility

### Key Outcome

Moved beyond predictive performance to evaluate clinical credibility of survival models. Demonstrated that model-derived risk groups reproduced established survival patterns observed in oncology practice, confirming that the models were learning clinically meaningful structure rather than merely optimizing statistical metrics.

### Artifacts

* Stage-based survival analysis
* Risk-group survival analysis

---

## Week 5

Decision Impact

### Key Outcome

Extended the survival modeling framework beyond risk prediction to evaluate clinical decision impact. By incorporating calibration analysis and Decision Curve Analysis, the project demonstrated how survival models can be assessed for their potential to improve treatment decisions, translating predictive performance into clinically actionable risk thresholds.

### Artifacts

* calibration.png
* dca.png
* km_curve.png

---

## Week 6

Reproducible Survival Analytics Pipeline

### Key Outcome

Transformed the project from a collection of survival models into a reproducible analytics workflow by introducing structured data layers, standardized outputs, and traceable execution pipelines. This established the foundation for scalable development, validation, and future deployment of survival modeling applications.

### Artifacts

* Folder structure
* Pipeline architecture

---

## Week 7

Config-Driven Survival Modeling Pipeline

### Key Outcome

Evolved the reproducible analytics workflow into a configurable execution framework by introducing parameter-driven pipelines, standardized artifact generation, and modular model orchestration. This shifted the project from reproducible analysis toward an operational system capable of supporting repeatable experimentation, auditing, and future deployment.

### Artifacts

* YAML configuration workflow
* Automated metrics generation

---

## Week 8

Validation and Generalization

### Key Outcome

Introduced rigorous out-of-sample validation to distinguish apparent model performance from true generalization. This demonstrated the importance of evaluating survival models on unseen data, revealing that robust and clinically reliable systems depend on reproducible validation rather than headline performance metrics alone.

### Artifacts

* Train vs test performance comparison
* Validation framework

---

## Week 9

FastAPI Clinical Inference Layer

### Key Outcome

Bridged the gap between validated survival models and real-world application by introducing a standardized inference layer. This transformed the project from a validation-focused analytics system into a deployable clinical service capable of accepting patient inputs, generating risk predictions, and supporting integration with downstream applications and decision-support workflows.

### Artifacts

* Oncology Survival Inference API
* Swagger/OpenAPI interface

---

## Week 10

LangGraph Oncology Risk Assessment Agent

### Key Outcome

Integrated validated survival models, deployment infrastructure, and clinical interpretation workflows into an agentic oncology risk assessment system. This transformed the project from a prediction service into a workflow-driven clinical AI application capable of generating risk assessments, contextual interpretations, and structured recommendations from patient-level inputs.

### Artifacts

* Agent workflow
* Clinical interpretation layer
* Structured report generation
