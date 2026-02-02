# Welfare Dataset (Small Version)

A subset of the General Social Survey (GSS) data used for causal
inference analysis. The GSS is a high-quality, representative sample of
the adult population of the United States, conducted regularly since
1972 to monitor trends in attitudes, behaviors, and attributes.

## Usage

``` r
welfare_small
```

## Format

A data frame with X rows and 9 columns:

- y:

  Outcome variable

- w:

  Treatment variable

- age:

  Age of the respondent

- polviews:

  Political views of the respondent

- income:

  Income of the respondent

- educ:

  Education level of the respondent

- marital:

  Marital status of the respondent

- sex:

  Sex of the respondent

## Source

Smith, Tom W., Michael Davern, Jeremy Freese, and Stephen L. Morgan.
General Social Surveys, 1972-2014. Principal Investigator, Tom W. Smith;
Co-Principal Investigators, Michael Davern, Jeremy Freese, and Stephen
L. Morgan, NORC ed. Chicago: NORC, 2018.

## References

Smith, T. W. (2016). The General Social Surveys. NORC at the University
of Chicago. GSS Project Report No. 32.

## Examples

``` r
data(welfare_small)
head(welfare_small)
#>   y w age polviews income educ marital sex
#> 1 0 0  28        4     11   14       5   1
#> 2 1 0  54        6     12   16       2   2
#> 3 1 0  44        2     12   16       5   2
#> 4 0 0  47        1      5   10       4   1
#> 5 0 1  19        4      9   10       5   2
#> 6 0 0  36        2      8   18       1   1
summary(welfare_small)
#>        y                w               age           polviews    
#>  Min.   :0.0000   Min.   :0.0000   Min.   :18.00   Min.   :1.000  
#>  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:32.00   1st Qu.:3.000  
#>  Median :0.0000   Median :1.0000   Median :43.00   Median :4.000  
#>  Mean   :0.2529   Mean   :0.5354   Mean   :45.39   Mean   :4.107  
#>  3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:57.00   3rd Qu.:5.000  
#>  Max.   :1.0000   Max.   :1.0000   Max.   :89.00   Max.   :7.000  
#>      income           educ          marital           sex       
#>  Min.   : 1.00   Min.   : 0.00   Min.   :1.000   Min.   :1.000  
#>  1st Qu.:10.00   1st Qu.:12.00   1st Qu.:1.000   1st Qu.:1.000  
#>  Median :12.00   Median :13.00   Median :1.000   Median :2.000  
#>  Mean   :10.54   Mean   :13.19   Mean   :2.403   Mean   :1.551  
#>  3rd Qu.:12.00   3rd Qu.:16.00   3rd Qu.:4.000   3rd Qu.:2.000  
#>  Max.   :12.00   Max.   :20.00   Max.   :5.000   Max.   :2.000  
```
