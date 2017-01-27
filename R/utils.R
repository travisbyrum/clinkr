#' @importFrom stats setNames
#'
#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

### default pipe ------------------------------------------------------------------------
`%||%` <- function(a, b) if (is.null(a)) b else a

### is truthy ---------------------------------------------------------------------------
is_truthy <- function(x) {
  if (is.null(x))
    return(FALSE)

  !identical(is.na(x), TRUE) &&
    !identical(length(x), 0L) &&
    !identical(nchar(x), 0L) &&
    !identical(x, FALSE)
}

### checking flag type ------------------------------------------------------------------
is_short_flag <- function(args, prefix = '-') {
  grepl(paste0('^', prefix, '{1}\\w'), args)
}

is_long_flag <- function(args, prefix = '-') {
  grepl(paste0('^', prefix, '{2}\\w'), args)
}

### expand short flags into separated arguments and remove duplicates -------------------
scrub_args <- function(args, prefix = '-') {
  args <- purrr::map(
    as.list(args),
    function(arg) {
      if (is_short_flag(arg, prefix = prefix)) {
        arg <- stringr::str_match_all(arg, '\\w{1}') %>%
          unlist() %>%
          as.character() %>%
          paste0(prefix, .)
      }

      arg
    }
  ) %>%
    unlist()

  args[!duplicated(args)]
}
