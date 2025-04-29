#' @title Interpolate Discount Curve
#' @description Interpolates a discount curve to daily resolution using natural splines.
#' A value of 1 at time 0 is enforced for consistency with discount factor properties.
#'
#' @param maturities Numeric vector of observed maturities (e.g., in days or years).
#' @param prices Numeric vector of observed discount prices corresponding to the maturities.
#' @param day_grid Numeric vector representing the time grid to evaluate the interpolated curve on (e.g., 1:3650 for 10 years).
#'
#' @return A numeric vector of interpolated discount prices evaluated at \code{day_grid}.
#'
#' @examples
#' maturities <- c(1, 2, 3, 5, 7, 10, 15, 20, 30)
#' prices <- c(0.99, 0.975, 0.958, 0.93, 0.905, 0.88, 0.85, 0.83, 0.80)
#' day_grid <- seq(0, 30, length.out = 300)  # extrapolation at 0
#' curve <- interpolate_curve(maturities = maturities, prices = prices, day_grid = day_grid)
#' plot(x = day_grid, y = curve, type = "l", main = "Interpolated Discount Curve")
#'
#' @export
interpolate_curve <- function(maturities, prices, day_grid) {
  spline_result <- spline(
    x = c(0, maturities),
    y = c(1, prices),
    xout = day_grid,
    method = "natural"
  )
  return(spline_result$y)
}
