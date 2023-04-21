clean_column_names <- function(column_names) {
  # Convert column names to lowercase
  cleaned_column_names <- tolower(column_names)

  # Replace special characters with underscores
  cleaned_column_names <- gsub("[^[:alnum:]]", "_", cleaned_column_names)

  return(cleaned_column_names)
}
