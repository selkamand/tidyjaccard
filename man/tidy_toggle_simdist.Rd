% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities.R
\name{tidy_toggle_simdist}
\alias{tidy_toggle_simdist}
\title{Toggle Between Tidy Pairwise Similarity and Dissimilarity Dataframes}
\usage{
tidy_toggle_simdist(data)
}
\arguments{
\item{data}{A dataframe containing pairwise similarity or dissimilarity data.}
}
\description{
This function takes the output of \code{\link[=tidy_pairwise_jaccard_similarity]{tidy_pairwise_jaccard_similarity()}} and similar
and toggles the values to convert between similarity and dissimilarity representations.
}
\examples{

# Define Dataset
data <- data.frame(name = c("Harry", "Luna", "Oscar"),
                   trait = c("tall", "short", "tall"))

# Create a tidy pairwise simdist dataframe
tidy_simdist_data <- data |>
  tidy_pairwise_jaccard_similarity(col_sample = "name", col_trait = "trait")

# Toggle the values in the tidy pairwise simdist dataframe
tidy_toggle_simdist(tidy_simdist_data)

}
\seealso{
\code{\link{assert_valid_tidy_pairwise_simdist}}
}
