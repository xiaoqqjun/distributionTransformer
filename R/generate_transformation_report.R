#' Generate Transformation Report
#'
#' Generates a comprehensive report with transformation recommendations for multiple variables.
#'
#' @param data Data frame containing the variables to analyze
#' @param variables Character vector of variable names to analyze
#'
#' @return Invisible NULL. The function prints the report to console.
#' @export
#'
#' @examples
#' data <- data.frame(var1 = rnorm(100), var2 = rexp(100))
#' generate_transformation_report(data, c("var1", "var2"))
generate_transformation_report <- function(data, variables) {
  cat("=== 变量分布评估与转换建议报告 ===\n\n")

  for (var in variables) {
    if (var %in% names(data)) {
      cat("----------------------------------------\n")
      cat("变量:", var, "\n")

      eval_result <- evaluate_distribution(data[[var]], var)

      cat("原始数据统计:\n")
      cat(sprintf("  均值: %.2f\n", eval_result$original_stats$mean))
      cat(sprintf("  中位数: %.2f\n", eval_result$original_stats$median))
      cat(sprintf("  标准差: %.2f\n", eval_result$original_stats$sd))
      cat(sprintf("  偏度: %.2f\n", eval_result$original_stats$skewness))
      cat(sprintf("  峰度: %.2f\n", eval_result$original_stats$kurtosis))
      cat(sprintf("  Shapiro-Wilk检验 p值: %.4f\n", eval_result$original_stats$shapiro_p))
      cat(sprintf("  Anderson-Darling检验 p值: %.4f\n", eval_result$original_stats$ad_p))

      if (eval_result$can_log_transform && !is.null(eval_result$log_stats)) {
        cat("\n对数转换后统计:\n")
        cat(sprintf("  偏度: %.2f\n", eval_result$log_stats$skewness))
        cat(sprintf("  峰度: %.2f\n", eval_result$log_stats$kurtosis))
        cat(sprintf("  Shapiro-Wilk检验 p值: %.4f\n", eval_result$log_stats$shapiro_p))
        cat(sprintf("  Anderson-Darling检验 p值: %.4f\n", eval_result$log_stats$ad_p))
      }

      cat("\n建议:", eval_result$recommendation, "\n")
      cat("----------------------------------------\n\n")
    } else {
      cat("警告: 变量", var, "在数据中不存在\n\n")
    }
  }

  invisible(NULL)
}
