#' @title Gaussian.cov
#' @description Calculates a discretized Gaussian kernel, where discretization is by local averaging over the grid-cell values
#' @param alpha Dimensionality Parameter
#' @param M Number of simulated maturity grid points
#'@param n Number of Days
#' @return Number d of factors needed to explain rho percent of the variation
#' @export
Gaussian.cov<-function(alpha,M,n){
  q<-matrix(0, M+n,M+n)
  for (i in 1:(M+n)) {
    for (j in 1:i) {
      q[i,j]<-integral.Gaussian.kernel(i,j, alpha = alpha, Delta= 1/M)
      q[j,i]<- q[i,j]
    }
  }##Calculate the local averaged fractional kernel
  return(q)
}
