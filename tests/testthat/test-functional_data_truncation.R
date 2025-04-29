test_that("functional_data_truncation flags high Mahalanobis distances", {




  set.seed(123)
  data<-matrix(0,100,4)
  for (i in 1:4) {
    data[2:100,i]<-rnorm(99,0,.01)
  }
  data[1,]<-rep(100,4)

  result <- FDATSM:::functional_data_truncation(
    d = 3,
    C = diag(4),
    data = data,
    Delta = .01,
    sd = 3
  )
  # Only the first row should be truncated
  expect_equal(result$locations, 1)

  # when there is no outlier, no truncation should be applied
  result_no_outlier <- FDATSM:::functional_data_truncation(
    d = 3,
    C = diag(4),
    data = data[2:100,],
    Delta = .01,
    sd = 3
  )

  # No truncation should appear
  expect_equal(result_no_outlier$locations, integer(0))
})
