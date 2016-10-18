context("Testing Parser Object")

test_that("Instantiate Parser Object", {
  parser <- argument_parser()

  expect_s3_class(parser, c('parser', 'R6'))
})

#
# parser <- argument_parser()
#
# args <- parser$parse_args()
#
# args$verbose
