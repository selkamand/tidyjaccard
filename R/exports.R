#' Export Hclust as Newick Format
#'
#' This function converts an hclust object to the Newick format and exports it to a file.
#'
#' @param hclust The input hclust object.
#' @param outfile_prefix The prefix for the output file.
#' @param overwrite Logical flag indicating whether to overwrite the output file if it already exists.
#'  If set to empty string ("") the function will return a string representing the newick tree
#'
#' @return Invisibly returns the path to the Newick-formatted tree UNLES outfile_prefix = "", in which case a string representation of the newick tree is returned
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' export_as_newick(my_hclust, "output_tree", overwrite = TRUE)
#' }
#'
#' @export
export_as_newick <- function(hclust, outfile_prefix = "", overwrite = FALSE){
  requireNamespace("ape", quietly = TRUE)

  # Check input arguments
  assertions::assert_class(hclust, "hclust")
  assertions::assert_string(outfile_prefix)
  assertions::assert_flag(overwrite)

  # Generate output file name
  outfile <- paste0(outfile_prefix, '.newick')

  # Check if the file already exists
  if(!overwrite && outfile_prefix != "") {
    assertions::assert_file_does_not_exist(
      outfile,
      msg = "File already exists: {outfile}. Set {.arg overwrite = TRUE} to overwrite file"
    )
  }
  else if(outfile_prefix == ""){
    message('Returning newick as a string. Set outfile_prefix to write to a file')
    phylo <- ape::as.phylo(hclust)
    return(ape::write.tree(phylo, file = ""))
  }

  phylo <- ape::as.phylo(hclust)
  # Convert hclust to phylo object


  # Write phylo object to Newick file
  ape::write.tree(phylo, file = outfile)

  # Invisibly return path to newick output
  return(invisible(outfile))
}
