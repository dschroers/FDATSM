test_that("preliminary_covariation_estimator returns a proper scaled covariance matrix", {
  set.seed(123)
  test_data <- matrix(rnorm(40), ncol = 4)  # 10 observations, 4 variables
  tq <- 0.1
  n <- nrow(test_data)

  result <- preliminary_covariation_estimator(test_data, tq)

  # Basic checks
  expect_true(is.matrix(result))
  expect_equal(dim(result), c(4, 4))
  expect_true(all(is.finite(result)))

  # Optional: Check symmetry (since it's a cov-like matrix)
  expect_equal(result, t(result), tolerance = 1e-8)
})
