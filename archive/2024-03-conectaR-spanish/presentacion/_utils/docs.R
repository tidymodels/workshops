library(fs)
library(purrr)

source_dir <- here::here("archive/2024-03-conectaR-spanish/presentacion/")

qmds <- dir_ls(source_dir, glob = "*.qmd")

docs <- path(source_dir, "docs")

dir_create(docs)

map(qmds,~{
  system2("quarto", args = c("render", "input" = .x, paste0("--output-dir=",  docs)))
})

deploy_site <- function() {
  rsconnect::deploySite(siteDir = docs, siteName = "Aprendiendo Tidymodels")
}
