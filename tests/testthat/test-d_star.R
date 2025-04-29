test_that("d_star computes correct number of components", {
  # Create a simple covariance matrix
  C <- diag(3)

  # With an identity matrix, all variance is equal (1/3 each)
  expect_equal(FDATSM:::d_star(C, 0.34), 2)  # 1 component explains 33%, so need 2
  expect_equal(FDATSM:::d_star(C, 0.67), 3)  # 2 components = 66%, still need 3

  # Example with unequal variances
  C2 <- matrix(c(4, 0, 0,
                 0, 2, 0,
                 0, 0, 1), nrow = 3, byrow = TRUE)
  # Eigenvalues = 4, 2, 1; total variance = 7
  # Cumulative variance = 4/7, (4+2)/7 = 6/7

  expect_equal(FDATSM:::d_star(C2, 0.5), 1)  # First eigenvalue is enough
  expect_equal(FDATSM:::d_star(C2, 0.85), 2) # Need two to reach 6/7
  expect_equal(FDATSM:::d_star(C2, 0.95), 3) # Need all three
})

test_that("d_star handles edge cases", {
  C <- diag(2)

  expect_equal(FDATSM:::d_star(C, 0), 1)      # 0 variance explained: still returns 1
  expect_equal(FDATSM:::d_star(C, 1), 2)      # 100% variance: returns all components
  expect_error(FDATSM:::d_star(matrix(1, 2, 3), 0.9))  # Not square matrix
})
