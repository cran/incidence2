# -------------------------------------------------------------------------
#' Convert incident object to dataframe
#'
#' @param x An [incidence()] object.
#' @param ... Not used.
#'
#' @examples
#' dat <- data.frame(dates = Sys.Date() + 1:100,
#'                   names = rep(c("Jo", "John"), 5))
#'
#' dat <- incidence(dat, date_index = dates, groups = names)
#' as.data.frame(dat)
#'
#' @export
as.data.frame.incidence_df <- function(x, ...) {
  vctrs::new_data_frame(x)
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
#' Convert incident object to a tibble
#'
#' @param x An [incidence()] object.
#' @param ... Not used.
#'
#' @examples
#' dat <- data.frame(dates = Sys.Date() + 1:100,
#'                   names = rep(c("Jo", "John"), 5))
#'
#' dat <- incidence(dat, date_index = dates, groups = names)
#' as_tibble(dat)
#'
#' @export
#' @name as_tibble
as_tibble.incidence_df <- function(x, ...) {
  new_bare_tibble(x)
}
# -------------------------------------------------------------------------

#' @importFrom tibble as_tibble
#' @export
#' @name as_tibble
tibble::as_tibble()
# -------------------------------------------------------------------------

