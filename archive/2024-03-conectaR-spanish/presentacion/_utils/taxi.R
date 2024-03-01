library(tidymodels)
library(tidyverse)
library(forcats)

taxi2 <- taxi

taxi <- taxi %>%
  rename(
    propina = tip,
    distancia = distance,
    compania = company,
    dia = dow,
    mes = month,
    hora = hour
  ) %>%
  mutate(
    propina = case_when(
      propina == "yes" ~ "si",
      TRUE ~ propina
    ),
    local = case_when(
      local == "yes" ~ "si",
      TRUE ~ local
    ),
    compania = case_when(
      compania == "other" ~ "otra",
      TRUE ~ compania
    ),
    mes = case_when(
      mes == "Apr" ~ "Abr",
      mes == "Jan" ~ "Ene",
      TRUE ~ mes
    ),
    dia = case_when(
      dia == "Mon" ~ "Lun",
      dia == "Tue" ~ "Mar",
      dia == "Wed" ~ "Mie",
      dia == "Thu" ~ "Jue",
      dia == "Fri" ~ "Vie",
      dia == "Sat" ~ "Sab",
      dia == "Sun" ~ "Dom",
      TRUE ~ dia
    )
  ) %>%
  mutate_if(is.character, as.factor) %>%
  mutate(
    propina = fct_relevel(propina, c("si", "no")),
    local = fct_relevel(local, c("si", "no")),
    dia = fct_relevel(dia, c("Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom")),
    mes = fct_relevel(mes, c("Ene", "Feb", "Mar", "Abr"))
  )

saveRDS(taxi, here::here("archive/2024-03-conectaR-spanish/taxi.rds"))

rm(taxi)
