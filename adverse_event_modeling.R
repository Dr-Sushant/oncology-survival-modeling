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

write.csv(trial_data, "trial_data_with_ae.csv", row.names = FALSE)

library(survival)
library(survminer)

ae_surv <- Surv(trial_data$ae_time, trial_data$ae_event)

ae_fit <- survfit(ae_surv ~ treatment, data = trial_data)

ggsurvplot(
  ae_fit,
  data = trial_data,
  risk.table = TRUE,
  pval = TRUE,
  conf.int = TRUE,
  legend.labs = c("Standard", "Dose-dense"),
  xlab = "Years",
  ylab = "Adverse Event-Free Probability",
  title = "Time to Adverse Event by Treatment"
)

ggsave(
  "ae_kaplan_meier_curve.png",
  width = 8,
  height = 6,
  dpi = 300
)

# Cox model for adverse event risk
ae_cox_model <- coxph(
  Surv(ae_time, ae_event) ~ treatment + age + hr_status + her2_status +
    tnbc + tumor_size + nodes + grade,
  data = trial_data
)

summary(ae_cox_model)

# Test proportional hazards assumption
ae_ph_test <- cox.zph(ae_cox_model)

ae_ph_test

plot(ae_ph_test)

# Harrell's C-index
ae_cindex <- summary(ae_cox_model)$concordance

ae_cindex

ggforest(
  ae_cox_model,
  data = trial_data,
  main = "Cox Model — Risk of Adverse Events"
)

ggsave(
  "ae_cox_forest_plot.png",
  width = 8,
  height = 6,
  dpi = 300
)

# Extract HR for recurrence model
recurrence_hr <- exp(coef(cox_model)["treatment"])

# Extract HR for adverse event model
toxicity_hr <- exp(coef(ae_cox_model)["treatment"])

benefit_risk <- data.frame(
  outcome = c("Recurrence Risk", "Adverse Event Risk"),
  HR = c(recurrence_hr, toxicity_hr)
)

library(ggplot2)

ggplot(benefit_risk, aes(x = outcome, y = HR, fill = outcome)) +
  geom_bar(stat = "identity", width = 0.6) +
  
  geom_hline(
    yintercept = 1,
    linetype = "dashed",
    color = "black",
    size = 0.8
  ) +
  
  geom_text(
    aes(label = round(HR, 2)),
    vjust = -0.5,
    size = 5,
    fontface = "bold"
  ) +
  
  scale_fill_manual(
    values = c(
      "Adverse Event Risk" = "#E76F51",
      "Recurrence Risk" = "#2A9D8F"
    )
  ) +
  
  labs(
    title = "Benefit–Risk Profile of Dose-Dense Therapy",
    subtitle = "Comparison of Recurrence Reduction vs Treatment Toxicity",
    x = "",
    y = "Hazard Ratio (Treatment vs Standard)"
  ) +
  
  theme_minimal(base_size = 14) +
  
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 12)
  )

ggsave(
  "benefit_risk_profile.png",
  width = 9,
  height = 6,
  dpi = 300
)