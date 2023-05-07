#' Upload DHS data to a PostgreSQL database
#'
#' @param dhs_data_list A named list of dataframes containing the DHS data to be uploaded.
#' @param schema_name A character string specifying the name of the schema to be created in the PostgreSQL database.
#' @param db_host A character string specifying the host name or IP address of the PostgreSQL server.
#' @param db_port A numeric value specifying the port number to use for the connection.
#' @param db_name A character string specifying the name of the PostgreSQL database to connect to.
#' @param db_user A character string specifying the username to be used when connecting to the PostgreSQL server.
#' @param db_password A character string specifying the password to be used when connecting to the PostgreSQL server.
#'
#' @return A character string indicating the success or failure of the data upload. If successful, the string will also
#'   list the names of the dataframes that have been uploaded to the PostgreSQL database.
#' @export
#'
#'
#'

dhs2pg <- function(dhs_data_list, schema_name, db_host, db_port, db_name, db_user, db_password) {

  # dhs_data_list <- dhsData.list
  # schema_name <- Sys.getenv("DB_SCHEMA")
  # db_host <- Sys.getenv("DB_HOST")
  # db_port <- Sys.getenv("DB_PORT")
  # db_name <- Sys.getenv("DB_NAME")
  # db_user <- Sys.getenv("DB_USER")
  # db_password <- Sys.getenv("DB_PW")


  # Load required packages
  require(DBI)
  require(RPostgreSQL)
  require(dplyr)
  require(tidyverse)
  require(haven)

  # Establish a connection to the PostgreSQL database
  conn <- dbConnect(
    RPostgreSQL::PostgreSQL(),
    host = db_host,
    port = db_port,
    dbname = db_name,
    user = db_user,
    password = db_password
  )

  on.exit(dbDisconnect(conn), add = TRUE)


  # rename to two digit survey type
  if (nchar(names(dhs_data_list))[1] != 2) {
    names(dhs_data_list) <- substr(names(dhs_data_list), 3,4) |> tolower()
  }

  schema_name <- tolower(schema_name)

  # Create a new schema in the PostgreSQL database
  cat("Creating schema...\n")
  create_schema(conn, schema_name)

  # Identify relationships between the dataframes in dhs_data_list
  cat("Identifying relationships...\n")
  relationships <- identify_relationships(dhs_data_list)


  # Trim duplicate variables
  cat("Trimming duplicate variables in tables...\n")
  dhs_data_list <- removeDup(dhs_data_list)


  # Upload the dataframes to the PostgreSQL database
  cat("Uploading dataframes...\n")
  uploaded_tables <- character(0)
  for (table_name in names(dhs_data_list)) {
    cat(sprintf("Uploading %s...\n", table_name))
    df <- dhs_data_list[[table_name]]
    id_vars <- identify_id_variables(table_name)

    # Check if table exists in the database
    if (table_exists(conn, schema_name, table_name)) {
      warning(sprintf("Table %s.%s exists in database: aborting assignTable", schema_name, table_name))
      next
    }

    # Split dataframe if it has more than 1600 columns
    split_dfs <- split_dataframe(df, id_vars)

    for (i in seq_along(split_dfs)) {
      if (length(split_dfs) > 1) {
        suffix <- sprintf("_part%02d", i)
      } else {
        suffix <- ""
      }
      upload_table_name <- paste0(table_name, suffix) |> tolower()
      upload_dataframe_to_postgres(conn, schema_name, upload_table_name, split_dfs[[i]])
      uploaded_tables <- c(uploaded_tables, upload_table_name)
    }
  }

  # Create foreign keys for the tables in the PostgreSQL database
  cat("Creating foreign keys...\n")
  create_foreign_keys(conn, schema_name, relationships, uploaded_tables)

  # # Commit the transaction
  # cat("Committing transaction...\n")
  # dbCommit(conn)

  return(paste("Data upload successful. Uploaded tables:", paste(uploaded_tables, collapse = ", ")))
}

