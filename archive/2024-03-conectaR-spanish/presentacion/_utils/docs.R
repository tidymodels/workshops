library(fs)

source_dir <- here::here("archive/2024-03-conectaR-spanish/presentacion/")

qmds <- dir_ls(source_dir, glob = "*.qmd")

docs <- path(source_dir, "docs")

dir_create(docs)

system2("quarto", args = c("render", "input" = qmds[[1]], paste0("--output-dir=",  docs)))
