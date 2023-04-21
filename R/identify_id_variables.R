#' Identify ID variables for each table type
#'
#' @param table_name A character string representing the full table name.
#' @return A list of character strings representing the ID variables for the table type.
identify_id_variables <- function(table_name) {
  # Extract table type from the table_name
  table_type <- sub(".*([A-Z]{2})[0-9].*", "\\1", table_name)

  id_var_definitions <- list(
    HR = c("hv001", "hv002"),
    IR = c("v001", "v002", "v003"),
    MR = c("mv001", "mv002", "mv003"),
    PR = c("hv001", "hv002", "hv003"),
    KR = c("v001", "v002", "v003", "midx"),
    BR = c("v001", "v002", "v003", "bidx"),
    CR = c("v001", "v002", "v003"),
    GC = "v001"
  )

  id_vars <- id_var_definitions[[table_type]]

  return(id_vars)
}
