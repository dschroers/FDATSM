#' @title Exponential.cov
#' @description Calculates a discretized product kernel of two exponentials, where discretization is by local averaging over the grid-cell values
#' @param M Number of simulated maturity grid points
#'@param n Number of Days
#' @export
Exponential.cov<-function(alpha,M,n){
  q<-matrix(0, M+n,M+n)
  for (i in 1:(M+n)) {
    for (j in 1:i) {
      q[i,j]<-integral.Exponential.kernel(i,j, Delta= 1/M)
      q[j,i]<- q[i,j]
    }
  }##Calculate the local averaged fractional kernel
  return(q)
}
