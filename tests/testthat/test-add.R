test_that("add_numbers adds numeric values", {
  expect_equal(add_numbers(2, 3), 5)
  expect_equal(add_numbers(-1, 1), 0)
  expect_equal(add_numbers(2.5, 0.5), 3)
})

test_that("add_numbers rejects non-numeric input", {
  expect_error(add_numbers("a", 1))
  expect_error(add_numbers(1, NULL))
})
