#' @title Calculator of integral with Gaussian kernel
#' @description This function calculates the integral of a Gaussian kernel function over a specified interval
#' @param i Index for first interval
#' @param j Index for second interval
#' @param Delta Length of each interval
#' @return Integral value
#' @export
integral.Exponential.kernel<- function(i,j,Delta = 1/M){# Calculates < Q_2 1_{[(j-1)Delta,jDelta],1_{[(j-1)Delta,jDelta]>}
  fun <- function(x,y){
    exp(-x)*exp(-y)
  }
  integral2(fun, (i-1)*Delta, i*Delta,  (j-1)*Delta, j*Delta, reltol = 1e-10)$Q
}

