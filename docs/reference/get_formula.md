# Generate formula for model specification

Provides a formula for model specification based on given variables and
model type.

## Usage

``` r
get_formula(vars, model_spec = "linear")
```

## Arguments

- vars:

  Character vector of variable names.

- model_spec:

  Character string specifying the model type: 'linear', 'interaction',
  or 'splines'.

## Value

A formula object.
