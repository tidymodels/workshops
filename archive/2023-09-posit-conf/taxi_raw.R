library(tidyverse)
library(tidymodels)
library(janitor)

# https://data.cityofchicago.org/Transportation/Taxi-Trips-2022/npd7-ywjz
taxi_raw <- read_csv("https://data.cityofchicago.org/api/views/e55j-2ewb/rows.csv?accessType=DOWNLOAD") |>
  clean_names()

set.seed(1234)

taxi <- taxi_raw |>
  filter(!is.na(tips), payment_type != "Cash") |>
  mutate(tip = if_else(tips > 0, "yes", "no") |> factor(levels = c("yes", "no"))) |>
  drop_na() |>
  slice_sample(n = 10000) |>
  mutate(
    trip_start_timestamp = lubridate::mdy_hms(trip_start_timestamp),
    trip_end_timestamp = lubridate::mdy_hms(trip_end_timestamp)
  )

readr::write_rds(taxi, "taxi_raw.rds", compress = "gz")
