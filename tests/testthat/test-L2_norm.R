test_that("L2_norm returns scalar numeric", {
  v <- rep(1, 100)
  result <- L2_norm(v)
  expect_type(result, "double")
  expect_length(result, 1)
})

test_that("L2_norm computes correct norm for constant function", {
  v <- rep(1, 100)
  result <- L2_norm(v, from = 0, to = 1)

  # True L² norm of f(x) = 1 on [0,1] is sqrt(1)
  expect_equal(result, 1, tolerance = 1e-2)
})

test_that("L2_norm respects different interval sizes", {
  v <- rep(1, 100)

  result <- L2_norm(v, from = 0, to = 2)

  # L² norm of f(x) = 1 on [0,2] is sqrt(2)
  expect_equal(result, sqrt(2), tolerance = 1e-2)
})

test_that("L2_norm works for known function: sin(pi x)", {
  x <- seq(0, 1, length.out = 1000)
  f <- sin(pi * x)

  result <- L2_norm(f)

  # True L² norm of sin(pi x) on [0,1] is sqrt(1/2)
  expect_equal(result, sqrt(0.5), tolerance = 1e-2)
})
