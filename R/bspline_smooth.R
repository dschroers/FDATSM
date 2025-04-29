# Internal helper function
# Applies B-spline smoothing to a matrix of adjusted increments using a cubic spline basis.
#
# Parameters:
#   adj_increments - A matrix where each row contains a time series of daily adjusted increments
#                    to be smoothed (rows = samples, columns = time points).
#
# Returns:
#   A list containing:
#     coeffs      - Matrix of fitted spline coefficients (one row per sample).
#     B_centers   - Spline basis matrix evaluated at the midpoint (center) grid used for fitting.
#     B_grid      - Spline basis matrix evaluated at the full x_grid for reconstruction.
#     x_grid      - Sequence of time points corresponding to the original increments.
#     x_centers   - Midpoints between time steps used for fitting the spline basis.

bspline_smooth <- function(adj_increments) {
  m=ncol(adj_increments)+2
  x_grid <- seq(1/365, m / 365, length.out = m - 1)
  x_centers <- (x_grid[-1] + x_grid[-length(x_grid)]) / 2

  n_knots <- min(50, m - 2)

  # Define boundaries explicitly to avoid extrapolation issues
  boundary_knots <- range(x_grid)

  # Construct spline basis at x_centers
  B_centers <- bs(x_centers, df = n_knots, degree = 3, intercept = TRUE,
                  Boundary.knots = boundary_knots)
  B_centers_mat <- as.matrix(B_centers)

  # Fit coefficients
  coeffs <- t(apply(adj_increments, 1, function(row) lm.fit(B_centers_mat, row)$coefficients))

  # Evaluate the same basis at x_grid for reconstruction
  B_grid <- as.matrix(predict(B_centers, x_grid))

  return(list(coeffs = coeffs, B_centers = B_centers_mat, B_grid = B_grid, x_grid = x_grid, x_centers = x_centers))
}
