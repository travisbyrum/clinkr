context("Testing Argument Object")

### Testing argument object creation  -----------------------------------------
test_that("Argument Object Creation", {
  argument <- set_argument(
    store_name       = 'count',
    help_string      = 'Test help string.',
    default          = 3,
    type             = 'numeric'
  )

  expect_is(argument, 'argument')
  expect_named(
    argument,
    c(
      "store_name",
      "help_string",
      "default",
      "type",
      "choices",
      "n_args",
      "position"
    )
  )
  expect_equal(argument$store_name, 'count')
  expect_equal(argument$default, 3)
  expect_equal(argument$type, 'numeric')
  expect_is(argument$help_string, 'character')
})


### Testing type default mismatch ---------------------------------------------
test_that("Type Default Mismatch", {
  tmp <- function() set_argument(
    store_name     = 'count',
    help_string    = 'Test help string.',
    default        = 3,
    type           = 'logical'
  )

  expect_error(tmp())
})
