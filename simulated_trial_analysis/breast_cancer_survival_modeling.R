library(survival)
library(dplyr)

set.seed(42)

n <- 2000

# --- Baseline Covariates ---
treatment <- rbinom(n, 1, 0.5)  # 0=Standard, 1=Dose-dense
age <- rnorm(n, mean = 55, sd = 10)

hr_status <- rbinom(n, 1, 0.75)        # 1=HR+, 0=HR-
her2_status <- rbinom(n, 1, 0.20)      # 1=HER2+, 0=HER2-
tnbc <- ifelse(hr_status==0 & her2_status==0, 1, 0)

tumor_size <- sample(c(1,2,3), n, replace=TRUE, prob=c(0.3,0.5,0.2)) 
# 1:<2cm, 2:2-5cm, 3:>5cm

nodes <- sample(c(0,1,2), n, replace=TRUE, prob=c(0.4,0.4,0.2))
# 0:0 nodes, 1:1-3 nodes, 2:4+ nodes

grade <- sample(c(1,2,3), n, replace=TRUE, prob=c(0.2,0.5,0.3))

# --- True Log-Hazard Model ---
lp <- 
  log(0.80) * treatment +                # Treatment effect
  log(1.4) * her2_status +               # HER2 risk
  log(1.8) * tnbc +                      # TNBC higher risk
  log(1.5) * (tumor_size==3) +
  log(2.0) * (nodes==2) +
  log(1.3) * (grade==3) +
  log(1.05) * ((age-55)/10) +            # Age effect
  log(0.70) * (treatment * her2_status)  # Interaction

# --- Baseline Hazard ---
base_hazard <- 0.025

hazard <- base_hazard * exp(lp)

# --- Generate Survival Times ---
time <- rexp(n, rate = hazard)

# Administrative censoring at 10 years
censor_time <- 10
event <- ifelse(time <= censor_time, 1, 0)
time <- pmin(time, censor_time)

trial_data <- data.frame(
  time,
  event,
  treatment,
  age,
  hr_status,
  her2_status,
  tnbc,
  tumor_size,
  nodes,
  grade
)

summary(trial_data)

library(survival)
library(survminer)

km_fit <- survfit(Surv(time, event) ~ treatment, data = trial_data)

ggsurvplot(
  km_fit,
  data = trial_data,
  risk.table = TRUE,
  pval = TRUE,
  conf.int = FALSE,
  legend.labs = c("Standard", "Dose-dense"),
  legend.title = "Treatment",
  xlab = "Years",
  ylab = "Recurrence-Free Survival Probability"
)

cox_model <- coxph(
  Surv(time, event) ~ treatment + age + hr_status + her2_status +
    tnbc + tumor_size + nodes + grade +
    treatment:her2_status,
  data = trial_data
)

summary(cox_model)

# Harrell's C-index using survival package
cox_concordance <- summary(cox_model)$concordance
cox_concordance

write.csv(trial_data, "trial_data.csv", row.names = FALSE)

# ----- Cox Risk Stratification -----

# Linear predictor (risk score)
cox_risk_score <- predict(cox_model, type = "lp")

# Create tertiles
trial_data$cox_risk_group <- cut(
  cox_risk_score,
  breaks = quantile(cox_risk_score, probs = c(0, 0.33, 0.66, 1)),
  labels = c("Low Risk", "Intermediate Risk", "High Risk"),
  include.lowest = TRUE
)

# KM by Cox risk group
cox_risk_fit <- survfit(Surv(time, event) ~ cox_risk_group, data = trial_data)

ggsurvplot(
  cox_risk_fit,
  data = trial_data,
  risk.table = TRUE,
  pval = TRUE,
  legend.title = "Cox Risk Group",
  xlab = "Years",
  ylab = "Recurrence-Free Survival"
)

ggsave("cox_risk_stratification.png", width = 8, height = 6, dpi = 300)