#' Jaccard Index Calculation
#'
#' Calculate the Jaccard index between two sets.
#'
#' The Jaccard index, also known as the Jaccard similarity coefficient, measures the
#' similarity between two sets by comparing the size of their intersection to the size
#' of their union.
#'
#' @param a A vector representing the first set.
#' @param b A vector representing the second set.
#' @return A numeric value representing the Jaccard index between the two sets.
#' @export
#'
#' @examples
#' jaccard(c(1, 2, 3), c(2, 3, 4))
#'
#' jaccard(factor(c(1, 2, 3)), factor(c(2, 3, 4)))
#'
#' jaccard(c(1), c())
#'
#' @seealso
#' \code{\link{intersect}} calculates the intersection of two vectors.
#' \code{\link{length}} calculates the length of a vector.
#'
#' @rdname jaccard
jaccard <- function(a, b) {
  # Calculate the intersection of the two sets
  intersection = length(intersect(a, b))

  # Calculate the union of the two sets
  union = length(a) + length(b) - intersection

  # If both sets are empty, return '0' (no similarity)
  if (union == 0) {
    return(0)
  }

  # Calculate and return the Jaccard index
  return (intersection / union)
}


#' Generate Tidy Pairwise Sample Combinations
#'
#' This function takes a vector of samples and returns a tidy dataframe with every unique
#' pairwise combination of samples.
#'
#' @param samples A character vector containing the list of samples.
#' @param prefix A character string to be used as a prefix for the column names in the output dataframe.
#'               By default columns are named 'sample1' and 'sample2'.
#' @param include_unused_levels if samples is a factor with unused levels, should those levels be included in the pairwise matrix?
#' @return A 2-column dataframe with representing unique pairwise combinations of samples.
#'
#' @examples
#'
#' samples <- c("A", "B", "C")
#' tidy_pairwise_sample_combinations(samples)
#'
#'
#' @export
#'
#' @seealso [combn function documentation](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/combn)
#'
tidy_pairwise_sample_combinations <- function(samples, prefix = "sample", include_unused_levels = TRUE) {

  # Deal with factor inputs
  if(is.factor(samples)){
    levels <- if(include_unused_levels) levels(samples) else NULL
    samples <- as.character(samples)
    samples <- c(samples, levels)
  }

  # Ensure input is a vector
  assertions::assert_vector(samples, msg = "Samples must be either a vector or a factor")
  assertions::assert_string(prefix)

  # Create column names with the specified prefix
  colnames = paste0(prefix, c('1', '2'))

  # Ensure that samples are unique
  samples <- unique(samples)

  # If input is empty
  if(length(samples) == 0 | all(is.na(samples))){
    df_empty <- data.frame(character(0), character(0))
    colnames(df_empty) <- colnames
    return(df_empty)
  }

  # Generate all unique pairwise combinations using combn
  df_combinations <- as.data.frame(t(utils::combn(samples, 2)))

  # Set colnames
  colnames(df_combinations) <- colnames


  return(df_combinations)
}



#' Convert Tidy Data to Dissimilarity Matrix
#'
#' This function takes tidy data representing pairwise similarities or distances and converts it
#' into a dissimilarity matrix. The input tidy data is expected to have at least
#' three columns representing subject identifiers and their pairwise similarity or distance values.
#' The resulting dissimilarity matrix will have subjects as row and column names,
#' and the dissimilarity values will be populated accordingly.
#'
#' @param data A dataframe containing pairwise similarity or distance data.
#'
#' @return A dissimilarity matrix with subjects as row and column names,
#'         and dissimilarity values populated.
#'
#'
#' @examples
#' # Create a tidy dataframe with pairwise similarities
#' tidy_data <- data.frame(subject1 = c("A", "A", "B"),
#'                         subject2 = c("B", "C", "C"),
#'                         value = c(0.2, 0.5, 0.8))
#'
#' # Convert tidy data to dissimilarity matrix
#' dissimilarity_matrix <- tidy_to_matrix(tidy_data)
#'
#' @export
tidy_to_matrix <- function(data) {

  # Assertions
  assert_valid_tidy_pairwise_simdist(data)

  unique_names <- sort(union(data[[1]], data[[2]]))
  num_names <- length(unique_names)

  matrix <- matrix(0, nrow = num_names, ncol = num_names, dimnames = list(unique_names, unique_names))

  for (i in 1:nrow(data)) {
    row_name <- data[[1]][i]
    col_name <- data[[2]][i]
    value <- data[[3]][i]

    matrix[row_name, col_name] <- value
    matrix[col_name, row_name] <- value
  }

  return(matrix)
}


