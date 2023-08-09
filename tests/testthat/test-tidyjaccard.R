csv_path <- system.file(package = "tidyjaccard", "smith_and_johnson.csv")
data <- read.csv(csv_path)
col_sample <- "name"
col_trait <- "trait"

test_that("tidy_pairwise_jaccard_similarity works correctly", {

  result <- tidy_pairwise_jaccard_similarity(data, col_sample, col_trait)

  # Make assertions on the structure and content of the result
  expect_s3_class(result, "data.frame")
  expect_true(all(c("name1", "name2", "jaccard", "set_size") %in% colnames(result)))

  expect_true(is.numeric(result[["jaccard"]]))
  expect_true(is.numeric(result[["set_size"]]))

  # Verify specific expected values


  # # Harry Smith and Luna Smith
  expect_equal(result$jaccard[result$name1 == "Harry Smith" & result$name2 == "Luna Smith"], 0.15384615384615385, tolerance = 1e-6)
  expect_equal(result$set_size[result$name1 == "Harry Smith" & result$name2 == "Luna Smith"], 13)
  #
  # Oscar Smith and Liam Johnson
  expect_equal(result$jaccard[result$name1 == "Oscar Smith" & result$name2 == "Liam Johnson"], 0, tolerance = 1e-6)
  expect_equal(result$set_size[result$name1 == "Oscar Smith" & result$name2 == "Liam Johnson"], 15)

  # Test all jaccards are correct
  expect_equal(result$jaccard, c(0.153846153846154, 0.230769230769231, 0.133333333333333, 0.181818181818182,
                                 0, 0.0714285714285714, 0.166666666666667, 0.0714285714285714,
                                 0.454545454545455, 0.2, 0.0909090909090909, 0, 0.0833333333333333,
                                 0.133333333333333, 0.181818181818182, 0, 0, 0, 0.166666666666667,
                                 0.0769230769230769, 0.142857142857143, 0.153846153846154, 0.111111111111111,
                                 0.0909090909090909, 0.222222222222222, 0.333333333333333, 0.375,
                                 0.625), tolerance = 1e-6)

})
test_that("tidy_pairwise_jaccard_similarity handles unused levels correctly", {
# Test that unused levels are handled appropriately based on include_unused_levels
  data2 <- data

  data2[[col_sample]] <- factor(data2[[col_sample]], levels = unique(c(data2[[col_sample]], "bob")))

  result <- tidy_pairwise_jaccard_similarity(data2, col_sample, col_trait, include_unused_levels = TRUE)
  expect_true("bob" %in% result[['name2']])

  result <- tidy_pairwise_jaccard_similarity(data2, col_sample, col_trait, include_unused_levels = FALSE)
  expect_false("bob" %in% result[['name2']])
})
