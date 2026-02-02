# Custom theme for ggplot2

Creates a custom theme for ggplot2 visualizations with support for dark
and light modes

## Usage

``` r
ctheme(mode = "dark")
```

## Arguments

- mode:

  Character string specifying the theme mode ("dark" or "light")

## Value

A ggplot2 theme object

## Examples

``` r
if (FALSE) { # \dontrun{
# Dark mode
theme_set(ctheme("dark"))

# Light mode
theme_set(ctheme("light"))
} # }
```
