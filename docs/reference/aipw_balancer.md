# Calculate covariate balance metrics

Calculates unadjusted and adjusted covariate balance metrics using AIPW
method.

## Usage

``` r
aipw_balancer(XX, W, e.hat)
```

## Arguments

- XX:

  Matrix of covariates.

- W:

  Vector of treatment assignments.

- e.hat:

  Vector of estimated propensity scores.

## Value

A list containing adjusted and unadjusted covariate balance metrics.
