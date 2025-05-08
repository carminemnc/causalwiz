# Development testing script
library(devtools)
load_all()

theme_set(ctheme("dark"))

# Load data
data(welfare_small)
data <- welfare_small

#########
#########
#########

# Treatment: does the the gov't spend too much on "welfare" (1) or "assistance to the poor" (0)
treatment <- "w"

# Outcome: 1 for 'yes', 0 for 'no'
outcome <- "y"

# Additional covariates
covariates <- c("age", "polviews", "income", "educ", "marital", "sex")

# in a real context...
data_real <- data

# defining the group that will be dropped with some high probability
grp <- ((data_real$w == 1) &  # if treated AND...
          (
            (data_real$age > 45) |     # belongs an older group OR
              (data_real$polviews < 5)   # more conservative
          )) | # OR
  ((data_real$w == 0) &  # if untreated AND...
     (
       (data_real$age < 45) |     # belongs a younger group OR
         (data_real$polviews > 4)   # more liberal
     ))

# Individuals in the group above have a smaller chance of being kept in the sample
prob.keep <- ifelse(grp, .15, .85)
keep.idx <- as.logical(rbinom(n=nrow(data_real), prob=prob.keep, size = 1))

# Dropping
data_real <- data_real[keep.idx,]

#########
#########
#########

#### IPW estimation

results <- ipw_estimators(
  data = data_real,
  estimation_method = 'IPW',
  outcome = outcome,
  treatment = treatment,
  covariates = covariates,
  model_specification = 'linear',
  output = TRUE,
)


#### AIPW estimation

results <- ipw_estimators(
  data = data_real,
  estimation_method = 'AIPW',
  outcome = outcome,
  treatment = treatment,
  covariates = covariates,
  model_specification = 'linear',
  output = TRUE,
  # causal_forest() arguments
  num.trees = 100,
  # average_treatment_effect() arguments
  target.sample = "overlap"
)


#### Diagnostics

bal <- aipw_balancer(
  results$model_spec_matrix,
  results$treatment_variable,
  results$e_hat
)

cov_bal_plot(results$model_spec_matrix,
             bal$unadjusted_cov,
             bal$adjusted_cov)

prop_plot(
  results$e_hat,
  results$treatment_variable
)
