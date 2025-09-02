library(tidymodels)

leaf_data <- leaf_id_flavia |>
  mutate(
    edge = paste(
      if_else(denate_edge == "yes", "denate", ""),
      if_else(lobed_edge == "yes", "lobed", ""),
      if_else(smooth_edge == "yes", "smooth", ""),
      if_else(toothed_edge == "yes", "toothed", "")
    ),
    edge = stringr::str_trim(edge),
    edge = stringr::str_squish(edge),
    edge = stringr::str_replace_all(edge, " ", ", ")
  ) |>
  select(-ends_with("_edge")) |>
  relocate(edge, .after = shape)

save(leaf_data, file = "leaf_data.RData")
