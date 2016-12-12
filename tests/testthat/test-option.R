context("Testing Option Object")

### Testing option object creation  -------------------------------------------
test_that("Option Object Creation", {
  option <- set_option(
    option_strings = c('-c', '--count'),
    help_string    = 'Test help string.',
    default        = 3,
    type           = 'numeric'
  )

  expect_is(option, 'option')
  expect_named(
    option,
    c(
      'short_option',
      'long_option',
      'store_name',
      'help_string',
      'default',
      'type',
      'is_flag',
      'is_option',
      'choices',
      'n_args'
    )
  )
  expect_equal(option$short_option, '-c')
  expect_equal(option$long_option, '--count')
  expect_equal(option$store_name, 'count')
  expect_equal(option$default, 3)
  expect_equal(option$type, 'numeric')
  expect_is(option$help_string, 'character')
})

### Testing type default mismatch ---------------------------------------------
test_that("Type Default Mismatch", {
  tmp <- function() set_option(
    option_strings = c('-n', '--name'),
    help_string    = 'Test help string.',
    default        = 'a',
    type           = 'logical'
  )

  expect_error(tmp())
})

### Testing flag options ------------------------------------------------------
test_that("Flag option", {
  option <- set_option(
    option_strings = c('-v', '--verbose'),
    is_flag        = TRUE
  )

  expect_equal(option$type, 'logical')
  expect_false(option$default)
})
