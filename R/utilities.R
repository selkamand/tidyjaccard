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
#' @importFrom utils combn
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

