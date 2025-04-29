#' @title L2 Norm of a Discretized Function
#' @description Computes the \eqn{L^2([from, to])}-norm of a discretized function (vector).
#' Assumes the function is evaluated at equally spaced grid points over the interval \code{[from, to]}.
#'
#' @param v Numeric vector representing values of a discretized function.
#' @param from Start of the interval (default is 0).
#' @param to End of the interval (default is 1).
#'
#' @return Numeric value of the approximated \eqn{L^2([from, to])} norm.
#'
#' @export
#'
#' @examples
#' x <- seq(0, 1, length.out = 100)
#' f <- sin(pi * x)
#' L2_norm(f)

L2_norm <- function(v, from = 0, to = 1) {
  n <- length(v)
  delta <- (to - from) / n
  sqrt(sum(v^2) * delta)
}
