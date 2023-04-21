#' Create a new schema in the PostgreSQL database
#'
#' @param conn A DBI connection object to the PostgreSQL database.
#' @param schema_name A character string specifying the name of the schema to be created.
create_schema <- function(conn, schema_name) {
  # Check if the schema already exists
  query <- sprintf("SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = '%s');", schema_name)
  schema_exists <- dbGetQuery(conn, query)[[1]]

  # Create the schema only if it doesn't exist
  if (!schema_exists) {
    query <- sprintf("CREATE SCHEMA \"%s\"", schema_name)
    dbExecute(conn, query)
  } else {
    message(sprintf("Schema '%s' already exists. Skipping schema creation.", schema_name))
  }
}


