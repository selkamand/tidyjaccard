#' Smith vs Johnson Family
#'
#' Simulated dataset describing physical traits individual members of two different families
#'
#' - Family 1: Smith (5 members)
#'
#' - Family 2: Johnson (3 members)
#'
#' Each row represents one physical feature possessed by one person.
#' Each person can appear numerous times since each person has multiple physical features.
#'
#' @format ## `family`
#' A data frame with 55 rows and 2 variables:
#' \describe{
#'   \item{name}{name of person}
#'   \item{trait}{physical trait of the person}
#'   ...
#' }
#' @source Simulated
"family"


#' Smith vs Johnson Family
#'
#' Dataset describing metadata about individual members of two different families.
#' Used to change colours, shapes, etc.  in dendograms
#'
#' - Family 1: Smith (5 members)
#'
#' - Family 2: Johnson (3 members)
#'
#'
#' Each person appears in the dataset exactly once
#'
#' @format ## `family`
#' A data frame with 8 rows and 4 variables:
#' \describe{
#'   \item{name}{name of person}
#'   \item{family}{which family does this person belong to}
#'   \item{traits}{comma-delimited list of physical traits}
#'   \item{tooltip}{text that we'll use as a tooltip for leaf nodes}
#'   ...
#' }
#' @source Simulated
"family_member_annotations"
