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
    opts        = NULL,
    arg_map = hashmap(),

    initialize = function(opts = commandArgs(trailingOnly = TRUE)) {
      self$opts <- opts
    },

    parse = function(opts = self$opts, arg_map = self$arg_map) {
      ## Return named list
    }
  )
)

argument_parser <- function() {
  Parser$new()
}

#' Parse arguments
#'
#' This function actually parses the argument.
#' @keywords internal

parse_args <- function(x, ...) UseMethod("parse_args")

parse_args.Parser <- function(x, ...) {
  assertthat::assert_that(
    inherits(x, c('parser', 'R6'))
  )

  ### Return named list
  x$parse()
}

