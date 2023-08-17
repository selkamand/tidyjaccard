#' Visualize Dendrogram using ggraph
#'
#' This function creates a visual representation of a dendrogram using the ggraph package.
#'
#' @param hclust The hierarchical clustering object (class 'hclust') to visualize.
#' @param annotations A dataframe containing node annotations.
#' @param col_label The name of the column in the annotations dataframe that contains node labels.
#' @param col_sample The name of the column in the annotations dataframe to be used for sampling.
#' @param col_colour The name of the column in the annotations dataframe that contains color information.
#' @param col_shape The name of the column in the annotations dataframe that contains shape information.
#' @param col_tooltip The name of the column in the annotations dataframe that contains tooltip information.
#' @param col_data_id The name of the column in the annotations dataframe that contains data IDs.
#' @param circular A logical value indicating whether to create a circular dendrogram.
#' @param label_leaf_only A logical value indicating whether to label only leaf nodes.
#' @param draw_labels A logical value indicating whether to
#' @param padding_bottom How much padding to add to the bottom of the plot (used to make space for text)
#' @return A ggraph plot object.
#'
#' @export
#' @importFrom rlang .data
visualise_dendrogram_ggraph <- function(hclust, annotations = NULL, col_label = NULL, col_sample = NULL, col_colour = NULL, col_shape = NULL, col_tooltip = NULL, col_data_id = NULL, col_classification = NULL, circular = FALSE, label_leaf_only = FALSE, draw_labels = FALSE, padding_bottom = 0.6, legend_position = "bottom", leaf_node_size = 1 ){

  # Namespace Checks
  requireNamespace("ggraph", quietly = TRUE)
  requireNamespace("tidygraph", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("ggplot2", quietly = TRUE)
  requireNamespace("ggiraph", quietly = TRUE)

  # Input Class Assertions
  assertions::assert(inherits(hclust, what = "hclust") | inherits(hclust, what = "dendrogram"), msg = "{.arg hclust} must be a {.strong hclust} or {.strong dendrogram} object. Not a {.bold {class(hclust)}}")
  assertions::assert_flag(draw_labels)
  assertions::assert_number(padding_bottom)

  # assertions::assert_class(hclust, class = c("hclust"))

  # Convert hclust to a tidygraph object
  tbl_graph  <- tidygraph::as_tbl_graph(hclust)

  # Add node IDs to the tidygraph object
  tbl_graph <- tbl_graph |>
    tidygraph::activate("nodes") |>
    tidygraph::mutate(node_id = paste0("Node ", seq_len(tidygraph::n())))

  # Handle annotations
  if(!is.null(annotations)){
    assertions::assert_dataframe(annotations)
    assertions::assert_greater_than_or_equal_to(x = ncol(annotations), minimum = 2, msg = "annotations dataframe must have at least two columns")
    assertions::assert_no_duplicates(annotations)

    # Rename label column in annotations
    annotations <- tidygraph::rename(annotations, label = {{col_label}})

    # Handle missing col_label
    if(!"label" %in% colnames(annotations)){
      message("col_label argument was not supplied. Assuming first column corresponds to node labels")
      colnames(annotations)[1] <- "label"
    }

    # Join annotations to the tidygraph object
    tbl_graph <- tbl_graph |>
      tidygraph::activate("nodes") |>
      tidygraph::left_join(y = annotations, by = "label", multiple = "error")

    # Set default col_sample if not provided
    if(is.null(col_sample)){
      col_sample = colnames(annotations)[1]
    }

  }

  max_label_nchar = tbl_graph |>
    tidygraph::activate("nodes") |>
    tidygraph::as_tibble() |>
    dplyr::pull(.data[["label"]]) |>
    nchar() |>
    max(na.rm = TRUE)

  label_nudge_y = -0.2
  text_size = 5

  if(draw_labels)
    expansion = ggplot2::expansion(add = c(padding_bottom + -label_nudge_y + max_label_nchar * text_size * 0.02, 0.1))
  else
    expansion = ggplot2::waiver()

  # Create the ggraph plot
  gg <- ggraph::ggraph(tbl_graph, layout = 'dendrogram', circular = circular) +
    ggraph::geom_edge_elbow() +
    ggiraph::geom_point_interactive(
      data = ~ .x[.x[['members']] == 1,],
      ggplot2::aes(
        x = .data[["x"]], y = .data[["y"]],
        color = {{ col_colour }},
        tooltip = if(!is.null( {{col_tooltip}} )) {{ col_tooltip }} else paste0(.data[["label"]], '<br>', .data[["node_id"]]),
        data_id = if(!is.null( {{col_data_id }} )) {{ col_data_id }} else .data[["node_id"]],
        shape = {{ col_shape }}
      ), size = leaf_node_size) +
    ggplot2::scale_y_continuous(expand = expansion) +
    ggplot2::theme_void() +
    ggplot2::scale_shape(solid = TRUE)

  # Add additional points for non-leaf nodes if label_leaf_only is FALSE
  if(!label_leaf_only){
    gg <- gg +  ggiraph::geom_point_interactive(
      data =  ~  .x[.x[['members']] != 1,],
      ggplot2::aes(
        x = .data[["x"]], y = .data[["y"]],
        tooltip =  paste0(.data[["node_id"]], "<br>Children: ", .data[["members"]]),
        data_id = .data[["node_id"]]
      ), size = 0.2)
  }

  # Draw Leaf labels
  if(draw_labels){
    gg <- gg + ggraph::geom_node_text(check_overlap = FALSE, ggplot2::aes(label = .data[["label"]]), hjust = 1, angle = 90, nudge_y = label_nudge_y, size = text_size)
  }

  # Fix Coord system if circular
  if(circular){
   gg <- gg + ggplot2::coord_fixed()
  }

  # Determine legend position

  gg <- gg + ggplot2::theme(legend.position = legend_position)

  return(gg)
}

#' Make a ggplot2 Visualization Interactive
#'
#' This function takes a ggplot2 plot and makes it interactive using the ggiraph package.
#'
#' @param gg A ggplot2 plot object to be made interactive.
#' @param width_svg Width of the SVG container for the interactive plot.
#' @param height_svg Height of the SVG container for the interactive plot.
#' @inheritDotParams ggiraph::girafe
#'
#' @return An interactive ggiraph plot object.
#'
#'
#' @export
visualisation_make_interactive <- function(gg, width_svg = 6, height_svg = 3, ...) {
  requireNamespace("ggiraph", quietly = TRUE)

  # Make the ggplot2 plot interactive using ggiraph
  ggi <- ggiraph::girafe(ggobj = gg, width_svg = width_svg, height_svg = height_svg, ...)

  return(ggi)
}

