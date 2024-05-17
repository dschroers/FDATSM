#' @title Truncated covariation estimator
#' @description
#' @param adjusted.increments
#' @param Threshhold.manually
#' @param quantile.adjustment
#' @param truncation
#' @param Prelim.truncation.quantile
#' @param l
#'
#' @return
#' @export
Truncated.Covariation.estimator<- function(adjusted.increments,# list containing the sampled adjusted increments.
                                           Threshhold.manually = FALSE,  ### if an truncation level should be
                                           #################inducednmanually. If FALSE, the
                                           ################# automated threshholding technique
                                           ################ is employed
                                           quantile.adjustment = TRUE,
                                           truncation = "sparse",
                                           Prelim.truncation.quantile = 0.75, ## the quantile at which
                                           #################the data are truncated for the preliminary
                                           #################covariation estimate. The estimator is then
                                           #################rescaled such that the first eigenvalue of
                                           ################# the preliminary estimator corresponds to
                                           ################# correspond to the interquartile estimate
                                           l = 3###truncation level for the automatic truncation
){
  n= nrow(adjusted.increments)
  dimension.of.estimator = ncol(adjusted.increments)
  ######Now conduct the truncation procedure
  rough.locs<-quantile.truncation(adjusted.increments,Prelim.truncation.quantile)
  CRough<-Variation(adjusted.increments[-rough.locs,])
  #m.rough<-colMeans(adjusted.increments[-rough.locs,])
  #CRough<-ncol(adjusted.increments[-rough.locs,])*(cov(adjusted.increments[-rough.locs,])+(m.rough)%*%t(m.rough))


  EG<-eigen(CRough)
  EG.rough.vectors<-EG$vectors
  EG.rough.values<-EG$values

  if(quantile.adjustment == TRUE){
    VALUES<-numeric(n)
    for (i in 1:n) {
      VALUES[i]<-t(EG.rough.vectors[,1])%*%adjusted.increments[i,]
    }
    #(q.75-q.25)^2/(4 Φ−1(0.75)^2)=σ^2
    q.75<-as.numeric(quantile(VALUES,0.75))
    q.25<-as.numeric(quantile(VALUES,0.25))
    rho.star<-((q.75-q.25)^2)/((4*(qnorm(0.75)^2)*EG.rough.values[1])/n)
    #var(VALUES[-rough.locs])

    CRough<-rho.star*CRough
  }

  if(truncation == "sparse"){
    locs<-Functional.data.truncation(d = d.star(C=CRough[grid,grid],Prelim.truncation.quantile),C= CRough, data =   adjusted.increments, Delta = 1/n,  sd =l)$locations
  }
  if(truncation != "sparse"){
    locs<-Functional.data.truncation(d = d.star(C=CRough,Prelim.truncation.quantile),C= CRough, data =   adjusted.increments, Delta = 1/n,  sd =l)$locations
  }


  if(length(locs) == 0){
    #m.locs<-colMeans(adjusted.increments[,])
    #Truncated.variation<-ncol(adjusted.increments[,])*(cov(adjusted.increments[,])+(m.locs)%*%t(m.locs))

    Truncated.variation<-Variation(adjusted.increments)
  }
  if(length(locs) != 0){
    #m.locs<-colMeans(adjusted.increments[-locs,])
    # Truncated.variation<-ncol(adjusted.increments[-locs,])*(cov(adjusted.increments[-locs,])+(m.locs)%*%t(m.locs))

    Truncated.variation<-Variation(adjusted.increments[-locs,])
  }
  return(list("IV" = Truncated.variation, "locs" = locs, "Crough" =CRough, "adj.increments" = adjusted.increments))
}

