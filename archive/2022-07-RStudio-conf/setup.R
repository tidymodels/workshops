hexes <- function(..., size = 64) {
  x <- c(...)
  x <- rev(sort(unique(x)))
  right <- (seq_along(x) - 1) * size

  res <- glue::glue(
    '![](hexes/<x>.png){.absolute top=-20 right=<right> width="<size>" height="<size * 1.16>"}',
    .open = "<", .close = ">"
  )

  paste0(res, collapse = " ")
}

knitr::opts_chunk$set(
  digits = 3,
  comment = "#>",
  dev = 'svglite'
)

# devtools::install_github("gadenbuie/countdown")
library(countdown)
library(ggplot2)
theme_set(theme_minimal())
options(cli.width = 70)

train_color <- "#1a162d"
test_color  <- "#cd4173"
data_color  <- "#767381"
assess_color <- "#84cae1"
splits_pal <- c(data_color, train_color, test_color)
