#' Set Option
#'
#' This function creates instantiates a member of the option class.
#'
#' @keywords internal
set_option <- function(option_strings, store_name = NULL, prefix = '-', help_string = '',
                       default = NULL, is_flag = FALSE, type = NULL, choices = NULL,
                       n_args = 1) {
  assertthat::assert_that(
    is.character(option_strings),
    is.character(store_name) || is.null(store_name),
    is.character(prefix),
    is.character(help_string),
    is.logical(is_flag),
    is.character(type) || is.null(type),
    is.character(choices) || is.null(choices),
    is.numeric(n_args)
  )

  store_name <- store_name[1]
  type <- match.arg(type, c('logical', 'numeric', 'character', 'list', NULL))

  if (is_flag) {
    type <- 'logical'
    default <- FALSE
  }

  type_default_mismatch <- !is.null(default) && !is.null(type) && class(default) != type

  if (type_default_mismatch)
    stop('type does not match class of default')

  if (is.null(type) && !is.null(default))
    type <- class(default)

  short_option <- option_strings %>%
    Filter(function(str) grepl(paste0('^', prefix, '[a-zA-Z0-9]'), str), .) %||%
    NULL

  long_option <- option_strings %>%
    Filter(function(str) grepl(paste0('^', prefix, '{2}[a-zA-Z0-9]'), str), .)

  if (!length(long_option))
    stop('At least one long option must be provided')

  if (is.null(store_name))
    store_name <- gsub(paste0('^', prefix, '+'), '', long_option)

  structure(
    list(
      short_option = short_option,
      long_option  = long_option,
      store_name   = store_name,
      help_string  = help_string,
      default      = default,
      type         = type,
      is_flag      = is_flag,
      is_option    = TRUE,
      choices      = choices,
      n_args       = n_args
    ),
    class = c("option")
  )
}

#' @export
add_option <- function(x, ...) UseMethod("add_option")

#' @export
add_option.parser <- function(x, option_strings, store_name = NULL, prefix = '-', help_string = '',
                              default = NULL, is_flag = FALSE, type = NULL, choices = NULL,
                              n_args = 1) {
  option <- set_option(
    option_strings = option_strings,
    prefix         = prefix,
    help_string    = help_string,
    default        = default,
    store_name     = store_name,
    is_flag        = is_flag,
    type           = type,
    choices        = choices,
    n_args         = n_args
  )

  x$add_option(option = option)
  invisible(x)
}
