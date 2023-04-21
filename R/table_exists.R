#' Check if a table exists in the PostgreSQL database
#'
#' @param conn A connection object to the PostgreSQL database.
#' @param schema_name A character string representing the schema name.
#' @param table_name A character string representing the table name.
#' @return A logical value indicating whether the table exists in the PostgreSQL database.
table_exists <- function(conn, schema_name, table_name) {


  # Split full_table_name into schema and table name
  # schema_and_table <- strsplit(full_table_name, "\\.")[[1]]
  # schema_name <- schema_and_table[1]
  # table_name <- schema_and_table[2]

  query <- sprintf("SELECT EXISTS (
                     SELECT 1
                     FROM   information_schema.tables
                     WHERE  table_schema = '%s'
                     AND    table_name = '%s'
                   );", schema_name, table_name)

  return(dbGetQuery(conn, query)[[1]])
}
