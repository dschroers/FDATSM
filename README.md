
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FDATSM

<!-- badges: start -->

The R package `FDATSM` enables quantitative analysis of covariations of
difference returns as described in the articles [**Robust Functional
Data Analysis for Stochastic Evolution Equations in Infinite
Dimensions**](https://arxiv.org/pdf/2401.16286) by [Dennis
Schroers](https://github.com/dschroers). The data inputs should be yield
or discount data over over a prespecified time span (e.g. a quarter, a
year, a decade) and an upper limit on the time to maturity (e.g. 5
years, 10 years, 30 years). The resolution of the data in time and time
to maturity should coincide (e.g. if data are available daily, the
corresponding yields or zero-coupon bond prices must be available in a
daily resolution in the maturity dimension). For the important case of
daily data, this necessitates smoothed discound or yield curves. In the
example presented below, we use data from … and … .  
The estimated covariations of difference returns correspond to rescaled
empirical covariances of difference returns and are provided in matrix
format. A jump truncation method is also available, corresponding to an
outlier robust estimator for the covariations.

<!-- badges: end -->

## Installation

You can install the development version of FDATSM from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dschroers/FDASPDE")
```

## Simple Example with Simulated Data

This is a basic example which shows you how to solve a common problem:

``` r
library(FDATSM)
## basic example code
```

The subsequent code generates samples difference returns in resolution
$n\times n$ (time and time to maturity) generated from instantaneous
forward curve model $$df_t = \partial_x f_t dt+ dX_t$$ where
$$X_t= at +  W_t^Q+ J_t$$ where …

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
