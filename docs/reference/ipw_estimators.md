# Estimate treatment effects using IPW or AIPW methods

Estimates causal effects using either Inverse Probability Weighting
(IPW) or Augmented Inverse Probability Weighting (AIPW) methods.

## Usage

``` r
ipw_estimators(
  data,
  estimation_method,
  outcome,
  treatment,
  covariates,
  model_specification = "linear",
  output = FALSE,
  ...
)
```

## Arguments

- data:

  Data frame containing the analysis dataset

- estimation_method:

  Character, either 'IPW' or 'AIPW'

- outcome:

  Character, name of the outcome variable

- treatment:

  Character, name of the treatment variable

- covariates:

  Character vector of covariate names

- model_specification:

  Character, type of model specification ('linear', 'interaction', or
  'splines')

- output:

  Logical, whether to return detailed output

- ...:

  Additional arguments passed to underlying functions: For IPW method:
  cv.glmnet() arguments: All arguments are supported with their default
  values.

  For AIPW method: causal_forest() arguments: All arguments are
  supported with num.trees defaulting to 100 instead of 2000. Other
  arguments maintain their default values.

  average_treatment_effect() arguments: All arguments are supported with
  method defaulting to 'AIPW'. Other arguments maintain their default
  values.

## Value

If output=TRUE, returns a list containing:

- estimation_value:

  The estimated treatment effect

- ate_results:

  Detailed results including standard errors and p-values

- e_hat:

  Estimated propensity scores

- model_spec_matrix:

  Model specification matrix

- treatment_variable:

  Treatment indicator vector

## Examples

``` r
if (FALSE) { # \dontrun{
data <- data.frame(
  y = rnorm(100),
  w = rbinom(100, 1, 0.5),
  x1 = rnorm(100),
  x2 = rnorm(100)
)

# Basic usage
results <- ipw_estimators(
  data = data,
  estimation_method = "IPW",
  outcome = "y",
  treatment = "w",
  covariates = c("x1", "x2"),
  model_specification = 'linear',
  output = TRUE
)

# Using additional parameters with AIPW
results_aipw <- ipw_estimators(
  data = data,
  estimation_method = "AIPW",
  outcome = "y",
  treatment = "w",
  covariates = c("x1", "x2"),
  model_specification = 'linear',
  output = TRUE,
  # causal_forest() arguments
  num.trees = 100,
  # average_treatment_effect() arguments
  target.sample = "control"
)
} # }
```
