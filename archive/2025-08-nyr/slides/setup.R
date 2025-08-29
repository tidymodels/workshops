# packages needed to make the slides, but not needed for participants
# dev_pkgs <- c("countdown", "forcats", "hadley/emo", "sessioninfo", "svglite")
# pak::pak(dev_pkgs)

#   ----------------------------------------------------------------------

hexes <- function(..., size = 64) {
  x <- c(...)
  x <- sort(unique(x), decreasing = TRUE)
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
library(forested)
library(ggplot2)
theme_set(theme_bw())
options(
  cli.width = 70,
  ggplot2.discrete.fill = c("#218239", "#d4ad42"),
  ggplot2.discrete.colour = c("#218239", "#d4ad42")
)

train_color <- "#1a162d"
test_color  <- "#cd4173"
data_color  <- "#767381"
assess_color <- "#84cae1"
splits_pal <- c(data_color, train_color, test_color)
