#' @title L2.HS.norm
#' @description xyz
#' @param M xyz
#' @param from xyz
#' @param to xyz
#'
#' @return xyz
#' @export

L2.HS.norm<-function(M, from =0, to = 1){
  (hilbert.schmidt.norm(M)*(to-from))/nrow(M)}
