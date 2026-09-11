#' Greet someone
#'
#' @param name A length-one character string naming who to greet.
#' @return A greeting string.
#' @export
#' @examples
#' greet("world")
greet <- function(name = "world") {
  if (!is.character(name) || length(name) != 1L) {
    stop("`name` must be a single string.", call. = FALSE)
  }
  paste0("Hello, ", name, "!")
}
