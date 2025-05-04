
test_that("evaluate_distribution works with normal data", {
  set.seed(123)
  normal_data <- rnorm(100)
  result <- evaluate_distribution(normal_data, "normal_var")
  
  expect_type(result, "list")
  expect_equal(result$variable, "normal_var")
  expect_true("recommendation" %in% names(result))
  expect_true("original_stats" %in% names(result))
  expect_true(abs(result$original_stats$skewness) < 1)
})

test_that("evaluate_distribution works with skewed data", {
  set.seed(123)
  skewed_data <- rexp(100)
  result <- evaluate_distribution(skewed_data, "skewed_var")
  
  expect_true(result$original_stats$skewness > 0)
  expect_true(result$can_log_transform)
  expect_true(grepl("右偏", result$recommendation))
})

test_that("evaluate_distribution handles non-positive data", {
  mixed_data <- c(-1, 0, 1, 2, 3)
  result <- evaluate_distribution(mixed_data, "mixed_var")
  
  expect_false(result$can_log_transform)
  expect_true(grepl("非正值", result$recommendation))
})

test_that("evaluate_distribution handles NA values", {
  data_with_na <- c(1, 2, NA, 4, 5)
  result <- evaluate_distribution(data_with_na, "na_var")
  
  expect_equal(length(na.omit(data_with_na)), 4)
  expect_type(result, "list")
})

