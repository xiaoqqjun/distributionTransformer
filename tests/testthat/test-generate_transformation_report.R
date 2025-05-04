
test_that("generate_transformation_report works correctly", {
  test_data <- data.frame(
    var1 = rnorm(100),
    var2 = rexp(100)
  )
  
  # 捕获输出
  output <- capture.output(
    generate_transformation_report(test_data, c("var1", "var2"))
  )
  
  expect_true(length(output) > 0)
  expect_true(any(grepl("变量分布评估", output)))
  expect_true(any(grepl("var1", output)))
  expect_true(any(grepl("var2", output)))
})

test_that("generate_transformation_report handles missing variables", {
  test_data <- data.frame(var1 = rnorm(100))
  
  output <- capture.output(
    generate_transformation_report(test_data, c("var1", "missing_var"))
  )
  
  expect_true(any(grepl("警告", output)))
  expect_true(any(grepl("missing_var", output)))
})

