

#'Simulator
#'
#' @description Simulates from a forward curve model \eqn{df_t= \partial_x f_t + dW_t^Q+dJ_t}, where \eqn{Q} is an integral kernel operator with kernel q and \eqn{J} is a compound Poisson process with intensity lambda and centered gaussian jump distribution with covariance kernel k
#' @param n Number of simulated days
#' @param q cross-sectional covariance kernel of the continuous driver (if 1 year of data should be simulated with m maturity days, the covariance needs to be of dimension m+n, due to simulating the shift at the boundary)
#' @param lambda jump intensity
#' @param rho jump magnitude
#' @param k cross-sectional covariance kernel of the jumps (if 1 year of data should be simulated with m maturity days, the covariance needs to be of dimension m+n, due to simulating the shift at the boundary)
#' @param f0 initial forward curve
#' @examples
#' q<-Gaussian.cov(alpha=10,Delta=0.01, Years=2)
#' @importFrom MASS mvrnorm
#' @export

Simulator<-function(n=100, # number of time points
                    lambda=3,##Jump intensity
                    rho=1,## Jump size
                    q,##Jump intensity, second jumps process
                    k, #jump kernel
                    f0 =numeric(201)#initial forward curve
){
  {
    M=nrow(q)-n #Number of simulated spatial grid points
    kernel.samples<-mvrnorm(n = n, numeric(nrow(q)), q, tol = 1e-3)/sqrt(365) #/sqrt(365) to account for the temporal size of the increment
    samples<-matrix(0,n,(M+n))
    samples[1,]<-numeric(n+M)
    for (i in 2:n) {
      samples[i,1:(M+n-i)]<-samples[i-1,2:(M+1+n-i)]
      samples[i,]<-samples[i,]+kernel.samples[i,]
    }
  }#simulate continuous part
  {Int.Arr.times<-rexp(n=100,rate=lambda)
    Arr.times<-numeric(100)
    for (i in 1:100) {
      Arr.times[i]<-sum(Int.Arr.times[1:i])
    }
    Arr.times<-Arr.times[which(Arr.times<1)]



    jump.locations<-trunc(Arr.times*n)

    Jump.number<- length(Arr.times)



    ###Now the nonstationary part
    CPP<-matrix(0,n,M+n)
    if(length(Arr.times)>0){
      Chi<-matrix(0,length(Arr.times),(M+n))
      for (i in 1:length(Arr.times)) {
        Chi[i,]<-as.numeric(mvrnorm(n = 1, numeric(ncol(k)), rho*k, tol = 1e-3))
      }


      if(jump.locations[1]==1){
        CPP[1,]<-Chi[1,]
      }
      for (i in 2:n) {
        CPP[i,]<-CPP[i-1,]
        if(is.element(i,jump.locations)){
          for (j in which(i==jump.locations)) {
            CPP[i,]<- CPP[i,]+exp(-(((jump.locations[j]+1)/n)-Arr.times[j]))*Chi[j,]
          }
        }
      }
    }

    #normsjumps2<-numeric(n)
    #for(i in 1: n){normsjumps2[i]<-L2.norm(CPP.2[i,], from = 0, to = 10)}
    #plot(normsjumps2)

    ###Compute the jumps variations and the jump data



    #normalljumps<-numeric(n)
    #for(i in 1: n){normalljumps[i]<-L2.norm(jump.samples[i,], from = 0, to = 10)}
    #plot(normalljumps)
  }##simulate the jump part
  {f0ev<-matrix(0,n,(M+1))
    for (i in 1:n) {
      f0ev[i,]<-f0[i:(i+M)]
    }
  }#Evolution of the initial condition

  cont.data<- f0ev+samples[,1:(M+1)]
  data<-f0ev+ samples[,1:(M+1)]+CPP[,1:(M+1)]


  #Now transform from difference return data to bond price data
  Cont.Price.Data<-matrix(0,n,(M+1))
  Price.Data<-matrix(0,n,(M+1))
  for (i in 1:n) {
    for (j in 1:(M+1)) {

      Cont.Price.Data[i,j]<- exp(-sum(cont.data[i,1:j]))
      Price.Data[i,j]<- exp(-sum(data[i,1:j]))

    }
  }

  IV<-q[1:M,1:M]

  return(list("Cont.Prices"=Cont.Price.Data, "Prices"= Price.Data, "f.C"=cont.data, "f" = data,  "jump.locs" = jump.locations,"IV"= IV ))
}





#' Exponential.cov
#'
#' @description Calculates discretized product kernel of two exponentials \eqn{k(x,y)\propto e^{-(x+y)}} (normalized to have trace =1 ), where discretization is by local averaging over the grid-cell values
#' @param Delta Resolution in the maturity direction
#' @param Years Dimension of the covariance
#' @return Discretized (in resolution Delta) covariance kernel in L^2(0,(Years/Delta)^2)
#' @importFrom pracma integral2

#' @export
Exponential.cov<-function(Years=1){
  Delta= 1/365
  M= Years*365
  q<-matrix(0, M,M)

  integral.Exponential.kernel<- function(i,j){# Calculates < Q_2 1_{[(j-1)Delta,jDelta],1_{[(j-1)Delta,jDelta]>}
    fun <- function(x,y){
      exp(-x)*exp(-y)/((1-exp(-2))/2)
    }
    pracma::integral2(fun, (i-1)*Delta, i*Delta,  (j-1)*Delta, j*Delta, reltol = 1e-10)$Q
  }

  for (i in 1:M) {
    for (j in 1:i) {
      q[i,j]<-integral.Exponential.kernel(i,j)
      q[j,i]<- q[i,j]
    }
  }##Calculate the local averaged fractional kernel
  return(q)
}


#' Gaussian.cov
#'
#' @description Calculates a discretized Gaussian kernel \eqn{k(x,y)=e^{-alpha (x-y)^2}}, where discretization is by local averaging over the grid-cell values
#' @param alpha parameter of the gaussian covariance
#' @param Delta Resolution in the maturity direction
#' @param Years Dimension of the covariance
#' @return Discretized (with resolution Delta) covariance kernel in L^2(0,(days/Delta)^2)
#' @importFrom pracma integral2

#' @export

Gaussian.cov<-function(alpha,Years){
  Delta=1/365
  M=Years*365
  q<-matrix(0, M,M)

  integral.Gauss.kernel<- function(i,j,alpha = 0.1){# Calculates < Q_2 1_{[(j-1)Delta,jDelta],1_{[(j-1)Delta,jDelta]>}
    fun <- function(x,y){
      exp(-alpha*(x-y)^{2})
    }
    integral2(fun, (i-1)*Delta, i*Delta,  (j-1)*Delta, j*Delta, reltol = 1e-10)$Q
  }#this function calculates the local averages of the Gaussian kernel
  for (i in 1:M) {
    for (j in 1:i) {
      q[i,j]<-integral.Gauss.kernel(i,j, alpha = alpha)
      q[j,i]<- q[i,j]
    }
  }##Calculate the local averaged fractional kernel
  return(q)
}
