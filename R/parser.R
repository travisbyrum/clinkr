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
    exec        = NULL,
    prefix_char = NULL,
    arg_map = hashmap(),

    initialize = function(opts = commandArgs(), exec = opts[1],
                          prefix_char = '-') {
      self$opts <- opts
      self$exec <- exec
      self$prefix_char <- prefix_char
    },

    ### Delete this
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
    add_argument = function(..., default, is_flag, type, n_args, choices = NULL,
                          prefix_char = self$prefix_char) {
      type <-  type %>%
        match.arg(c('logical', 'numeric', 'integer', 'character', 'list'))

      assertthat::assert_that(
        is.character(name_list),
        is.logical(is_flag),
        is.numeric(n_args),
        is.character(prefix_char),
        is.list || is.character(choices)
      )

      option_strings <- list(...)
      list_are_names <- vapply(option_strings, is.character(), logical(1))

      if (!all(list_are_names))
        stop('Invalid option name given')

      ## Assume one prefix is a short option
      ## Does an option have to contain a prefix?? assume yes

      prefix_count <- vapply(
        option_strings,
        function(nm) stringr::str_count(nm, prefix_char),
        numeric(1)
      )

      default_name <- name_list[which(max(prefix_count) %in% prefix_count)] %>%
        gsub(prefix_char, '', .)

      arg_meta <- list(
        names   = valid_names,
        type    = type,
        flag    = flag,
        default = default,
        choices = choices,
        n_args  = n_args
      )

      self$arg_map$set_attribute(arg_meta)
    }
  )
)

argument_parser <- function() {
  Parser$new()
}
