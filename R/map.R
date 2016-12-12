#' @keywords internal
queue <- function() {
  self <- new.env(parent = emptyenv())

  self$front <- new.env(parent = emptyenv())
  self$rear <- new.env(parent = emptyenv())

  self$enqueue <- function(value) {
    temp_node <- new.env(parent = emptyenv())
    temp_node$value <- value
    temp_node$next_element <- NULL

    if (is.null(self$front$value)) {
      self$front <- temp_node
      self$rear <- temp_node
    } else {
      self$rear$next_element <- temp_node
      self$rear <- temp_node
    }
  }

  self$dequeue <- function() {
    temp_node <- self$front

    if (identical(self$front, self$rear)) {
      self$front <- NULL
      self$rear <- NULL
    } else {
      self$front <- self$front$next_element
    }

    temp_node$value
  }

  self$is_empty <- function() {
    is.null(self$front$value) && is.null(self$rear$value)
  }

  class(self) <- 'queue'
  self
}


#' @keywords internal
option_map <- function() {
  self <- new.env(parent = emptyenv())
  self$envir <- new.env(parent = emptyenv())

  self$clear <- function() {
    self$envir <- new.env(parent = emptyenv())
    invisible(self)
  }

  self$containsKey <- function(key) {
    exists(as.character(key), envir = self$envir, inherits = FALSE)
  }

  self$containsValue <- function(value) {
    !is.na(Position(function(v) value == v, self$values()))
  }

  self$entrySet <- function() {
    setNames(
      lapply(self$keySet(), function(k) self$get(k)),
      self$keySet()
    )
  }

  self$get <- function(key) {
    get0(as.character(key), envir = self$envir, inherits = FALSE, ifnotfound = NULL)
  }

  self$keySet <- function() {
    ls(self$envir)
  }

  self$put <- function(key, value) {
    key <- as.character(key)
    prev <- self$get(key)
    assign(key, value = value, envir = self$envir, inherits = FALSE)
    prev
  }

  self$putAll <- function(m) {
    switch(
      class(m),
      'list' = for (k in names(m)) self$put(k, m[[k]]),
      stop('Unsupported class `', class(m), '`', call. = FALSE)
    )
    invisible(self)
  }

  self$size <- function() {
    length(self$keySet())
  }

  self$values <- function() {
    lapply(self$keySet(), function(k) private$envir[[k]])
  }

  class(self) <- 'option_map'
  self
}
