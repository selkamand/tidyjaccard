
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TidyJaccard

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidyjaccard)](https://CRAN.R-project.org/package=tidyjaccard)
[![Codecov test
coverage](https://codecov.io/gh/selkamand/tidyjaccard/branch/master/graph/badge.svg)](https://app.codecov.io/gh/selkamand/tidyjaccard?branch=master)
[![R-CMD-check](https://github.com/selkamand/tidyjaccard/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/selkamand/tidyjaccard/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Effortless all vs all jaccard similarity from tidy dataframes.

## Philosophy

For TidyJaccard to work seamlessly, ensure that your dataframe includes
two columns:

1.  **sample_identifier**: This column should contain unique identifiers
    for each sample in your dataset.

2.  **feature**: Each row in this column defines an element within the
    set corresponding to the respective sample identifier. This column
    plays a pivotal role in calculating Jaccard similarity.

Specific columns don’t matter

## Installation

You can install the development version of tidyjaccard like so:

``` r
remotes::install_github('selkamand/tidyjaccard')
```

## Getting Started

Let’s walk through a toy example using a dataset describing physical
traits of members of two different families:

Family 1: Smith (5 members) Family 2: Johnson (3 members)

For each member of the family, we’ve recorded a bunch of physical
traits. Each row in our dataset describes one trait present in one
individual.

Lets look at the data:

``` r
# Read data
path_data <- system.file(package='tidyjaccard', 'smith_and_johnson.csv')
df_family <- read.csv(path_data)

# Print data
head(df_family)
#>          name          trait
#> 1 Harry Smith           tall
#> 2 Harry Smith     brown hair
#> 3 Harry Smith      pink eyes
#> 4 Harry Smith       freckles
#> 5 Harry Smith double jointed
#> 6 Harry Smith   pointed ears
```

Now lets compute similarity between each person by their traits

``` r
library(tidyjaccard)

df_family |>
  tidy_pairwise_jaccard_similarity(col_sample = "name", col_trait = "trait")
#>           name1          name2    jaccard set_size
#> 1   Harry Smith     Luna Smith 0.15384615       13
#> 2   Harry Smith    Oscar Smith 0.23076923       13
#> 3   Harry Smith   Amelia Smith 0.13333333       15
#> 4   Harry Smith     Noah Smith 0.18181818       11
#> 5   Harry Smith    Mia Johnson 0.00000000       13
#> 6   Harry Smith   Liam Johnson 0.07142857       14
#> 7   Harry Smith Olivia Johnson 0.16666667       12
#> 8    Luna Smith    Oscar Smith 0.07142857       14
#> 9    Luna Smith   Amelia Smith 0.45454545       11
#> 10   Luna Smith     Noah Smith 0.20000000       10
#> 11   Luna Smith    Mia Johnson 0.09090909       11
#> 12   Luna Smith   Liam Johnson 0.00000000       14
#> 13   Luna Smith Olivia Johnson 0.08333333       12
#> 14  Oscar Smith   Amelia Smith 0.13333333       15
#> 15  Oscar Smith     Noah Smith 0.18181818       11
#> 16  Oscar Smith    Mia Johnson 0.00000000       13
#> 17  Oscar Smith   Liam Johnson 0.00000000       15
#> 18  Oscar Smith Olivia Johnson 0.00000000       14
#> 19 Amelia Smith     Noah Smith 0.16666667       12
#> 20 Amelia Smith    Mia Johnson 0.07692308       13
#> 21 Amelia Smith   Liam Johnson 0.14285714       14
#> 22 Amelia Smith Olivia Johnson 0.15384615       13
#> 23   Noah Smith    Mia Johnson 0.11111111        9
#> 24   Noah Smith   Liam Johnson 0.09090909       11
#> 25   Noah Smith Olivia Johnson 0.22222222        9
#> 26  Mia Johnson   Liam Johnson 0.33333333        9
#> 27  Mia Johnson Olivia Johnson 0.37500000        8
#> 28 Liam Johnson Olivia Johnson 0.62500000        8
```
