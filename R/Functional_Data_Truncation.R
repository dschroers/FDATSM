#' @title Functional Data Truncation
#' @description This function calculates the truncation function for each datum and then determines truncation locations
#' @param d Number of inverted eigenvalues
#' @param C Statistical covariance matrix
#' @param data Data matrix (rows = time)
#' @param Delta Increment size
#' @param sd Number of standard deviations truncated
#'
#' @return List containing the truncation function values and truncation locations
#' @export
#'
#' @examples
Functional.data.truncation<-function(d, ### number of inverted eigenvalues
                                     C, ### stat. covariance matrix
                                     data, ### data matrix (rows = time)
                                     Delta, ###increment size
                                     sd ### number of 'standard deviations' truncated
){
  #####First calculate for each datum the truncation function gn
  E<-eigen(C)
  n=nrow(data)
  gn<-numeric(n)
  for (i in (1:n)) {
    for (j in 1:d) {
      gn[i]<-gn[i]+((data[i,]%*%E$vectors[,j])^2/(E$values[j]))###first part of g_n
    }
    second.part.gn.scores<-0
    for (j in ((d+1):length(E$values))) {
      second.part.gn.scores<-second.part.gn.scores+(data[i,]%*%E$vectors[,j])^2
    }
    second.part.gn.scores<-second.part.gn.scores/sum(E$values[(d+1):length(E$values)])###second part of the scores

    gn[i]<-gn[i]+second.part.gn.scores

    gn[i]<-sqrt(gn[i])
  }
  ## now create Boolean vector for checking if truncation happens
  truncation.locations<-which(gn > (sd*sqrt(d+1)*Delta^(0.49)))
  return(list("gn" = gn , "locations" = truncation.locations))
}###fine truncation locations


L2.norm<-function(v, from =0, to = 1){
  (norm(v, type = "2")*(to-from))/sqrt(length((v)))
}##calculates the L^2 norm
## of a piecewise constant covariance operator on L^2([from,to])
L2.HS.norm<-function(M, from =0, to = 1){
  (hilbert.schmidt.norm(M)*(to-from))/nrow(M)}##calculates the Hilbert Schmidt norm
## of a piecewise constant covariance operator on L^2([from,to])
