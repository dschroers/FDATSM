#' @title L2.HS.norm
#' @description This function computes the L2 Hilbert-Schmidt norm of a matrix M over a specified range
#' @param M Input matrix to compute the Hilbert-Schmidt norm
#' @param from Start of the range
#' @param to End of the range
#'
#' @return Scaled L2 Hilbert-Schmidt norm of M
#' @export

L2.HS.norm<-function(M, from =0, to = 1){
  (hilbert.schmidt.norm(M)*(to-from))/nrow(M)}
