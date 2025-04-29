# Internal helper function
# Identifies multivariate data points whose Euclidean norms exceed a specified
# quantile threshold. This can be used for norm-based outlier detection or filtering.
#
# Parameters:
#   data - A numeric matrix or data frame. Each row is an observation, columns are features.
#   q    - A numeric value in (0, 1). Observations with norms ≥ q-th quantile are flagged.
#
# Returns:
#   An integer vector of indices corresponding to rows in `data` to be truncated.


quantile_truncation<-function(data,q){
  # Input checks
  if (!is.data.frame(data) && !is.matrix(data)) {
    stop("`data` must be a matrix or data frame.")
  }

  if (!all(sapply(data, is.numeric))) {
    stop("All columns in `data` must be numeric.")
  }

  if (!is.numeric(q) || length(q) != 1 || q <= 0 || q >= 1) {
    stop("`q` must be a single numeric value strictly between 0 and 1.")
  }

  if (anyNA(data)) {
    warning("Missing values detected; rows with NA values will be removed.")
    data <- data[complete.cases(data), , drop = FALSE]
  }


  # Compute Euclidean norm for each row
  norms.data <- apply(data, 1, function(row) sqrt(sum(row^2)))

  # Determine quantile threshold
  quant<- quantile(norms.data, probs = q)

  # Identify indices of points exceeding the threshold
  truncation.locations<-which(norms.data>=quant)
  return(truncation.locations)
}
