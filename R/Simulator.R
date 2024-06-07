#' @title Simulator
#' @description Simulates from a forward curve model
#' @param M Number of simulated maturity grid points
#'@param n Number of Days
#' @export

#library(MASS)

Simulator<-function(n=100, # number of time points
                    M =100, # Number of spatial grid points
                    lambda=5,##Jump intensity
                    rho=50,## Jump size
                    q,##Jump intensity, second jumps process
                    k, #jump kernel
                    f0 =numeric(n), #initial forward curve
                    jump.summary.plot = TRUE # if Plot should be provided
){
  {kernel.samples<-mvrnorm(n = n, numeric(M+n), q, tol = 1e-3)
    samples<-matrix(0,n,(M+n))
    samples[1,]<-f0
    for (i in 2:n) {
      samples[i,1:(M+n-i)]<-samples[i-1,2:(M+1+n-i)]
      samples[i,]<-samples[i,]+kernel.samples[i,]
      #print(i)
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
        Chi[i,]<-as.numeric(mvrnorm(n = 1, numeric(M+n), rho*k, tol = 1e-3))
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



    # normalljumps<-numeric(n)
    #for(i in 1: n){normalljumps[i]<-L2.norm(jump.samples[i,], from = 0, to = 10)}
    #plot(normalljumps)
  }##simulate the jump part

  cont.data<- samples[,1:(M+1)]
  data<- samples[,1:(M+1)]+CPP[,1:(M+1)]

  IV<-q[1:M,1:M]


  if(jump.summary.plot == TRUE){
    norms<-numeric(n)
    for (i in 1:n) {
      norms[i]<-L2.norm(data[i,])
      norms.cont[i]<-L2.norm(cont.data[i,])
    }
    plot(x=1:100/100,y=norms, type = "l", ylim=range(norms,norms.cont), lwd =2)
    lines(x=1:100/100,y=norms.cont, type = "l", col = "darkgreen", lwd =2)
    points(x=jump.locations/100, norms[jump.locations], col = "blue", pch = 4,, lwd =2)
    legend("topleft",c("norms","norms (no jumps)", "jumps"),col=c("black","darkgreen", "blue"), pch=c(1,1,4))
    }

  return(list("f.C"=cont.data, "f" = data,  "jump.locs" = jump.locations,"IV"= IV ))
}


SIM<-Simulator(100,100, q= q, k=k)

