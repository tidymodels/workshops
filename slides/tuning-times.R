library(tidymodels)
library(finetune)
library(bonsai)

# Load our example data for this section
"https://raw.githubusercontent.com/tidymodels/" |>
  paste0("workshops/main/slides/class_data.RData") |>
  url() |>
  load()

set.seed(429)
sim_split <- initial_split(class_data, prop = 0.75, strata = class)
sim_train <- training(sim_split)
sim_test <- testing(sim_split)

set.seed(523)
sim_rs <- vfold_cv(sim_train, v = 10, strata = class)

rec <-
  recipe(class ~ ., data = sim_train) |>
  step_normalize(all_numeric_predictors())

lgbm_spec <-
  boost_tree(
    trees = tune(),
    learn_rate = tune(),
    mtry = tune(),
    min_n = tune(),
    stop_iter = tune()
  ) |>
  set_mode("classification") |>
  set_engine("lightgbm", num_threads = 1)

lgbm_wflow <- workflow(class ~ ., lgbm_spec)

cls_mtr <- metric_set(brier_class, roc_auc, sensitivity, specificity)

# ------------------------------------------------------------------------------

ctrl <- control_grid(save_pred = TRUE, save_workflow = TRUE)

set.seed(321)

seq_time <-
  system.time({
    lgbm_res <-
      lgbm_wflow |>
      tune_grid(
        resamples = sim_rs,
        # Let's use a larger grid
        grid = 50,
        control = ctrl,
        metrics = cls_mtr
      )
  })

# ------------------------------------------------------------------------------

library(mirai)
daemons(parallel::detectCores())

set.seed(321)

par_time <-
  system.time({
    lgbm_res <-
      lgbm_wflow |>
      tune_grid(
        resamples = sim_rs,
        # Let's use a larger grid
        grid = 50,
        control = ctrl,
        metrics = cls_mtr
      )
  })

# ------------------------------------------------------------------------------

ctrl <- control_race(verbose_elim = FALSE)

set.seed(321)

race_time <-
  system.time({
    lgbm_res <-
      lgbm_wflow |>
      tune_race_anova(
        resamples = sim_rs,
        # Let's use a larger grid
        grid = 50,
        control = ctrl,
        metrics = cls_mtr
      )
  })

# ------------------------------------------------------------------------------

lgbm_times = c(seq_time[3], par_time[3], race_time[3])
names(lgbm_times) <- c("sequential", "parallel", "racing")
print(lgbm_times)

save(lgbm_times, file = "lgbm_times.RData")

# ------------------------------------------------------------------------------

q("no")
