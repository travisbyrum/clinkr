#' Create Argument Parser
#'
#' This function produces the argument parsing object.
#'
#' @rdname parser

Parser <- R6::R6Class(
  'parser',
  public = list(
    opts = NULL,
    exec = NULL,
    arg_names = list(),
    prefix_char = "",

    initialize = function(opts = commandArgs(), exec = opts[1],
                          prefix_char = '-') {
      self$opts <- opts
      self$exec <- exec
      self$prefix_char <- prefix_char
    },

    print_opts = function() {
      saveRDS(self$opts, '~/clinkr/data/opts_list.rds')
      print(self$opts)
      print(paste0('exec = ', self$exec))
    },

    parse = function(arg_list = self$opts, arg_names = self$arg_names) {
      scrubbed_args <- gsub(paste0(self$prefix_char, "+(.*)"), '\\1', arg_list)

      purrr::map(
        arg_names,
        function(arg) {
          is_arg_name <- is.element(arg, scrubbed_args)
          names_index <- which(scrubbed_args %in% arg)

          if (length(names_index) > 1)
            stop('More than one value for named argument given')

          arg_list[names_index + 1]
        }
      ) %>%
        setNames(arg_names)

    },
    add_option = function(..., default, is_flag, type, n_args, choices = NULL) {
      name_list <- list(...)
      list_is_names <- vapply(name_list, is.character(), logical(1))

      if (!all(list_is_names))
        stop('Invalid option name given')

      ## Assume one prefix is a short option

      default_name <- list(...)[[1]]

      arg_meta <- list(valid_names, type, flag, choices, n_args)
      sefl$arg_names[[default_name]] <- arg_meta

    }
  )
)

argument_parser <- function() {
  Parser$new()
}
