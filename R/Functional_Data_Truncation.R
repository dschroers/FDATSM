# Internal helper function
# Computes a truncation function for each functional datum and determines
# the truncation locations based on a thresholding rule.
#
# Parameters:
#   d     - Number of inverted eigenvalues (components) used
#   C     - Covariance matrix
#   data  - Data matrix (rows represent time points, columns = observations)
#   Delta - Increment size
#   sd    - Number of standard deviations used for truncation threshold
#
# Returns:
#   A list with:
#     - 'gn': vector of truncation function values
#     - 'locations': indices or positions where truncation occurs

functional_data_truncation<-function(d, ### number of inverted eigenvalues
                                     C, ### stat. covariance matrix
                                     data, ### data matrix (rows = time)
                                     Delta, ###increment size
                                     sd ### number of 'standard deviations' truncated
){
  E<-eigen(C)

  # Input validation
  if ((d + 1) > length(E$values)) {
    stop("Error: The number of eigenvalues 'd' should be at most min(100, ncol(C)).")
  }

  n<-nrow(data)

  #Calculate the values of the truncation function
  gn<-numeric(n)
  for (i in 1:n) {
    x <- data[i, ]

    # First part of g_n (sum of first 'd' components)
    g1 <- sum((x %*% E$vectors[, 1:d])^2 / E$values[1:d])

    # Second part of g_n (remaining components, if any)
      idx <- seq(d + 1, length(E$values))
      g2_num <- sum((x %*% E$vectors[, idx])^2)
      g2_den <- sum(E$values[idx])
      g2 <- g2_num / g2_den

      #take the squareroot of their sum
    gn[i] <- sqrt(g1 + g2)
  }

  #Identify truncation locations
  truncation.locations<-which(gn > (sd*sqrt(d+1)*Delta^(0.49)))
  return(list("gn" = gn , "locations" = truncation.locations))
}
