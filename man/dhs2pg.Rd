% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dhs2pg.R
\name{dhs2pg}
\alias{dhs2pg}
\title{Upload DHS data to a PostgreSQL database}
\usage{
dhs2pg(
  dhs_data_list,
  schema_name,
  db_host,
  db_port,
  db_name,
  db_user,
  db_password
)
}
\arguments{
\item{dhs_data_list}{A named list of dataframes containing the DHS data to be uploaded.}

\item{schema_name}{A character string specifying the name of the schema to be created in the PostgreSQL database.}

\item{db_host}{A character string specifying the host name or IP address of the PostgreSQL server.}

\item{db_port}{A numeric value specifying the port number to use for the connection.}

\item{db_name}{A character string specifying the name of the PostgreSQL database to connect to.}

\item{db_user}{A character string specifying the username to be used when connecting to the PostgreSQL server.}

\item{db_password}{A character string specifying the password to be used when connecting to the PostgreSQL server.}
}
\value{
A character string indicating the success or failure of the data upload. If successful, the string will also
  list the names of the dataframes that have been uploaded to the PostgreSQL database.
}
\description{
Upload DHS data to a PostgreSQL database
}
