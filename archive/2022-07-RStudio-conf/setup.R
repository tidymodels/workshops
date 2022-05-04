hexes <- function(..., size = 64) {
  x <- c(...)
  x <- sort(unique(x))
  right <- (seq_along(x) - 1) * size

  res <- glue::glue(
    '![](hexes/<x>.png){.absolute top=0 right=<right> width="<size>" height="<size * 1.16>"}',
    .open = "<", .close = ">"
  )

  paste0(res, collapse = " ")
}
