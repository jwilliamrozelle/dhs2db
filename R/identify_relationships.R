#' Identify relationships between the dataframes in dhs_data_list
#'
#' @param dhs_data_list A named list of dataframes containing the DHS data.
#' @return A list of lists specifying the relationships between the tables.

# dhs_data_list <- dhsData.list

identify_relationships <- function(dhs_data_list) {
  table_names <- names(dhs_data_list)

  # # Function to identify the table type
  # get_table_type <- function(table_name) {
  #   substr(table_name, 3, 4)
  # }

  # check if all table types are unique types
  if (length(unique(table_names)) != length(table_names)) {
    stop("There are duplicate table types in this dhs_data_list. Please make sure there are no duplicate table types")
  }


  # Name each table_name in vector by the table_type
  for(table_index in 1:length(table_names)) {
    names(table_names)[table_index] <- get_table_type(table_names[table_index])
  }

  relationships <- list()

  # HR to IR relationships
  if ("hr" %in% table_names && "ir" %in% table_names) {
    relationships <- append(relationships, list(list(
      child_table = "ir",
      parent_table = "hr",
      child_columns = c("v001", "v002"),
      parent_columns = c("hv001", "hv002")
    )))
  }

  # HR to MR relationships
  if ("hr" %in% table_names && "mr" %in% table_names) {
    relationships <- append(relationships, list(list(
      child_table = "mr",
      parent_table = "hr",
      child_columns = c("mv001", "mv002"),
      parent_columns = c("hv001", "hv002")
    )))
  }

  # IR to KR relationships
  if ("ir" %in% table_names && "kr" %in% table_names) {
    relationships <- append(relationships, list(list(
      child_table = "kr",
      parent_table = "ir",
      child_columns = c("v001", "v002", "v003"),
      parent_columns = c("v001", "v002", "v003")
    )))
  }

  # IR to BR relationship
  if ("ir" %in% table_names && "br" %in% table_names) {
    relationships <- append(relationships, list(list(
      child_table = "br",
      parent_table = "ir",
      child_columns = c("v001", "v002", "v003"),
      parent_columns = c("v001", "v002", "v003")
    )))
  }

  # HR to PR relationship
  if ("hr" %in% table_names && "pr" %in% table_names) {
    relationships <- append(relationships, list(list(
      child_table = "pr",
      parent_table = "hr",
      child_columns = c("hv001", "hv002"),
      parent_columns = c("hv001", "hv002")
    )))
  }

  # GC to HR relationship
  if ("gc" %in% names(table_names) && "hr" %in% names(table_names)) {
    relationships <- append(relationships, list(list(
      child_table = "hr",
      parent_table = "gc",
      child_columns = c("hv001"),
      parent_columns = c("dhclust")
    )))
  }

  # GC to IR relationship
  if ("gc" %in% names(table_names) && "ir" %in% names(table_names)) {
    relationships <- append(relationships, list(list(
      child_table = "ir",
      parent_table = "gc",
      child_columns = c("v001"),
      parent_columns = c("dhclust")
    )))
  }

  # Add more relationships based on the provided guidance

  return(relationships)
}

