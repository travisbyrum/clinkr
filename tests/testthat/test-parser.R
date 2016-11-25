context('Testing Parser Object')

test_that("Create Parser Object", {
  parser <- arg_parser()
  expect_s3_class(parser, c('parser', 'R6'))
  expect_is(parser$description, 'character')
  expect_true(parser$include_help)
})
