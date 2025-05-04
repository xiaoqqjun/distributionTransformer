
test_that("visualize_transformation_effects creates plots", {
  test_data <- data.frame(var1 = rexp(100))
  
  # 测试是否能成功创建图形
  expect_silent(visualize_transformation_effects(test_data, "var1"))
})

test_that("visualize_transformation_effects handles normal data", {
  test_data <- data.frame(normal_var = rnorm(100))
  
  expect_silent(visualize_transformation_effects(test_data, "normal_var"))
})

