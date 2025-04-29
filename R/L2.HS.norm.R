#' @title L2 Hilbert–Schmidt Norm
#' @description Computes the \eqn{L^2([from,to]^2)}-norm of a discretized kernel matrix.
#' Assumes that the kernel is defined over a square grid of equally spaced points.
#'
#' @param M Numeric matrix representing the discretized kernel.
#' @param from Start of the interval (default is 0).
#' @param to End of the interval (default is 1).
#'
#' @return Numeric value of the approximated \eqn{L^2([from,to]^2)} norm.
#'
#' @importFrom matrixcalc hilbert.schmidt.norm
#' @export
#'
#' @examples
#' kernel <- outer(seq(0, 1, length.out = 100), seq(0, 1, length.out = 100),
#'                 function(s, t) exp(-abs(s - t)))
#' L2_HS_norm(kernel)


L2_HS_norm <- function(M, from = 0, to = 1) {
  delta <- (to - from) / nrow(M)
  hilbert.schmidt.norm(M)* delta
}

