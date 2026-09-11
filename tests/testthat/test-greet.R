test_that("greet builds a greeting", {
  expect_equal(greet("R"), "Hello, R!")
  expect_equal(greet(), "Hello, world!")
})

test_that("greet rejects invalid input", {
  expect_error(greet(c("a", "b")))
  expect_error(greet(1))
})
