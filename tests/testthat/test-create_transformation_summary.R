
test_that("create_transformation_summary works correctly", {
  test_data <- data.frame(
    var1 = rnorm(100),
    var2 = rexp(100)
  )
  
  summary_result <- create_transformation_summary(test_data, c("var1", "var2"))
  
  expect_s3_class(summary_result, "data.frame")
  expect_equal(nrow(summary_result), 2)
  expect_true("Variable" %in% names(summary_result))
  expect_true("Recommendation" %in% names(summary_result))
  expect_true("Original_Skewness" %in% names(summary_result))
})

test_that("create_transformation_summary handles empty data", {
  empty_data <- data.frame()
  summary_result <- create_transformation_summary(empty_data, character(0))
  
  expect_s3_class(summary_result, "data.frame")
  expect_equal(nrow(summary_result), 0)
})

