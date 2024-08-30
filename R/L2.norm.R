#' @title L2.norm
#' @description This function computes the L2 norm of a vector v over a specified range
#' @param v Input vector to compute L2 norm
#' @param from Start of the range
#' @param to End of the range
#'
#' @return Scaled L2 norm of v
#' @export

L2.norm<-function(v, from =0, to = 1){
  (norm(v, type = "2")*(to-from))/sqrt(length((v)))
}

