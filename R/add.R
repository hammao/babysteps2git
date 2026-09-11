#' Add two numbers
#'
#' @param x A numeric value.
#' @param y A numeric value.
#' @return The numeric sum of `x` and `y`.
#' @export
#' @examples
#' add_numbers(2, 3)
add_numbers <- function(x, y) {
  if (!is.numeric(x) || !is.numeric(y)) {
    stop("`x` and `y` must be numeric.", call. = FALSE)
  }
  x + y
}
