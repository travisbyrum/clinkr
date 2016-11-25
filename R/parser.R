#' Create Argument Parser
#'
#' This function produces the argument parsing object.
#'
#' @examples
#' args <- arg_parser() %>%
#'    add_argument('--verbose', '-v', is_flag = TRUE, help = 'Prints verbose output.') %>%
#'    add_argument('--multiply', type = 'numeric', help = 'Multiply by given number,') %>%
#'    parse_args()
#'
#' @keywords internal
Parser <- R6::R6Class(
  'parser',
  public = list(
    prefix       = NULL,
    description  = NULL,
    n_arguments  = NULL,
    n_options    = NULL,
    option_map   = HashMap$new(),

    initialize = function(option_list = NULL, prefix = '-', include_help = TRUE,
                          description = '') {

      list_is_all_options <- vapply(
        option_list,
        function(opt) inherits(opt, c('option', 'argument')),
        logical(1)
      ) %>%
        all()

      assertthat::assert_that(
        is.list(option_list) || is.null(option_list),
        list_is_all_options,
        is.character(prefix),
        is.logical(include_help),
        is.character('')
      )

      self$prefix <- prefix
      self$description <- description

      if (!is.null(option_list)) {
        names(option_list) <- Map(function(opt) opt$store_name, option_list)

        options <- option_list %>%
          Filter(function(opt) inherits(opt, 'option'), .)

        arguments <- option_list %>%
          Filter(function(arg) inherits(arg, 'argument'), .)

        for (i in seq_along(arguments)) {
          arguments[[i]]$position <- i
        }

        self$n_arguments <- n_arguments
        self$n_options <- n_options
        self$option_map$putAll(arguments)
        self$option_map$putAll(options)
      }

      if (include_help)
        self$add_option(
          option_strings   = c('-h', '--help'),
          is_flag          = TRUE
        )

      invisible(self)
    },

    add_argument = function(store_name, help_string = '', default = NULL, type = NULL,
                            choices = NULL, n_args = 1) {
      argument <- set_argument(
        help_string      = help_string,
        default          = default,
        store_name       = store_name,
        type             = type,
        choices          = choices,
        n_args           = n_args
      )

      position <- ifelse(is.null(self$n_arguments), 1, n_arguments + 1)
      argument$position <- position
      self$map$put(argument$store_name, argument)

      invisible(self)
    },

    add_option = function(option_strings, store_name = NULL, prefix = '-', help_string = '',
                          default = NULL, is_flag = NULL, type = NULL, choices = NULL,
                          n_args = 1) {
      option <- set_option(
        option_strings   = option_strings,
        prefix           = prefix,
        help_string      = help_string,
        default          = default,
        store_name       = store_name,
        is_flag          = is_flag,
        type             = type,
        choices          = choices,
        n_args           = n_args
      )

      self$map$put(option$store_name, option)

      invisible(self)
    },

    parse = function(args = commandArgs(trailingOnly = FALSE)) {
      ## Return named list
      ## Check args then check options
    }
  )
)

arg_parser <- function(option_list = NULL, prefix = '-', include_help = TRUE,
                       description = '') {
  Parser$new(
    option_list  = option_list,
    prefix       = prefix,
    include_help = include_help,
    description  = description
  )
}

#' Parse arguments
#'
#' This function actually parses the argument.
#' @keywords internal
parse_args <- function(x, ...) UseMethod("parse_args")

parse_args.parser <- function(x, args = commandArgs(trailingOnly = FALSE)) {
  assertthat::assert_that(
    is.list(args)
  )

  x$parse(args)
}
