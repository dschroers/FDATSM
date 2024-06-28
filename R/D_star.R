#' @title D-star
#' @description This function determines the number d of factors needed to explain percentage rho of the variation induced by covariance matrix C
#' @param C Covariance matrix
#' @param rho Percentage of variation to be explained
#'
#' @return Number d of factors needed to explain rho percent of the variation
#' @export

d.star<-function(C,rho){
  len<-length(eigen(C)$values)
  scores<-numeric(len)
  scores
  for (i in 1:len) {
    scores[i]<-sum(eigen(C)$values[1:i])
  }
  scores<-scores/sum(eigen(C)$values)

  return(min(which(scores>=rho)))
}# function chooses d such that d
#factors explain rho percent of the variation induced by C
