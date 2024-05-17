

# FDATSM
Functional Data Analysis for Covariations in Term Structure Models



The R package `FDATSM` enables quantitative analysis of quadratic covariations of difference returns as described in the articles [**Robust Functional Data Analysis for Stochastic Evolution Equations in Infinite Dimensions**](https://arxiv.org/pdf/2401.16286) by [Dennis Schroers](https://github.com/dschroers). The data inputs should be yield or discount data over over a prespecified time span (e.g. a quarter, a year, a decade) and an upper limit on the time to maturity (e.g. 5 years, 10 years, 30 years). The resolution of the data in time and time-to-maturity should coincide (e.g. if data are available daily, the corresponding yields or zero-coupon bond prices must be available in a daily resolution in the maturity dimension). For the important case of daily data, this necessitates smoothed discound or yield curves. In the example presented below, we use data from ... and ... .  
The estimated covariations of difference returns correspond to rescaled empirical covariances of difference returns and are provided in matrix format. A jump truncation method is also available, corresponding to an outlier robust estimator for the covariations.



