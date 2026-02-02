# Create covariates balance plot

Creates a plot comparing standardized mean differences (SMD) for
covariates before and after adjustment. The plot displays two panels:
one showing unadjusted SMDs and another showing adjusted SMDs. Values
closer to zero indicate better balance between treatment and control
groups.

## Usage

``` r
cov_bal_plot(XX, unadjusted, adjusted)
```

## Arguments

- XX:

  Matrix of covariates

- unadjusted:

  Vector of unadjusted values

- adjusted:

  Vector of adjusted values

## Value

A ggplot object
