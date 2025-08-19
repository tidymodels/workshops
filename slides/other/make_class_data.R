library(tidymodels)

set.seed(382)
class_data <-
  sim_classification(1000, intercept = -12) |>
  bind_cols(sim_noise(1000, num_vars = 10))

set.seed(461)
p <- ncol(class_data)
reorder <- sample(2:ncol(class_data))
class_data <- class_data[, c(1, reorder)]

cat("noise columns:\n")
which(grepl("noise", names(class_data)))

# noise columns:
# [1]  2  3  5  8  9 11 14 20 22 24

orig_names <- names(class_data)
names(class_data)[-1] <- recipes::names0(p - 1, "predictor_")

save(class_data, file = "class_data.RData")
