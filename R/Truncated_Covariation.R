#' @title Truncated Covariation Estimator
#' @description Computes the (jump-truncated) realized covariation of difference returns \eqn{d_i^n(j) :=  \log(P_{i+1,j}^n)- \log(P_{i,j+1}^n)- \log(P_{i+1,j-1}^n)+ \log(P_{i,j}^n)} from a matrix of daily bond price data \eqn{P_{i,j)}}
#' @param x Matrix of bond prices where x[i,j] is the bond price at the i-th time and j-th maturity (in days).
#' @param tq Quantile for truncation in preliminary covariation estimate used for jump truncation.
#' @param l Truncation level for functional data truncation (e.g. l=2,3,4,5).
#' @param sparse if TRUE, apply B-spline smoothing for high-dimensional maturity data.
#' @param sumplot If TRUE, produces summary plots of the results.
#' @return A list with:
#'   \item{IV}{Truncated covariation matrix}
#'   \item{locs}{Locations of Detected jumps in the data}
#'   \item{C.Prel}{Preliminary covariation estimator}
#'   \item{adj.increments}{Adjusted log-increments}
#'   \item{expl.var}{Explained variance of eigenvalues}
#'   \item{gn}{Truncation noise curve}
#'
#'
#' @references
#'  Schroers, D. (2024+). Dynamically Consistent Analysis of Realized Covariations in Term Structure Models.
#'
#' @importFrom splines bs
#' @export
truncated_covariation <- function(x, tq = 0.75, l = 3, sparse = TRUE, sumplot = FALSE) {


  # --- Validate and process input ---
  if (!is.data.frame(x)) stop("Input 'x' must be a data frame.")
  if (!inherits(x[[1]], "Date")) {
    tryCatch({
      x[[1]] <- as.Date(x[[1]])
    }, error = function(e) {
      stop("First column must contain Date objects or be convertible to Date.")
    })
  }



#remove dates and convert to log prices
   x.mat <- as.matrix(x)
  dates <- x.mat[, 1]
  x.mat <- matrix(as.numeric(x.mat[, -1]), nrow = nrow(x.mat))
  colnames(x.mat) <- NULL


  n <- nrow(x.mat)
  m <- ncol(x.mat)
  log.prices <- log(x.mat)


  #compute the differences between consecutive trading days
  day_diffs <- as.numeric(diff(as.Date(dates)))


#Compute difference returns(=adjusted increments)
  diff_ret <- matrix(0, n - 1, (m - max(day_diffs)-1))

  for (i in 1:(n - 1)) {
    lag<-day_diffs[i]
    diff_ret[i, ] <- (diff(log.prices[i + 1, 1:(m - lag)]) - diff(log.prices[i, (1+lag):m]))[1: (m - max(day_diffs)-1)]
  }

              # Optional B-spline smoothing for large m
  if (sparse) {
    bspline_result <- bspline_smooth(diff_ret)
    diff_ret_data <- bspline_result$coeffs
    B <- bspline_result$B_grid
    x_grid = bspline_result$x_grid
  } else {
    diff_ret_data <- diff_ret
    B <- NULL
  }


  # Compute preliminary estimator of the covariation
  C.Prel <- preliminary_covariation_estimator(data=diff_ret_data, tq)


  # Truncate functionally
  ft <- functional_data_truncation(d = d_star(C = C.Prel, tq), C = C.Prel, data = diff_ret_data, Delta = 1/n, sd = l)
  locs <- ft$locations
  gn <- ft$gn


      # Final covariation estimate
  if (length(locs) == 0) {
    C.final <- variation(diff_ret_data)
  } else {
    C.final <- variation(diff_ret_data[-locs, , drop = FALSE])
  }

  if (!is.null(B)) {
    Truncated.variation <- B %*% C.final %*% t(B)
  } else {
    Truncated.variation <- C.final
  }
  Truncated.variation<-Truncated.variation*(365^2)



  # Explained variance
  eig <- eigen(Truncated.variation, only.values = TRUE)
  expl.var <- cumsum(eig$values) / sum(eig$values)
  LOCs <- dates[locs + 1]  # Align jump indices (which were shifted due to differencing)

  # Optional summary plot
  if (sumplot) plot_summary(x.mat, diff_ret, Truncated.variation, expl.var, dates, locs, gn)

  return(list(
    IV = Truncated.variation,
    locs = LOCs,
    C.Prel = C.Prel,
    adj.increments = diff_ret,
    expl.var = expl.var,
    gn = gn
  ))
}
