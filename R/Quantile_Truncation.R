#' @title Preliminary truncation location
#' @description This function calculates the norm of each data point, computes the quantiles
#' of the distribution of the norms and then identifies the location of data points
#' whose norm exceeds the quantile value and should be truncated
#' @param data Data matrix
#' @param q The quantile values
#'
#' @return Vector containing the index of data points to be truncated
#' @export

quantile.truncation<-function(data,q){
  norms.data<-numeric(nrow(data))
  for (i in 1:nrow(data)) {
    norms.data[i]<-norm(data[i,], type = "2")
  }
  quant<- quantile(norms.data, probs = q)
  # truncated.data<-data[norms.data<=quant,]
  truncation.locations<-which(norms.data>=quant)
  return(truncation.locations)
}###Rough preliminary truncation locations
