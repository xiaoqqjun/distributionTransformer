#' Visualize Transformation Effects
#'
#' Creates visualizations comparing original and transformed data distributions.
#'
#' @param data Data frame containing the variable to visualize
#' @param var_name Character string specifying the variable name
#'
#' @return A ggplot object or grid arrangement of plots
#' @export
#'
#' @examples
#' data <- data.frame(var1 = rexp(100, rate = 2))
#' visualize_transformation_effects(data, "var1")
visualize_transformation_effects <- function(data, var_name) {
  var_data <- data[[var_name]]
  eval_result <- evaluate_distribution(var_data, var_name)

  # 创建原始数据的图形
  df_orig <- data.frame(value = var_data)

  # 原始数据的直方图
  p1 <- ggplot(df_orig, aes(x = value)) +
    geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.7) +
    geom_density(aes(y = after_stat(count)), color = "red", size = 1) +
    labs(title = paste("Original", var_name),
         subtitle = sprintf("Skewness: %.2f, Kurtosis: %.2f",
                            eval_result$original_stats$skewness,
                            eval_result$original_stats$kurtosis)) +
    theme_minimal()

  # 原始数据的QQ图
  p2 <- ggplot(df_orig, aes(sample = value)) +
    stat_qq() +
    stat_qq_line(color = "red") +
    labs(title = "Q-Q Plot (Original)") +
    theme_minimal()

  # 如果可以进行对数转换
  if (eval_result$can_log_transform) {
    log_data <- log(var_data)
    df_log <- data.frame(value = log_data)

    # 对数转换后的直方图
    p3 <- ggplot(df_log, aes(x = value)) +
      geom_histogram(bins = 30, fill = "darkgreen", color = "white", alpha = 0.7) +
      geom_density(aes(y = after_stat(count)), color = "red", size = 1) +
      labs(title = paste("Log-transformed", var_name),
           subtitle = sprintf("Skewness: %.2f, Kurtosis: %.2f",
                              eval_result$log_stats$skewness,
                              eval_result$log_stats$kurtosis)) +
      theme_minimal()

    # 对数转换后的QQ图
    p4 <- ggplot(df_log, aes(sample = value)) +
      stat_qq() +
      stat_qq_line(color = "red") +
      labs(title = "Q-Q Plot (Log-transformed)") +
      theme_minimal()

    # 组合所有图形
    grid.arrange(p1, p2, p3, p4, ncol = 2,
                 top = grid::textGrob(paste("Transformation Analysis:", var_name),
                                      gp = grid::gpar(fontsize = 16, font = 2)),
                 bottom = grid::textGrob(eval_result$recommendation,
                                         gp = grid::gpar(fontsize = 10, font = 3)))
  } else {
    # 如果不能进行对数转换，只显示原始数据
    grid.arrange(p1, p2, ncol = 2,
                 top = grid::textGrob(paste("Distribution Analysis:", var_name),
                                      gp = grid::gpar(fontsize = 16, font = 2)),
                 bottom = grid::textGrob(eval_result$recommendation,
                                         gp = grid::gpar(fontsize = 10, font = 3)))
  }
}
