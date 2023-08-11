dendogram_ggraph <- function(dendrogram, annotations = NULL, col_sample = NULL, col_colour = NULL, col_shape = NULL, circular = FALSE, label_leaf_only = TRUE, interactive = TRUE){

  # Namespace Checks
  requireNamespace("ggraph", quietly = TRUE)
  requireNamespace("tidygraph", quietly = TRUE)
  # requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("ggplot2", quietly = TRUE)
  requireNamespace("ggiraph", quietly = TRUE)

  # Input Class Assertions
  assertions::assert_class(dendrogram, class = "dendrogram")

  tbl_graph  <- tidygraph::as_tbl_graph(dendrogram)


  if(!is.null(annotations)){
    assertions::assert_dataframe(annotations)
    assertions::assert_no_duplicates(annotations)
    assertions::assert_names_include(annotations, names = "label")
    tbl_graph <- tbl_graph |>
      tidygraph::activate("nodes") |>
      tidygraph::left_join(y = annotations, by = "label")
  }


  gg <- ggraph::ggraph(tbl_graph, layout = 'dendrogram', height = height, circular=circular) +
    ggraph::geom_edge_elbow() +
    ggiraph::geom_point_interactive(
      data =  ~ if(label_leaf_only) {.x[.x[['label']] != "",] } else {.x},
      ggplot2::aes(
        x = x, y = y,
        color = sub(x=label, pattern = ".* ", replacement = ""),
        tooltip = label
        ), size = 2) +
    # ggraph::geom_node_point(
    #   data = ~ if(label_leaf_only) .x[.x[['label']] != "",] else .x,
    #   ggplot2::aes(color = sub(x=label, pattern = ".* ", replacement = "")), size = 5) +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = "none")

  if(interactive) { ggi <- ggiraph::girafe(ggobj = gg); return(ggi)}

  return(gg)
}

dendogram_to_tbl_graph <- function(dendrogram){
  #requireNamespace("ggraph", quietly = TRUE)
  requireNamespace("tidygraph", quietly = TRUE)

  assertions::assert_class(dendrogram, class = "dendrogram")

  tbl_graph <- tidygraph::as_tbl_graph(dendrogram)

  return(tbl_graph)
}
