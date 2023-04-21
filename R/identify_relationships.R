#' Identify relationships between the dataframes in dhs_data_list
#'
#' @param dhs_data_list A named list of dataframes containing the DHS data.
#' @return A list of lists specifying the relationships between the tables.
identify_relationships <- function(dhs_data_list) {
  table_types <- sapply(names(dhs_data_list), function(x) {
    gsub("^[A-Z]{2}|\\d.*", "", x)
  })
  names(table_types) <- names(dhs_data_list)

  # Define the relationships between table types
  relationship_definitions <- list(
    list(child_type = "IR", parent_type = "HR", child_key = c("v001", "v002"), parent_key = c("hv001", "hv002")),
    list(child_type = "MR", parent_type = "HR", child_key = c("mv001", "mv002"), parent_key = c("hv001", "hv002")),
    list(child_type = "PR", parent_type = "HR", child_key = c("hv001", "hv002"), parent_key = c("hv001", "hv002")),
    list(child_type = "KR", parent_type = "IR", child_key = c("v001", "v002", "v003"), parent_key = c("v001", "v002", "v003")),
    list(child_type = "BR", parent_type = "IR", child_key = c("v001", "v002", "v003"), parent_key = c("v001", "v002", "v003"))
  )

  # Identify the relationships between the dataframes in dhs_data_list based on table types
  relationships <- lapply(relationship_definitions, function(rel_def) {
    child_name <- names(table_types)[which(table_types == rel_def$child_type)]
    parent_name <- names(table_types)[which(table_types == rel_def$parent_type)]

    if (length(child_name) > 0 && length(parent_name) > 0) {
      return(list(child = child_name, parent = parent_name, child_key = rel_def$child_key, parent_key = rel_def$parent_key))
    } else {
      return(NULL)
    }
  })

  # Remove NULL elements
  relationships <- relationships[!sapply(relationships, is.null)]

  return(relationships)
}
