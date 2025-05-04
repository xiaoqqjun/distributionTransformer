#' Create Transformation Summary
#'
#' Creates a summary data frame with transformation recommendations for multiple variables.
#'
#' @param data Data frame containing the variables to analyze
#' @param variables Character vector of variable names to analyze
#'
#' @return A data frame with transformation recommendations
#' @export
#'
#' @examples
#' data <- data.frame(var1 = rnorm(100), var2 = rexp(100))
#' summary <- create_transformation_summary(data, c("var1", "var2"))
create_transformation_summary <- function(data, variables) {
  summary_list <- list()

  for (var in variables) {
    if (var %in% names(data)) {
      eval_result <- evaluate_distribution(data[[var]], var)

      summary_list[[var]] <- data.frame(
        Variable = var,
        Original_Skewness = round(eval_result$original_stats$skewness, 3),
        Original_Kurtosis = round(eval_result$original_stats$kurtosis, 3),
        Original_ShapiroP = round(eval_result$original_stats$shapiro_p, 4),
        Can_Log_Transform = eval_result$can_log_transform,
        Log_Skewness = ifelse(eval_result$can_log_transform,
                              round(eval_result$log_stats$skewness, 3), NA),
        Log_ShapiroP = ifelse(eval_result$can_log_transform,
                              round(eval_result$log_stats$shapiro_p, 4), NA),
        Recommendation = eval_result$recommendation
      )
    }
  }

  summary_df <- do.call(rbind, summary_list)
  rownames(summary_df) <- NULL

  return(summary_df)
}
