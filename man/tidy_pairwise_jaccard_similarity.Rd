% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidyjaccard.R
\name{tidy_pairwise_jaccard_similarity}
\alias{tidy_pairwise_jaccard_similarity}
\title{Compute Tidy Pairwise Similarity}
\usage{
tidy_pairwise_jaccard_similarity(
  data,
  col_sample,
  col_trait,
  include_unused_levels = TRUE
)
}
\arguments{
\item{data}{A dataframe containing samples and traits.}

\item{col_sample}{The column name representing the samples in the dataframe.}

\item{col_trait}{The column name representing the traits in the dataframe.}

\item{include_unused_levels}{Logical indicating whether to include unused factor levels
when generating pairwise combinations using \code{\link{tidy_pairwise_sample_combinations}}.
Default is \code{TRUE}.}
}
\value{
A dataframe describing Jaccard similarity of each pairwise combination of samples, as well as total set size (tidy_pairwise_simdist)
}
\description{
This function calculates the Jaccard similarity between pairs of samples in a dataframe,
considering a specified trait column. The pairwise combinations of samples are generated
using the \code{\link{tidy_pairwise_sample_combinations}} function. Jaccard similarity
is calculated for each pair based on the traits in the trait column.
}
\details{
Optionally run using multiple cores using future
}
\examples{
# Compute jaccard similarity using one core
data <- data.frame(name = c("Harry", "Luna", "Oscar"),
                   trait = c("tall", "short", "tall"))
result <- tidy_pairwise_jaccard_similarity(data, col_sample = "name", col_trait = "trait")
#

}
\seealso{
\code{\link{tidy_pairwise_sample_combinations}}
}
