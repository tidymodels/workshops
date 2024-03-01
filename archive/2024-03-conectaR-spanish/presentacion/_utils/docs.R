library(fs)
library(purrr)

source_dir <- here::here("archive/2024-03-conectaR-spanish/presentacion/")

qmds <- dir_ls(source_dir, glob = "*.qmd")

docs <- path(source_dir, "docs")

if(dir_exists(docs)) dir_delete(docs)
dir_create(docs)

quarto_yml <- path(source_dir, "_quarto.yml")
system2("touch", quarto_yml)

map(qmds[1:4],~{
  system2("quarto", args = c("render", "input" = .x, paste0("--output-dir=",  docs)))
})

system2("touch", path(docs, "_site.yml"))

file_delete(quarto_yml)

deploy_site <- function() {
  rsconnect::deployApp(
    appDir = docs
    )
}

#deploy_site()
# https://colorado.posit.co/rsc/conectar2024/intro-01-introduccion.html#/title-slide
# https://colorado.posit.co/rsc/conectar2024/intro-02-presupuesto-de-datos.html#/title-slide
# https://colorado.posit.co/rsc/conectar2024/intro-03-partes-del-modelo.html#/title-slide
# https://colorado.posit.co/rsc/conectar2024/intro-04-evaluar-modelos.html#/title-slide


