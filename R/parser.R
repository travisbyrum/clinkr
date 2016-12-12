#' Create Argument Parser
#'
#' This function produces the argument parsing object.
#'
#' @examples
#'
#' args <- arg_parser() %>%
#'    add_option(c('--verbose', '-v'), is_flag = TRUE, help = 'Prints verbose output.') %>%
#'    add_option('--multiply', type = 'numeric', help = 'Multiply by given number.') %>%
#'    parse_args(args = c('--verbose', '--multiply', '3'))
#'
#' @keywords internal
Parser <- R6::R6Class(
  'parser',
  public = list(
    prefix       = NULL,
    description  = NULL,
    option_map   = NULL,
    argument_map = NULL,
    n_arguments  = 0,
    n_options    = 0,

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
      self$option_map <- option_map()
      self$argument_map <- queue()

      if (!is.null(option_list)) {
        names(option_list) <- Map(function(opt) opt$store_name, option_list)

        options <- option_list %>%
          Filter(function(opt) inherits(opt, 'option'), .)

        arguments <- option_list %>%
          Filter(function(arg) inherits(arg, 'argument'), .)

        for (i in seq_along(arguments)) {
          self$argument_map$enqueue(arguments[[i]])
        }

        self$n_arguments <- length(arguments)
        self$n_options <- length(options)
        self$option_map$putAll(options)
      }

      if (include_help) {
        help_option <- set_option(
          option_strings = c('-h', '--help'),
          is_flag        = TRUE
        )

        self$add_option(option = help_option)
      }

      invisible(self)
    },

    add_argument = function(argument) {
      assertthat::assert_that(inherits(argument, 'argument'))

      self$argument_map$enqueue(argument)
      self$n_arguments <- self$n_arguments + 1

      invisible(self)
    },

    add_option = function(option) {
      assertthat::assert_that(inherits(option, 'option'))

      self$option_map$put(option$store_name, option)
      self$n_options <- self$n_options + 1

      invisible(self)
    },

    parse = function(args = commandArgs(trailingOnly = TRUE)) {
      if (!length(args))
        stop('No arguments provided.')

      options <- self$option_map$entrySet()
      arguments <- purrr::map(
        seq_len(self$n_arguments),
        function(i) {
          arg <- self$argument_map$dequeue()
          arg$position <- i
          arg
        }
      ) %>%
        setNames(purrr::map_chr(., function(a) a$store_name))

      parsed_options <- purrr::map(
        options,
        function(opt) {
          if (opt$store_name == 'help')
            return(NULL)

          short_opt <- opt$short_option
          long_opt <- opt$long_option

          short_position <- NULL
          long_position <- NULL
          try(short_position <- which(grepl(short_opt, args)), silent = TRUE)
          try(long_position <- which(grepl(long_opt, args)), silent = TRUE)

          if (length(short_position))
            return_value <- ifelse(opt$is_flag, TRUE, args[seq(short_position + 1, short_position + opt$n_args)])

          if (length(long_position))
            return_value <- ifelse(opt$is_flag, TRUE, args[seq(long_position + 1, long_position + opt$n_args)])

          if (!length(short_position) && !length(long_position))
            return_value <- opt$default

          args <<- dplyr::setdiff(args, c(return_value, long_opt, short_opt))

          return_value <- switch(
            opt$type,
            'logical'   = as.logical(return_value),
            'numeric'   = as.numeric(return_value),
            'character' = as.character(return_value),
            'list'      = as.list(return_value)
          )
        }
      ) %>%
        setNames(names(options)) %>%
        Filter(function(opt) !is.null(opt), .)

      parsed_arguments <- purrr::map(
        arguments,
        function(arg) {
          return_value <- args[seq(arg$position, arg$position + arg$n_args - 1)]

          if (!is_truthy(return_value))
            return_value <- arg$default

          args <<- dplyr::setdiff(args, return_value)

          return_value <- switch(
            arg$type,
            'logical'   = as.logical(return_value),
            'numeric'   = as.numeric(return_value),
            'character' = as.character(return_value),
            'list'      = as.list(return_value)
          )
        }
      ) %>%
        setNames(names(arguments)) %>%
        Filter(function(arg) !is.null(arg), .)

      parsed_options %>%
        append(parsed_arguments)
    }
  )
)

#' Create Parser Object
#'
#' This function is a wrapper around the R6 Parser class to enable parser
#' creation and adding arguments/options through piping.
#'
#' @export
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
#' This function parses the argument returning a named list.
#'
#' @export
parse_args <- function(x, ...) UseMethod("parse_args")

#' @export
parse_args.parser <- function(x, args) {
  assertthat::assert_that(
    is.list(args) || is.character(args)
  )

  x$parse(args)
}
