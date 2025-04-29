# Internal helper function
# Computes a preliminary estimate of the covariation matrix after removing norm-outliers
# and scaling based on robust projections onto the first principal component.
#
# Parameters:
#   data - A numeric matrix of observations (rows = time points, columns = variables).
#   tq   - Truncation quantile for outlier removal (used in quantile_truncation).
#
# Returns:
#   C.Prel - A preliminary covariation matrix with outliers removed and rescaled by
#            a robust estimate of the explained variance along the leading eigenvector.

preliminary_covariation_estimator <- function(data, tq) {
  n= nrow(data)
  rough.locs <- quantile_truncation(data, tq)
  C.Prel <- variation(data[-rough.locs, ,drop = FALSE])
  EG <- eigen(C.Prel)

  values <- sapply(1:(n - 1), function(i) t(EG$vectors[, 1]) %*% data[i, ])
  q.75 <- quantile(values, 0.75)
  q.25 <- quantile(values, 0.25)

  rho.star <- ((q.75 - q.25)^2) / ((4 * (qnorm(0.75)^2) * EG$values[1]) / n)
  C.Prel <- rho.star * C.Prel

  return(C.Prel = C.Prel)
}
