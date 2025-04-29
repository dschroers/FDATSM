test_that("quantile_truncation returns correct indices", {
  data <- matrix(
    c(1, 2,
      2, 2,
      5, 5,
      0.1, 0.1),
    ncol = 2,
    byrow = TRUE
  )

  # Compute which rows have norms above the 75% quantile
  result <- FDATSM:::quantile_truncation(data, q = 0.75)

  # Manually compute norms to check
  norms <- apply(data, 1, function(r) sqrt(sum(r^2)))
  threshold <- quantile(norms, 0.75)
  expected <- which(norms >= threshold)

  expect_equal(result, expected)
  expect_type(result, "integer")
})

test_that("quantile_truncation works with data frames", {
  df <- data.frame(x = c(1, 2, 3), y = c(0, 0, 4))
  result <- FDATSM:::quantile_truncation(df, 0.67)
  expect_true(all(result %in% 1:3))
})

test_that("quantile_truncation rejects invalid inputs", {
  expect_error(FDATSM:::quantile_truncation(list(1:3), 0.5), "`data` must be")
  expect_error(FDATSM:::quantile_truncation(data.frame(x = c("a", "b")), 0.5), "must be numeric")
  expect_error(FDATSM:::quantile_truncation(matrix(1:4, 2), q = 1), "`q` must be")
  expect_error(FDATSM:::quantile_truncation(matrix(1:4, 2), q = -0.1), "`q` must be")
})
