hexes <- function(..., size = 64) {
  x <- c(...)
  right <- (seq_along(x) - 1) * size

  res <- glue::glue(
    '![](hexes/<x>.png){.absolute top=0 right=<right> width="<size>" height="<size>"}',
    .open = "<", .close = ">"
  )

  paste0(res, collapse = " ")
}
