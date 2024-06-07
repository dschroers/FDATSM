
L2.norm<-function(v, from =0, to = 1){
  (norm(v, type = "2")*(to-from))/sqrt(length((v)))
}

