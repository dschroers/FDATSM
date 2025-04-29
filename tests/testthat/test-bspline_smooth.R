library(splines)

# Dummy input matrix with 3 rows and 10 columns
test_input <- matrix(rnorm(30), nrow = 3)

test_that("bspline_smooth returns expected structure", {
  result <- bspline_smooth(test_input)

  expect_type(result, "list")
  expect_named(result, c("coeffs", "B_centers", "B_grid", "x_grid", "x_centers"))

  # Check dimensions
  m <- ncol(test_input) + 2
  n_knots <- min(50, m - 2)
  x_grid <- seq(0, m / 365, length.out = m - 1)
  x_centers <- (x_grid[-1] + x_grid[-length(x_grid)]) / 2
  B_centers <- bs(x_centers, df = n_knots, degree = 3, intercept = TRUE,
                  Boundary.knots = range(x_grid))

  expect_equal(dim(result$coeffs), c(nrow(test_input), n_knots))
  expect_equal(dim(result$B_centers), dim(as.matrix(B_centers)))
  expect_equal(length(result$x_grid), m - 1)
  expect_equal(length(result$x_centers), m - 2)
  expect_equal(dim(result$B_grid), c(m - 1, n_knots))
})
