#' Create foreign keys for the tables in the PostgreSQL database
#'
#' @param conn A DBI connection object to the PostgreSQL database.
#' @param schema_name A character string specifying the name of the schema.
#' @param relationships A list of lists specifying the relationships between the tables.


create_foreign_keys <- function(conn, schema_name, relationships, uploaded_tables) {
  # Define the table primary keys
  primary_keys <- list(
    hr = c("hv001", "hv002"),
    ir = c("v001", "v002", "v003"),
    mr = c("mv001", "mv002", "mv003"),
    kr = c("v001", "v002", "v003", "midx"),
    br = c("v001", "v002", "v003", "bidx"),
    pr = c("hv001", "hv002", "hvidx"),
    cr = c("v001", "v002", "v003"),
    gc = c("DHSCLUST"),
    ge = c("DHSCLUST")
  )

  table_list <- substr(uploaded_tables, 1, 2)
  names(table_list) <- uploaded_tables

  # Add unique constraints to the parent tables
    for (table in names(table_list)) {
      constraint_name <- paste0(table, "_unique")
      tableType <- substr(table, 1, 2)

      statement <- sprintf(
        "ALTER TABLE %s ADD CONSTRAINT %s UNIQUE (%s);",
        paste0(schema_name, ".", table),
        constraint_name,
        paste(primary_keys[[tableType]], collapse = ", ")
      )
      dbExecute(conn, statement)
    }

  # Create foreign keys
  for (rel in relationships) {
    parent_table_prefix <- rel$parent_table |> tolower()
    child_table_prefix <- rel$child_table |> tolower()
    parent_tables <- find_uploaded_table_names(uploaded_tables, schema_name, parent_table_prefix)
    child_tables <- find_uploaded_table_names(uploaded_tables, schema_name, child_table_prefix)

    for (parent_table in parent_tables) {
      for (child_table in child_tables) {
        fk_name <- paste0("fk_", gsub(paste0(schema_name, "\\."), "", child_table), "_", gsub(paste0(schema_name, "\\."), "", parent_table))

        statement <- sprintf(
          "ALTER TABLE %s\nADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s (%s);",
          child_table,
          fk_name,
          paste(rel$child_columns, collapse = ", "),
          parent_table,
          paste(rel$parent_columns, collapse = ", ")
        )

        dbExecute(conn, statement)
      }
    }
  }
}
