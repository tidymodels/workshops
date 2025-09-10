# resize all hexes

library(magick)
library(fs)
library(purrr)

tidyverse_pngs <- fs::dir_ls(
  "slides/hexes/", 
  recurse = TRUE, 
  glob = "*.png"
)

scale_hex <- function(hex) {
  hex %>%
    image_read() %>% 
    image_scale("128x") %>% 
    image_write(hex, quality = 100)
}

purrr::map(tidyverse_pngs, scale_hex)