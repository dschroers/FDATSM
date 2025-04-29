test_that("variation computes t(Incr) %*% Incr", {
  X <- matrix(1:6, nrow = 2)
  expect_equal(FDATSM:::variation(X), t(X) %*% X)
})
