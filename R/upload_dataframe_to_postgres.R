#' Upload a dataframe to the PostgreSQL database
#'
#' @param conn A DBI connection object to the PostgreSQL database.
#' @param schema_name A character string specifying the name of the schema to be created.
#' @param table_name A character string specifying the name of the table to be created.
#' @param df A dataframe to be uploaded to the PostgreSQL database.
upload_dataframe_to_postgres <- function(conn, schema_name, table_name, df) {

  require(haven)
  df[] <- lapply(df, function(x) {
    if (inherits(x, "haven_labelled")) {
      as.character(as_factor(x))
    } else {
      x
    }
  })

  # Clean column names
  colnames(df) <- clean_column_names(colnames(df))

  # # # Remove the schema name prefix from the table name
  # # schema_table_name <- gsub(paste0("^", schema_name, "\\."), "", table_name) |> tolower()
  #
  # schema_table_name <- paste0(schema_name, ".", table_name) |> tolower()

  # # Set the search_path to the desired schema before uploading the dataframe
  # dbSendQuery(conn, paste0("SET search_path TO ", schema_name, ", public;"))

  # Upload the dataframe to the PostgreSQL database
  dbWriteTable(conn, name = c(schema_name, tolower(table_name)), df, row.names = FALSE)
}
