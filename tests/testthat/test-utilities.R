# Jaccard Index ---------------------------------------
# Define your test cases
test_that("Jaccard index is computed correctly", {
  # Test 1: 2 intersecting / 4
  expect_equal(jaccard(c(1, 2, 3), c(2, 3, 4)), 0.5)

  # Test 2: No overlap
  expect_equal(jaccard(c(1, 2, 3), c(4, 5, 6)), 0)

  # Test 3: Complete Overlap
  expect_equal(jaccard(c(1, 2, 3), c(1, 2, 3)), 1)

  # Test 4: 3 intersecting / 4 total
  expect_equal(jaccard(c(1, 2, 3), c(1, 2, 3, 4)), 0.75)

  # Test 5: 1 intesecting / 4 total
  expect_equal(jaccard(c(1, 2), c(2, 3, 4)), 0.25)

  # Test 6: No overlap
  expect_equal(jaccard(c(1), c(2)), 0)

  # Test 7: No overlap
  expect_equal(jaccard(c(1, 2, 3), c()), 0)

  # Test 8: No overlap
  expect_equal(jaccard(c(), c(1, 2, 3)), 0)

  # Test 9: Both empty
  expect_equal(jaccard(c(), c()), 0) # Jaccard similarity on two empty sets doesnt make sense (divide by zero)

  # Test 10: large sets no overlap
  expect_equal(jaccard(c(1, 2, 3, 4, 5), c(6, 7, 8, 9, 10)), 0)
})


# Define your test cases using factors
test_that("Jaccard index with factors is computed correctly", {
  # Test 1: 2 intersecting / 4 total
  expect_equal(jaccard(factor(c(1, 2, 3)), factor(c(2, 3, 4))), 0.5)

  # Test 2: No overlap
  expect_equal(jaccard(factor(c(1, 2, 3)), factor(c(4, 5, 6))), 0)

  # Test 3: Complete Overlap
  expect_equal(jaccard(factor(c(1, 2, 3)), factor(c(1, 2, 3))), 1)

  # Test 4: 3 intersecting / 4 total
  expect_equal(jaccard(factor(c(1, 2, 3)), factor(c(1, 2, 3, 4))), 0.75)

  # Test 5: 1 intersecting / 10 total
  expect_equal(jaccard(factor(c(1, 2, 3, 4, 5)), factor(c(2, 6, 7, 8, 9, 10))), 0.1)

  # Test 6: 0 values intesecting but 5 levels intersect. Should ignore the levels
  expect_equal(jaccard(factor(1, levels = 1:5), factor(2, levels = 1:5)), expected = 0)
})


# Tidy Pairwise Sample Combinations ---------------------------------------
test_that("tidy_pairwise_sample_combinations function works", {
  # Test with example provided
  samples <- c("A", "B", "C")
  result <- tidy_pairwise_sample_combinations(samples)
  expected <- data.frame(sample1 = c("A", "A", "B"), sample2 = c("B", "C", "C"))
  expect_equal(result, expected)
})

test_that("tidy_pairwise_sample_combinations handles non-unique samples", {
  samples <- c("A", "B", "A", "C")
  result <- tidy_pairwise_sample_combinations(samples)
  expected <- data.frame(sample1 = c("A", "A", "B"), sample2 = c("B", "C", "C"))
  expect_equal(result, expected)
})

test_that("tidy_pairwise_sample_combinations throws error for non-vector inputs", {
  non_vector_input <- list("A", "B", "C")
  expect_error(tidy_pairwise_sample_combinations(non_vector_input))
})

test_that("tidy_pairwise_sample_combinations empty input", {
  samples <- character(0)
  result <- tidy_pairwise_sample_combinations(samples)
  expected <- data.frame(sample1 = character(0), sample2 = character(0))
  expect_equal(result, expected)
})

test_that("tidy_pairwise_sample_combinations function works with unused levels", {
  # Test with example provided
  samples <- factor(c("A", "B"), levels = c("A", "B", "C"))

  # If include_unused_levels = TRUE
  result <- tidy_pairwise_sample_combinations(samples, include_unused_levels = TRUE)

  expected <- data.frame(sample1 = c("A", "A", "B"), sample2 = c("B", "C", "C"))
  expect_equal(result, expected)

  # If include_unused_levels = FALSE
  result <- tidy_pairwise_sample_combinations(samples, include_unused_levels = FALSE)
  expected <- data.frame(sample1 = c("A"), sample2 = c("B"))
  expect_equal(result, expected)

})


# Tidy to Matrix ----------------------------------------------------------

test_that("Tidy sim/dist data is correctly converted to a matrix", {
  # Create a simple tidy dataframe with pairwise values
  tidy_data <- data.frame(subject1 = c("A", "A", "B"),
                          subject2 = c("B", "C", "C"),
                          value = c(0.2, 0.5, 0.8))

  # Convert tidy data to a matrix
  result_matrix <- tidy_to_matrix(tidy_data)

  # Check the expected values in the resulting matrix
  expect_equal(result_matrix["A", "B"], 0.2)
  expect_equal(result_matrix["B", "A"], 0.2)
  expect_equal(result_matrix["A", "C"], 0.5)
  expect_equal(result_matrix["C", "A"], 0.5)
  expect_equal(result_matrix["B", "C"], 0.8)
  expect_equal(result_matrix["C", "B"], 0.8)
})

# Matrix Inversion --------------------------------------------------------

test_that("Inverting similarity to distance matrix works correctly", {
  sim_matrix <- matrix(c(1.0, 0.8, 0.5, 0.8, 1.0, 0.6, 0.5, 0.6, 1.0), nrow = 3)
  dist_matrix <- matrix_toggle_simdist(sim_matrix)

  expect_equal(dist_matrix, matrix(c(0.0, 0.2, 0.5, 0.2, 0.0, 0.4, 0.5, 0.4, 0.0), nrow = 3))
})

test_that("Inverting distance to similarity matrix works correctly", {
  dist_matrix <- matrix(c(0.0, 0.2, 0.5, 0.2, 0.0, 0.4, 0.5, 0.4, 0.0), nrow = 3)
  sim_matrix <- matrix_toggle_simdist(dist_matrix)

  expect_equal(sim_matrix, matrix(c(1.0, 0.8, 0.5, 0.8, 1.0, 0.6, 0.5, 0.6, 1.0), nrow = 3))
})

test_that("Inverting an empty matrix returns an empty matrix", {
  empty_matrix <- matrix(numeric(0), nrow = 0, ncol = 0)
  inverted_matrix <- matrix_toggle_simdist(empty_matrix)

  expect_equal(inverted_matrix, empty_matrix)
})

test_that("Inverted matrix preserves row and column names", {
  sim_matrix <- matrix(c(1.0, 0.8, 0.5, 0.8, 1.0, 0.6, 0.5, 0.6, 1.0), nrow = 3,
                       dimnames = list(c("A", "B", "C"), c("A", "B", "C")))

  inverted_matrix <- matrix_toggle_simdist(sim_matrix)

  expect_equal(rownames(inverted_matrix), rownames(sim_matrix))
  expect_equal(colnames(inverted_matrix), colnames(sim_matrix))
})

test_that("Converted matrix is square", {
  sim_matrix <- matrix(c(1.0, 0.8, 0.5, 0.8, 1.0, 0.6, 0.5, 0.6, 1.0), nrow = 3)
  converted_matrix <- matrix_toggle_simdist(sim_matrix)

  expect_true(all(dim(converted_matrix)[1] == dim(converted_matrix)[2]),
              "Converted matrix should be square")
})

