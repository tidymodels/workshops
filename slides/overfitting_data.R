library(tidymodels)

data(parabolic)

set.seed(15)
split <- initial_split(parabolic, strata = "class", prop = 1/2)

training_set <- training(split)
testing_set  <-  testing(split)

data_grid <-
  crossing(X1 = seq(-6, 5.2, length = 200),
           X2 = seq(-6, 5.2, length = 200))


two_class_rec <-
  recipe(class ~ ., data = parabolic) %>%
  step_normalize(all_numeric_predictors())

svm_mod <-
  svm_rbf(cost = tune(), rbf_sigma = 1) %>%
  set_engine("kernlab") %>%
  set_mode("classification")

svm_wflow <-
  workflow() %>%
  add_recipe(two_class_rec) %>%
  add_model(svm_mod)

vals <- c("underfit", "about right", "overfit")
svm_res <-
  tibble(
    cost = c(0.005, 0.5, 5000),
    label = factor(vals, levels = vals),
    train_stats = vector(mode = "list", length = 3),
    test_stats = vector(mode = "list", length = 3),
    grid = vector(mode = "list", length = 3)
  )

cls_metrics <- metric_set(accuracy, brier_class)

for (i in 1:nrow(svm_res)) {
  set.seed(27)
  tmp_mod <-
    svm_wflow %>% finalize_workflow(svm_res %>% slice(i) %>% select(cost)) %>%
    fit(training_set)

  tr_pred <- augment(tmp_mod, training_set)
  te_pred <- augment(tmp_mod, testing_set)

  svm_res$grid[[i]] <- augment(tmp_mod, data_grid) |> select(X1, X2, .pred_Class1)
  svm_res$train_stats[[i]] <-
    augment(tmp_mod, training_set) |>
    cls_metrics(class, estimate = .pred_class, .pred_Class1) |>
    mutate(
      .metric = if_else(.metric == "accuracy", "Accuracy", "Brier Score"),
      result = map2_chr(format(.metric), .estimate, ~ paste0(.x, ": ", signif(.y, 3))),
      .row = if_else(.metric == "Accuracy", 1, 2),
      .col = 1
    )

  svm_res$test_stats[[i]] <-
    augment(tmp_mod, testing_set) |>
    cls_metrics(class, estimate = .pred_class, .pred_Class1) |>
    mutate(
      .metric = if_else(.metric == "accuracy", "Accuracy", "Brier Score"),
      result = map2_chr(format(.metric), .estimate, ~ paste0(.x, ": ", signif(.y, 3))),
      .row = if_else(.metric == "Accuracy", 1, 2),
      .col = 1
    )
}

save(svm_res, file = "slides/overfitting_data.RData")

