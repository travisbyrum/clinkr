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
    arg_names = NULL,
    prefix_char = "",

    initialize = function(opts = commandArgs(), exec = opts[1],
                          prefix_char = '-') {
      self$opts <- opts
      self$exec <- exec
      self$prefix_char <- prefix_char
    },

    add_option = function(...) {
      names <- list(...)
      print(self$opts)

    },

    print_opts = function() {
      saveRDS(self$opts, '~/clinkr/data/opts_list.rds')
      print(self$opts)
      print(paste0('exec = ', self$exec))
    },

    parse = function() {
      scrubbed_args <- gsub(paste0(self$prefix_char, "+(.*)"), '\\1', self$opts)

      purrr::map(
        self$arg_names,
        function(arg) {
          is_arg_name <- is.element(arg, scrubbed_args)
          names_index <- which(scrubbed_args %in% arg)

          if (length(names_index) > 1)
            stop('More than one value for named argument give')

          self$opts[names_index + 1]
        }
      ) %>%
        setNames(self$arg_names)

    }
  )
)
