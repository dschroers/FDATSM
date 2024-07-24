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



c<-matrix(0,100,100)
q<-matrix(1,100,100)
rc<-matrix(0,100,100)
for (i in 1:100) {
  for (j in 1:100) {
    q[i,j]=1-(i*j/1000000)
    c[i,j]=(1-(max(i,j)/100))
    rc[i,j]=min(i,j)/100
  }
}
persp(c, xlab="", ylab= "", zlim = c(0,1), theta = 180, phi = 28)
persp(rc, xlab="", ylab= "", zlim = c(0,1), theta = 180, phi = 28)
persp(z=q, xlab="", ylab= "", zlim = c(0,1), theta = 120, phi = 28)
?persp
