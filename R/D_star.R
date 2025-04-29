# Internal helper function
# Computes the number of principal components (factors) needed to explain
# a specified percentage of total variance from a covariance matrix.
#
# Parameters:
#   C   - A covariance matrix (assumed to be symmetric and square)
#   rho - Proportion of variance to be explained (between 0 and 1)
#
# Returns:
#   The minimum number of components (d) needed to explain at least rho of the total variance.

d_star<-function(C,rho =.9){
  eigvals <- eigen(C, only.values = TRUE)$values
  scores <- cumsum(eigvals) / sum(eigvals)
  return(min(which(scores >= rho)))
}
