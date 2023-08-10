#' Compute Tidy Pairwise Similarity
#'
#' This function calculates the Jaccard similarity between pairs of samples in a dataframe,
#' considering a specified trait column. The pairwise combinations of samples are generated
#' using the \code{\link{tidy_pairwise_sample_combinations}} function. Jaccard similarity
#' is calculated for each pair based on the traits in the trait column.
#'
#' @param data A dataframe containing samples and traits.
#' @param col_sample The column name representing the samples in the dataframe.
#' @param col_trait The column name representing the traits in the dataframe.
#' @param include_unused_levels Logical indicating whether to include unused factor levels
#'        when generating pairwise combinations using \code{\link{tidy_pairwise_sample_combinations}}.
#'        Default is \code{TRUE}.
#'
#' @return A dataframe describing Jaccard similarity of each pairwise combination of samples, as well as total set size (tidy_pairwise_simdist)
#'
#'
#' @examples
#' data <- data.frame(name = c("Harry", "Luna", "Oscar"),
#'                    trait = c("tall", "short", "tall"))
#' result <- tidy_pairwise_jaccard_similarity(data, col_sample = "name", col_trait = "trait")
#'
#' @export
#'
#' @seealso \code{\link{tidy_pairwise_sample_combinations}}
#'
tidy_pairwise_jaccard_similarity <- function(data, col_sample, col_trait, include_unused_levels = TRUE) {
  # Assertions
  assertions::assert_dataframe(data)
  assertions::assert_string(col_sample)
  assertions::assert_string(col_trait)
  assertions::assert_names_include(data, names = col_sample)
  assertions::assert_names_include(data, names = col_trait)
  assertions::assert_no_missing(data[col_sample])
  assertions::assert_no_missing(data[col_trait])

  # Get unique samples (deduplication and unused levels handled by tidy_pairwise_sample_combinations)
  samples = data[[col_sample]]

  # Generate Pairwise Dataframe (handles deduplication and unused factor levels)
  df = tidy_pairwise_sample_combinations(samples, prefix = col_sample, include_unused_levels = include_unused_levels)

  # Compute Jaccard similarity
  ls_jaccard <- purrr::map2(.x = df[[1]], .y = df[[2]],
                            .f = function(s1, s2) {
                              # Select traits for the given samples
                              s1traits <- data[[col_trait]][s1 == data[[col_sample]]]
                              s2traits <- data[[col_trait]][s2 == data[[col_sample]]]

                              # Calculate Jaccard similarity
                              jaccard_similarity <- jaccard(s1traits, s2traits)
                              set_size <- length(unique(c(s1traits, s2traits)))

                              return(data.frame("jaccard" = jaccard_similarity, "set_size" = set_size))
                            },
                            .progress = TRUE)

  df_jaccard = purrr::list_rbind(ls_jaccard)

  df <- cbind(df, df_jaccard)

  return(df)
}
