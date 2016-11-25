#' @importFrom magrittr %>%
magrittr::`%>%`

`%||%` <- function(a, b) if (is.null(a)) b else a

is_truthy <- function(x) {
  vapply(
    x,
    function(v) {
      !is.null(v) &&
        !is.na(v) &&
        length(v) != 0 &&
        nchar(v) != 0 &&
        !identical(v, FALSE)
    },
    logical(1),
    USE.NAMES = FALSE
  )
}
