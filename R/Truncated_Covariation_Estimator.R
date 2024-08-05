#' @title Truncated covariation estimator
#' @description xyz
#' @param x xyz
#' @param tq xyz
#' @param l xyz
#'
#' @return xyz
#' @export
Truncated.Covariation.estimator <- function(x,# discount curve data x[i,j]=p_{i\Delta}(j\Delta)
                                           tq = 0.75, ## the quantile at which
                                           #################the data are truncated for the preliminary
                                           #################covariation estimate. The estimator is then
                                           #################rescaled such that the first eigenvalue of
                                           ################# the preliminary estimator corresponds to
                                           ################# correspond to the interquartile estimate
                                           l = 3,###truncation level for the automatic truncation
                                           sumplot = TRUE # when a summary plot should be made
){
  n= nrow(x) #number of days in which discount curves are considered
  m= ncol(x) #number of days in the maturity direction

  log.prices<-log(x)
 adjusted.increments<-matrix(0,n-1,m-2)  #adjusted increment= log(x[i+1, j])-log(x[i, j+1])-log(x[i+1, j-1])+log(x[i, j])

  for(i in 1:(n-1)){
    adjusted.increments[i,1:(m-2)]<-diff(log.prices[(i+1),1:(m-1)])-diff(log.prices[i,2:m])
  }

  ######Now conduct the truncation procedure
  #Start with the preliminary estimator for the quadratic variation


{  rough.locs<-quantile.truncation(adjusted.increments,tq)
  C.Prel<-Variation(adjusted.increments[-rough.locs,])


  EG<-eigen(C.Prel)
  EG.rough.vectors<-EG$vectors

  VALUES<-numeric(n-1)# loadings of the first eigenvalue
    for (i in 1:(n-1)) {
      VALUES[i]<-t(EG$vectors[,1])%*%adjusted.increments[i,]
    }
    q.75<-as.numeric(quantile(VALUES,0.75))
    q.25<-as.numeric(quantile(VALUES,0.25))
    rho.star<-((q.75-q.25)^2)/((4*(qnorm(0.75)^2)*EG$values[1])/n)#interquartile range estimator for variance of first eigenvector loadings

    C.Prel<-rho.star*C.Prel
}#calculates the preliminary estimator for the realized covariation

    locs<-Functional.data.truncation(d = d.star(C=C.Prel,tq),C= C.Prel, data =   adjusted.increments, Delta = 1/n,  sd =l)$locations


  if(length(locs) == 0){
    Truncated.variation<-Variation(adjusted.increments)/(n^2)
  }
  if(length(locs) != 0){
    Truncated.variation<-Variation(adjusted.increments[-locs,])/(n^2)
  }



    if(sumplot == TRUE){
      ##for the dimensionality analysis
      loads<-numeric(ncol(Truncated.variation))
      EG2<-eigen(Truncated.variation)
      for (i in 1:ncol(Truncated.variation)) {
        loads[i]<-sum(EG2$values[1:i])
      }
      expl.var<-loads/sum(EG2$values)
      par(mfrow = c(1, 2))
      persp(Truncated.variation,xlab= "Time to maturity (years)")
      plot(expl.var[1:10], type = "p")
    }
  return(list("IV" = Truncated.variation, "locs" = locs, "C.Prel" =C.Prel, "adj.increments" = adjusted.increments))
}

