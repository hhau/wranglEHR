#' Retrieve Database Tables
#'
#' Places all tables from the database connection in a list.
#'
#' @param connection an sql connection
#' @param schema string vector: the database schema targeted
#'
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr tbl
#' @importFrom dbplyr in_schema
#' @importFrom purrr map
#' @importFrom magrittr %>%
#'
#' @return a list containing pointers to tables within the sql connection.
#' @export
retrieve_tables <- function(connection, schema = "ops_dev") {
  
  if (missing(connection)) {
    stop("a connection must be provided")
  }
  
  schema_tbls <- dbGetQuery(
    ctn, paste0(
      "SELECT * FROM information_schema.tables WHERE table_schema = '",
      schema,
      "'")
      )

  tbls <- schema_tbls$table_name %>%
    map(~ tbl(ctn, in_schema(schema, .x)))
  
  names(tbls) <- schema_tbls$table_name

  return(tbls)
}


#' Round any
#'
#' rounds a numeric value to any arbitrary degree of precision.
#' defaults to nearest whole integer
#'
#' @param x a numeric vector
#' @param accuracy a numeric value specifying the base for rounding
#'
#' @return a vector of the same length as \code{x} rounded to the defined
#'   accuracy
#'
#' @examples
#' round_any(c(1, 1.25, 1.5, 1.75, 2), accuracy = 0.5)
round_any <- function(x, accuracy = 1) {
  round(x / accuracy) * accuracy
}
