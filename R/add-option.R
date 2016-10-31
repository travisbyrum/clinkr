add_option <- function(x, ...) UseMethod("add_option")

add_option.Parser <- function(x, names, is_flag, type, n_args, choices = NULL,
                              prefix_char = '--') {
  type <-  type %>%
    match.arg(c('logical', 'numeric', 'integer', 'character', 'list'))

  assertthat::assert_that(
    is.character(name_list),
    is.logical(is_flag),
    is.numeric(n_args),
    is.character(prefix_char),
    is.list(choices),
    inherits(x, c('parser', 'R6'))
  )

  list_are_names <- vapply(names, is.character(), logical(1))

  if (!all(list_are_names))
    stop('Invalid argument name given')

  ## Assume one prefix is a short option
  ## Does an option have to contain a prefix?? assume yes

  prefix_count <- vapply(
    option_strings,
    function(nm) stringr::str_count(nm, prefix_char),
    numeric(1)
  )

  default_name <- name_list[which(max(prefix_count) %in% prefix_count)] %>%
    gsub(prefix_char, '', .)

  list(
    names   = valid_names,
    type    = type,
    flag    = flag,
    default = default,
    choices = choices,
    n_args  = n_args
  )
}
