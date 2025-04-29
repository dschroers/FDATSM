test_that("interpolate_curve returns numeric vector of correct length", {
  maturities <- c(1, 2, 3, 5, 10)
  prices <- c(0.99, 0.97, 0.95, 0.93, 0.88)
  day_grid <- seq(0, 10, by = 0.1)

  curve <- interpolate_curve(maturities, prices, day_grid)

  expect_type(curve, "double")
  expect_length(curve, length(day_grid))
})

test_that("interpolation includes value 1 at time 0", {
  maturities <- c(1, 2, 3)
  prices <- c(0.99, 0.97, 0.95)
  day_grid <- seq(0, 3, by = 0.1)

  curve <- interpolate_curve(maturities, prices, day_grid)

  expect_equal(curve[which.min(abs(day_grid))], 1)
})

test_that("interpolated discount curve is non-increasing", {
  maturities <- c(1, 2, 5, 10)
  prices <- c(0.99, 0.96, 0.92, 0.88)
  day_grid <- seq(0, 10, length.out = 100)

  curve <- interpolate_curve(maturities, prices, day_grid)

  # Check that the interpolated curve does not increase
  diffs <- diff(curve)
  expect_true(all(diffs <= 1e-6))  # Allow a tiny numerical wiggle
})

test_that("interpolate_curve handles extrapolation gracefully", {
  maturities <- c(1, 5, 10)
  prices <- c(0.99, 0.93, 0.88)
  day_grid <- seq(-1, 15, by = 0.1)

  curve <- interpolate_curve(maturities, prices, day_grid)

  expect_false(any(is.na(curve)))
  expect_true(curve[which.min(abs(day_grid))] == 1)
})
