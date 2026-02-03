# 

`causalwiz` is an R package for causal inference analysis. It provides
functions for estimating treatment effects using various statistical
methods, features built-in plotting functions an utilities designed for
causal inference workflows in R.

## Installation

You can install the package via Github repository:

``` r
# install.packages("pak")
pak::pak("carminemnc/causalwiz")
```

## Usage

``` r
library(causalwiz)

# Load example data
data("welfare_small")

# Perform causal analysis
results <- ipw_estimators(
  data = welfare_small,
  estimation_method = "IPW",
  outcome = "y",
  treatment = "w",
  covariates = c("age", "polviews", "income", "educ", "marital", "sex")
)
```
