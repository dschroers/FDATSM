test_that("L2_HS_norm returns scalar numeric", {
  M <- matrix(1, 10, 10)
  result <- L2_HS_norm(M)
  expect_type(result, "double")
  expect_length(result, 1)
})

test_that("L2_HS_norm computes correct norm for constant kernel", {
  M <- matrix(1, 100, 100)
  from <- 0
  to <- 1

  # True L² norm over [0,1]^2 of constant function 1 is:
  # ∫∫ 1^2 ds dt = (1 - 0)^2 = 1
  result <- L2_HS_norm(M, from = from, to = to)

  expect_equal(result, 1, tolerance = 1e-2)
})

test_that("L2_HS_norm respects different interval sizes", {
  M <- matrix(1, 100, 100)

  # Interval [0, 2], so norm should be 2
  result <- L2_HS_norm(M, from = 0, to = 2)
  expect_equal(result, 2, tolerance = 1e-2)
})
