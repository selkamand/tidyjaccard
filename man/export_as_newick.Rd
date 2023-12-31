% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exports.R
\name{export_as_newick}
\alias{export_as_newick}
\title{Export Hclust as Newick Format}
\usage{
export_as_newick(hclust, outfile_prefix = "", overwrite = FALSE)
}
\arguments{
\item{hclust}{The input hclust object.}

\item{outfile_prefix}{The prefix for the output file.}

\item{overwrite}{Logical flag indicating whether to overwrite the output file if it already exists.
If set to empty string ("") the function will return a string representing the newick tree}
}
\value{
Invisibly returns the path to the Newick-formatted tree UNLES outfile_prefix = "", in which case a string representation of the newick tree is returned
}
\description{
This function converts an hclust object to the Newick format and exports it to a file.
}
\examples{
\dontrun{
family
export_as_newick(my_hclust, "output_tree", overwrite = TRUE)
}

}
\keyword{internal}
