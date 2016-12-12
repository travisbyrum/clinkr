context("Testing Data Structures")

### Testing queue object ------------------------------------------------------
test_that("Queue Object", {
  argument_first <- set_argument(
    store_name  = 'arg1',
    help_string = 'Test help string.',
    default     = 3,
    type        = 'numeric'
  )

  argument_second <- set_argument(
    store_name  = 'arg2',
    help_string = 'Test help string.',
    default     = "a",
    type        = 'character'
  )

  temp <- queue()
  temp$enqueue(argument_first)
  temp$enqueue(argument_second)

  first_out <- temp$dequeue()
  second_out <- temp$dequeue()

  expect_is(temp, 'queue')
  expect_equal(first_out$store_name, 'arg1')
  expect_equal(second_out$store_name, 'arg2')
  expect_equal(first_out$default, 3)
  expect_equal(second_out$default, 'a')
  expect_true(temp$is_empty())
})

### Testing option map --------------------------------------------------------
test_that("Option map", {

  option_list <- list(
    set_option(
      option_strings = c('-c', '--count'),
      help_string    = 'Test help string.',
      default        = 3,
      type           = 'numeric'
    ),
    set_option(
      option_strings = c('--verbose', '-v'),
      is_flag = TRUE,
      help_string    = 'Test help string.'
    )
  )

  names(option_list) <- Map(function(opt) opt$store_name, option_list)

  temp <- option_map()
  temp$putAll(option_list)

  expect_equal(temp$size(), 2)
  expect_true(temp$containsKey('count'))
  expect_true(temp$containsKey('verbose'))
  expect_is(temp$get('verbose'), 'option')
  expect_equal(temp$get('verbose'), option_list[[2]])
  expect_is(temp$get('count'), 'option')
  expect_equal(temp$get('count'), option_list[[1]])
  expect_equal(temp$keySet(), c('count', 'verbose'))
  expect_is(temp$entrySet(), 'list')
})
