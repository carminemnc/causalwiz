library(causalwiz)

# Load data
data(welfare_small)
data <- welfare_small

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


#### AIPW estimation

results <- ipw_estimators(
  data = data_real,
  estimation_method = 'AIPW',
  outcome = outcome,
  treatment = treatment,
  covariates = covariates,
  model_specification = 'linear',
  output = TRUE
)
