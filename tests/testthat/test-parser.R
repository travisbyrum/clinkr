context('Testing Parser Object')

### Test parser creation ------------------------------------------------------
test_that("Create Parser Object", {
  parser <- arg_parser()

  expect_s3_class(parser, c('parser', 'R6'))
  expect_is(parser$description, 'character')
  expect_equal(parser$n_options, 1)
  expect_equal(parser$n_arguments, 0)
})

### Test adding options and arguments -----------------------------------------
test_that("Add Option and Argument to Parser", {
  parser <- arg_parser()

  option <- set_option(
    option_strings = c('-c', '--count'),
    help_string    = 'Test help string.',
    default        = 3,
    type           = 'numeric'
  )

  argument <- set_argument(
    store_name       = 'count',
    help_string      = 'Test help string.',
    default          = 3,
    type             = 'numeric'
  )

  parser$add_option(option)
  parser$add_argument(argument)

  expect_equal(parser$n_options, 2)
  expect_equal(parser$n_arguments, 1)
})

### Initialize with option list and parse -------------------------------------
test_that("Create Parser with options and parse", {
  test_args <- c('1', '--verbose')

  option_list <- list(
    set_option(
      option_strings = c('-v', '--verbose'),
      help_string    = 'Test help string.',
      is_flag        = TRUE,
      type           = 'numeric'
    ),
    set_argument(
      store_name       = 'count',
      help_string      = 'Test help string.',
      default          = 3,
      type             = 'numeric'
    )
  )

  parser <- arg_parser(option_list = option_list)
  parsed_args <- parser$parse(args = test_args)

  expect_equal(parser$n_options, 2)
  expect_equal(parser$n_arguments, 1)
  expect_named(parsed_args, c("verbose", "count"))
  expect_true(parsed_args$verbose)
  expect_equal(parsed_args$count, 1)
})

### Test parsing with pipe ----------------------------------------------------
test_that("Parsing with pipe", {
  args <- arg_parser() %>%
    add_option(c('--verbose', '-v'), is_flag = TRUE, help = 'Prints verbose output.') %>%
    add_option('--multiply', type = 'numeric', help = 'Multiply by given number,') %>%
    parse_args(args = c('--verbose', '--multiply', '3'))

  expect_named(args, c("multiply", "verbose"))
  expect_true(args$verbose)
  expect_equal(args$multiply, 3)
})


