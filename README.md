
<!-- README.md is generated from README.Rmd. Please edit that file -->

# causalwiz

<!-- badges: start -->
<!-- badges: end -->

<img src="man/figures/logo.png" align="right" height="139"/>

`causalwiz` is an R package for causal inference analysis. It provides
tools for estimating treatment effects using various methods including
Inverse Probability Weighting (IPW) and Augmented Inverse Probability
Weighting (AIPW).

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
