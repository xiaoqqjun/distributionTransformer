#' Evaluate Variable Distribution
#'
#' Evaluates the distribution of a numeric variable and provides transformation recommendations.
#'
#' @param data Numeric vector of data to analyze
#' @param var_name Character string specifying the variable name
#'
#' @return A list containing distribution statistics and transformation recommendations
#' @export
#'
#' @examples
#' data <- rnorm(100, mean = 10, sd = 2)
#' result <- evaluate_distribution(data, "example_var")
#' print(result$recommendation)
evaluate_distribution <- function(data, var_name) {
  # 移除NA值
  data_clean <- na.omit(data)

  # 计算统计量
  data_mean <- mean(data_clean)
  data_median <- median(data_clean)
  data_sd <- sd(data_clean)
  data_skew <- moments::skewness(data_clean)
  data_kurt <- moments::kurtosis(data_clean) - 3  # 超额峰度

  # 正态性检验
  shapiro_test <- shapiro.test(data_clean)
  ad_test <- nortest::ad.test(data_clean)

  # 判断是否适合对数转换
  can_log_transform <- all(data_clean > 0)

  # 如果可以进行对数转换，评估转换后的分布
  if (can_log_transform) {
    log_data <- log(data_clean)
    log_skew <- moments::skewness(log_data)
    log_kurt <- moments::kurtosis(log_data) - 3
    log_shapiro <- shapiro.test(log_data)
    log_ad <- nortest::ad.test(log_data)
  }

  # 生成转换建议
  recommendation <- ""

  # 基于偏度给出建议
  if (abs(data_skew) < 0.5) {
    recommendation <- "数据分布接近对称，可能不需要转换。"
  } else if (data_skew > 0.5) {
    if (can_log_transform) {
      if (abs(log_skew) < abs(data_skew)) {
        recommendation <- "数据右偏，建议进行对数转换。"
      } else {
        recommendation <- "数据右偏，但对数转换效果不明显，考虑其他转换（如平方根或Box-Cox）。"
      }
    } else {
      recommendation <- "数据右偏，但包含非正值，无法进行对数转换。考虑平方根或Box-Cox转换。"
    }
  } else {
    recommendation <- "数据左偏，可能需要平方或指数转换。"
  }

  # 基于正态性检验补充建议
  if (shapiro_test$p.value > 0.05 && ad_test$p.value > 0.05) {
    recommendation <- paste(recommendation, "当前数据已接近正态分布，可能不需要转换。")
  } else if (can_log_transform && log_shapiro$p.value > 0.05 && log_ad$p.value > 0.05) {
    recommendation <- paste(recommendation, "对数转换后数据接近正态分布，强烈建议使用对数转换。")
  }

  # 返回完整评估结果
  result <- list(
    variable = var_name,
    original_stats = list(
      mean = data_mean,
      median = data_median,
      sd = data_sd,
      skewness = data_skew,
      kurtosis = data_kurt,
      shapiro_p = shapiro_test$p.value,
      ad_p = ad_test$p.value
    ),
    can_log_transform = can_log_transform,
    recommendation = recommendation
  )

  if (can_log_transform) {
    result$log_stats <- list(
      skewness = log_skew,
      kurtosis = log_kurt,
      shapiro_p = log_shapiro$p.value,
      ad_p = log_ad$p.value
    )
  }

  return(result)
}
