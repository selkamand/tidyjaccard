benchmarking <- function(data = tidyjaccard::family, const = 30){

  dataset <- replicate_dataset(data, const = const)

  message('Samples: ', length(unique(dataset[[1]])))

  start = Sys.time()
  res2 = tidy_pairwise_jaccard_similarity(dataset, col_sample = "name", col_trait = "trait")
  seconds = Sys.time()-start
  message('Optimized: ', seconds, ' seconds')

  # start = Sys.time()
  # res = dataset |>
  #   tidy_pairwise_jaccard_similarity(col_sample = "name", col_trait = "trait")# |> # Compute Jaccard Similarity
  #   # tidy_toggle_simdist() |> # Convert similarity to distance
  #   # tidy_to_matrix() |> # Convert to matrix
  #   # matrix_to_dist_class() # Convert matrix to 'dist' class (for compatibility with hclust)
  #
  # seconds = Sys.time()-start
  # message('Unoptimized: ', seconds, ' seconds')

}




# Define a function that replicates a dataset
replicate_dataset <- function(data, const = 2) {
  labels = rep(1:const, each = nrow(data))
  replicated_df<- do.call("rbind", replicate(const, data, simplify = FALSE))
  replicated_df[[1]] <- paste(replicated_df[[1]], labels)

  # Extract the number of rows in the original dataset
  return(replicated_df)
}

