# ==========================================================
# Time-to-Adverse Event Modeling
# Clinical Trial Safety Analysis
# Oncology Survival Modeling Project
# ==========================================================

# ==========================================================
# Generate Adverse Event Data
# ==========================================================

set.seed(123)

# Load existing trial dataset
trial_data <- read.csv("trial_data.csv")

n <- nrow(trial_data)

# Baseline AE hazard
baseline_ae <- 0.08

# Dose-dense therapy increases toxicity
treatment_effect <- ifelse(trial_data$treatment == 1, 1.35, 1)

# Higher AE risk for aggressive tumors
tnbc_effect <- ifelse(trial_data$tnbc == 1, 1.25, 1)

# Larger tumors slightly increase AE probability
tumor_effect <- ifelse(trial_data$tumor_size == 3, 1.2, 1)

# Combined AE hazard
ae_hazard <- baseline_ae * treatment_effect * tnbc_effect * tumor_effect

# Simulate AE time
trial_data$ae_time <- rexp(n, rate = ae_hazard)

# Administrative censoring at 10 years
censor_time <- 10

trial_data$ae_event <- ifelse(trial_data$ae_time <= censor_time, 1, 0)

trial_data$ae_time <- pmin(trial_data$ae_time, censor_time)

# Save updated dataset
write.csv(trial_data, "trial_data_with_ae.csv", row.names = FALSE)

# Baseline AE hazard
baseline_ae <- 0.08

# Treatment toxicity effect
treatment_effect <- ifelse(trial_data$treatment == 1, 1.3, 1)

# Higher AE risk for TNBC and large tumors
tnbc_effect <- ifelse(trial_data$tnbc == 1, 1.2, 1)
tumor_effect <- ifelse(trial_data$tumor_size == 3, 1.25, 1)

# Combined AE hazard
ae_hazard <- baseline_ae * treatment_effect * tnbc_effect * tumor_effect

# Simulate AE time
trial_data$ae_time <- rexp(n, rate = ae_hazard)

# Administrative censoring at 10 years
ae_censor_time <- 10

trial_data$ae_event <- ifelse(trial_data$ae_time <= ae_censor_time, 1, 0)
trial_data$ae_time <- pmin(trial_data$ae_time, ae_censor_time)
