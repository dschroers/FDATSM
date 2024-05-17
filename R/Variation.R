#' @title Calculator of the semigroup-adjusted realized covariation (SARCV)
#' @description This function takes the increments and calculates the SARCV
#' @param Incr Increments in form of a numeric matrix
#'
#' @return SARCV as a symmetric matrix
#' @export
#'
#' @examples
Variation <- function(Incr){
  n<- nrow(Incr)
  m<-ncol(Incr)
  sqIncr<-array(data = Incr, dim = c(n,m,m))
  for (i in 1:n) {
    sqIncr[i,,]<-Incr[i,]%*%t(Incr[i,])
  }
  rcv<-matrix(0,m,m)
  for (i in 1:m) {
    for (j in 1:i) {
      rcv[i,j]<-sum(sqIncr[,i,j])
    }
  }
  for (i in 1:m-1) {
    for (j in (i+1):m) {
      rcv[i,j]<- rcv[j,i]
    }
  }
  return(rcv)
}###
