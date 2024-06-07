
L2.HS.norm<-function(M, from =0, to = 1){
  (hilbert.schmidt.norm(M)*(to-from))/nrow(M)}
