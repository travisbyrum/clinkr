#' @keywords internal
HashMap <- R6::R6Class(
  'HashMap',
  public = list(
    initialize = function() {
      private$envir <- new.env(parent = emptyenv())
      invisible(self)
    },
    clear = function() {
      private$envir <- new.env(parent = emptyenv())
      invisible(self)
    },
    containsKey = function(key) {
      exists(as.character(key), envir = private$envir, inherits = FALSE)
    },
    containsValue = function(value) {
      !is.na(Position(function(v) value == v, self$values()))
    },
    entrySet = function() {
      setNames(
        lapply(self$keySet(), function(k) self$get(k)),
        self$keySet()
      )
    },
    get = function(key) {
      get0(as.character(key), envir = private$envir, inherits = FALSE, ifnotfound = NULL)
    },
    isEmpty = function() {
      length(self$keySet()) == 0
    },
    keySet = function() {
      ls(private$envir)
    },
    put = function(key, value) {
      key <- as.character(key)
      prev <- self$get(key)
      assign(key, value = value, envir = private$envir, inherits = FALSE)
      prev
    },
    putAll = function(m) {
      switch(
        class(m),
        'list' = for (k in names(m)) self$put(k, m[[k]]),
        stop('Unsupported class `', class(m), '`', call. = FALSE)
      )
      invisible(self)
    },
    remove = function(key) {
      prev <- self$get(key)
      rm(as.character(key), envir = private$envir, inherits = FALSE)
      prev
    },
    size = function() {
      length(self$keySet())
    },
    values = function() {
      lapply(self$keySet(), function(k) private$envir[[k]])
    }
  ),
  private = list(
    envir = NULL,
    deep_clone = function(name, value) {
      if (name == 'envir') {
        list2env(
          as.list.environment(value, all.names = TRUE),
          parent = emptyenv()
        )
      } else {
        value
      }
    }
  )
)
