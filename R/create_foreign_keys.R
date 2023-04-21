#' Create foreign keys for the tables in the PostgreSQL database
#'
#' @param conn A DBI connection object to the PostgreSQL database.
#' @param schema_name A character string specifying the name of the schema.
#' @param relationships A list of lists specifying the relationships between the tables.
create_foreign_keys <- function(conn, schema_name, relationships) {
  for (rel in relationships) {
    if (all(c(rel$child, rel$parent) %in% names(dhs_data_list))) {
      child_table <- sprintf("%s.%s", schema_name, rel$child)
      parent_table <- sprintf("%s.%s", schema_name, rel$parent)
      foreign_key_name <- sprintf("fk_%s_%s", rel$child, rel$parent)
      constraint_sql <- sprintf(
        "ALTER TABLE %s ADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s (%s);",
        child_table, foreign_key_name, paste(rel$child_key, collapse = ", "),
        parent_table, paste(rel$parent_key, collapse = ", ")
      )
      dbExecute(conn, constraint_sql)
    }
  }
}
