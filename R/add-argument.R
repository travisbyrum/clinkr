#' Set Argument
#'
#' This function creates instantiates a member of the argument class.
#'
#' @keywords internal
set_argument <- function(store_name, help_string = '', default = NULL, type = NULL,
                         choices = NULL, n_args = 1) {
  assertthat::assert_that(
    is.character(store_name),
    is.character(help_string),
    is.character(type) || is.null(type),
    is.character(choices) || is.null(choices),
    is.numeric(n_args)
  )

  store_name <- store_name[1]
  type <- match.arg(type, c('logical', 'numeric', 'character', 'list', NULL))

  type_default_mismatch <- !is.null(default) && !is.null(type) && class(default) != type

  if (type_default_mismatch)
    stop('type does not match class of default')

  if (is.null(type) && !is.null(default))
    type <- class(default)

  if (is.null(store_name))
    store_name <- gsub(paste0('^', prefix), '', store_name)

  structure(
    list(
      store_name  = store_name,
      help_string = help_string,
      default     = default,
      type        = type,
      choices     = choices,
      n_args      = n_args,
      is_option   = FALSE,
      position    = NULL
    ),
    class = c("argument")
  )
}

#' @export
add_argument <- function(x, ...) UseMethod("add_argument")

#' @export
add_argument.parser <- function(x, store_name, help_string = '', default = NULL,
                                type = NULL, choices = NULL, n_args = 1) {
  argument <- set_argument(
    help_string = help_string,
    default     = default,
    store_name  = store_name,
    type        = type,
    choices     = choices,
    n_args      = n_args
  )

  x$add_agument(argument = argument)
  invisible(x)
}
