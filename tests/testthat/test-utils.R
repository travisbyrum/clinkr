context("Testing Utils")

### Testing is_truthy ---------------------------------------------------------
test_that("is_truthy", {
  expect_false(is_truthy(NA))
  expect_false(is_truthy(NULL))
  expect_false(is_truthy(character(0)))
  expect_false(is_truthy(logical(0)))
  expect_false(is_truthy(numeric(0)))
  expect_false(is_truthy(''))
})

### Testing null default pipe -------------------------------------------------
test_that("pipe", {
  test_one <- 'a' %||% NULL
  test_two <- NULL %||% 'a'

  expect_equal(test_one, 'a')
  expect_equal(test_two, 'a')
})
