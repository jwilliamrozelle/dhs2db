#' Split a dataframe with more than 1600 columns into multiple dataframes
#'
#' @param df A dataframe to be split.
#' @param id_vars A character vector specifying the ID variables to be included in each split dataframe.
#' @return A list of dataframes.
split_dataframe <- function(df, id_vars) {
  max_cols <- 1600 - length(id_vars)

  # Check if the row size is too big
  row_size <- sum(sapply(df, object.size))
  if (row_size > 8160) {
    max_cols <- floor(max_cols / 2)
  }

  if (ncol(df) <= max_cols) {
    return(list(df))
  }

  split_dfs <- list()
  remaining_vars <- setdiff(colnames(df), id_vars)

  while (length(remaining_vars) > 0) {
    selected_vars <- c(id_vars, remaining_vars[seq_len(min(length(remaining_vars), max_cols))])
    split_dfs[[length(split_dfs) + 1]] <- df[, selected_vars, drop = FALSE]
    remaining_vars <- setdiff(remaining_vars, selected_vars)
  }

  return(split_dfs)
}

