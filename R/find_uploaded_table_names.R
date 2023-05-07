find_uploaded_table_names <- function(uploaded_tables, schema_name, prefix) {
  matching_tables <- uploaded_tables[grepl(paste0("^", prefix), uploaded_tables)]
  full_table_names <- paste0(schema_name, ".", matching_tables)
  return(full_table_names)
}