#' Toggle Between Tidy Pairwise Similarity and Dissimilarity Dataframes
#'
#' This function takes the output of [tidy_pairwise_jaccard_similarity()] and similar
#' and toggles the values to convert between similarity and dissimilarity representations.
#'
#' @param data A dataframe containing pairwise similarity or dissimilarity data.
#'
#'
#' @examples
#'
#' # Define Dataset
#' data <- data.frame(name = c("Harry", "Luna", "Oscar"),
#'                    trait = c("tall", "short", "tall"))
#'
#' # Create a tidy pairwise simdist dataframe
#' tidy_simdist_data <- data |>
#'   tidy_pairwise_jaccard_similarity(col_sample = "name", col_trait = "trait")
#'
#' # Toggle the values in the tidy pairwise simdist dataframe
#' tidy_toggle_simdist(tidy_simdist_data)
#'
#' @seealso \code{\link{assert_valid_tidy_pairwise_simdist}}
#'
#' @export
tidy_toggle_simdist <- function(data){
  # Assertions
  assert_valid_tidy_pairwise_simdist(data)

  data[3] <- 1 - data[[3]]

  return(data)
}


#' Convert Similarity Matrix to Distance Matrix and Vice Versa
#'
#' This function takes a matrix representing either a similarity or a distance matrix
#' and converts it to its counterpart. For similarity matrices, it subtracts each value
#' from 1 to obtain a distance matrix. For distance matrices, it performs the reverse
#' operation to obtain a similarity matrix.
#'
#' @param matrix A numeric matrix representing either a similarity or a distance matrix.
#'
#' @return A matrix of the same dimensions as the input matrix, converted to the opposite type.
#'
#'
#' @examples
#' # Create a similarity matrix
#' sim_matrix <- matrix(c(1.0, 0.8, 0.5, 0.8, 1.0, 0.6, 0.5, 0.6, 1.0), nrow = 3)
#'
#' # Convert similarity matrix to distance matrix
#' dist_matrix <- matrix_toggle_simdist(sim_matrix)
#'
#' @export
matrix_toggle_simdist <- function(matrix) {
  assertions::assert_matrix(matrix)

  converted_matrix <- 1 - matrix
  return(converted_matrix)
}

#' Assert Input is a valid of tidy pairwise similarity/dissimilarity data.frame
#'
#' This function checks the validity of a dataframe representing pairwise similarity or
#' dissimilarity data in a tidy format. It ensures that the input dataframe has at least
#' three columns representing subject identifiers and their pairwise similarity or distance values.
#' Additionally, it checks that all required columns have non-missing numeric values.
#'
#' @param data A dataframe containing pairwise similarity or dissimilarity data.
#'
#' @examples
#'
#' # Define Dataset
#' data <- data.frame(name = c("Harry", "Luna", "Oscar"),
#'                    trait = c("tall", "short", "tall"))
#'
#' # Create a tidy pairwise simdist dataframe
#' tidy_simdist_data <- data |>
#'     tidy_pairwise_jaccard_similarity(col_sample = "name", col_trait = "trait")
#'
#' # Check the validity of the tidy pairwise simdist dataframe
#' assert_valid_tidy_pairwise_simdist(tidy_simdist_data)
#'
#' @seealso \code{\link{tidy_pairwise_jaccard_similarity}}
#'
#' @export
assert_valid_tidy_pairwise_simdist <- function(data){
  assertions::assert_dataframe(data)
  assertions::assert_dataframe(data)
  assertions::assert_greater_than_or_equal_to(ncol(data), minimum = 3)
  assertions::assert_numeric(data[[3]])
  assertions::assert_no_missing(data[1:3])
}
