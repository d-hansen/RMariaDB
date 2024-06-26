#' Check if default database is available.
#'
#' RMariaDB examples and tests connect to a database defined by the
#' `rs-dbi` group in `~/.my.cnf`. This function checks if that
#' database is available, and if not, displays an informative message.
#' `mariadbDefault()` works similarly but throws a testthat skip condition
#' on failure, making it suitable for use in tests.
#'
#' @export
#' @examples
#' if (mariadbHasDefault()) {
#'   db <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'   dbListTables(db)
#'   dbDisconnect(db)
#' }
mariadbHasDefault <- function() {
  tryCatch(
    {
      mariadb_default()
      TRUE
    },
    error = function(...) {
      message(
        "Could not initialise default MariaDB database. If MariaDB is running\n",
        "check that you have a ~/.my.cnf file that contains a [rs-dbi] section\n",
        "describing how to connect to a test database."
      )
      FALSE
    })
}

#' @export
#' @rdname mariadbHasDefault
mariadbDefault <- function() {
  tryCatch(
    {
      mariadb_default()
    },
    error = function(...) {
      testthat::skip("Test database not available")
    }
  )
}

mysqlDefault <- function() {
  tryCatch(
    {
      mariadb_default(mysql = TRUE)
    },
    error = function(...) {
      testthat::skip("Test database not available")
    }
  )
}

mariadbForceDefault <- function() {
  tryCatch(
    {
      mariadb_default(mysql = FALSE)
    },
    error = function(...) {
      testthat::skip("Test database not available")
    }
  )
}

mariadb_default <- function(...) {
  rlang::inject(dbConnect(MariaDB(), !!!mariadb_default_args, ...))
}

mariadb_default_args <- as.list(c(
  dbname = "test",
  # host = "192.168.64.2",
  # user = "compose",
  # password = "YourStrong!Passw0rd",
  NULL
))
