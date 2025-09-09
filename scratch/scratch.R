# ------------------------------------------------------------------------------
# Explore the forested_train data on your own!

str(forested_test)

forested_train |>
  summarise(
    rate = mean(forested == "Yes"),
    .by = c(land_type)
  )

forested_train |>
  ggplot(aes(precip_annual)) +
  geom_histogram(col = "white") +
  facet_wrap(~forested)

forested_train |>
  ggplot(aes(elevation)) +
  geom_histogram(col = "white") +
  facet_wrap(~forested, ncol = 1)

forested_train |>
  ggplot(aes(temp_annual_max, precip_annual)) +
  geom_point(aes(col = forested), alpha = 1 / 3)

forested_train |>
  summarize(
    rate = mean(forested == "Yes"),
    num = sum(forested == "Yes"),
    total = length(forested),
    .by = c(county)
  ) |>
  mutate(
    county = reorder(county, rate),
    lower = map2_dbl(num, total, ~ binom.test(.x, .y)$conf.int[1]),
    upper = map2_dbl(num, total, ~ binom.test(.x, .y)$conf.int[2])
  ) |>
  ggplot(aes(rate, county)) +
  geom_point() +
  geom_errorbar(aes(xmin = lower, xmax = upper), alpha = 1 / 5)

# ------------------------------------------------------------------------------
# Run the tree_spec chunk in your .qmd.

logistic_spec <-
  logistic_reg() |>
  set_mode("classification")

logistic_spec |>
  fit(forested ~ ., data = forested_train)

# ------------------------------------------------------------------------------

tree_spec <-
  decision_tree() |>
  set_mode("classification")

tree_spec |>
  fit(forested ~ ., data = forested_train)


# ------------------------------------------------------------------------------

library(bonsai)

tree_spec <-
  decision_tree() |>
  set_engine("partykit") |>
  set_mode("classification")

tree_spec |>
  fit(forested ~ . - county, data = forested_train)


smol_tree_spec <-
  decision_tree(min_n = 500) |>
  set_engine("partykit") |>
  set_mode("classification")

smol_tree_fit <-
  smol_tree_spec |>
  fit(forested ~ . - county, data = forested_train)

smol_tree_fit |>
  extract_fit_engine() |>
  plot()


# ------------------------------------------------------------------------------
# Run: predict(tree_fit, new_data = forested_test)

tree_spec <-
  decision_tree() |>
  set_mode("classification")

tree_fit <-
  workflow(forested ~ ., tree_spec) |>
  fit(data = forested_train)

predict(tree_fit, new_data = forested_test)
predict(tree_fit, new_data = forested_test, type = "prob")

# ------------------------------------------------------------------------------

augment(tree_fit, new_data = forested_train) |>
  brier_class(forested, .pred_Yes)

augment(tree_fit, new_data = forested_test) |>
  brier_class(forested, .pred_Yes)


# ------------------------------------------------------------------------------

rf_spec <- rand_forest(trees = 1000, mode = "classification")

set.seed(123)
forested_folds <- vfold_cv(forested_train, v = 10)

rf_wflow <- workflow(forested ~ ., rf_spec)

set.seed(435)
rf_res <-
  rf_wflow |>
  fit_resamples(
    forested_folds,
    control = control_resamples(save_pred = TRUE)
  )


# ------------------------------------------------------------------------------
# Let’s take some time and investigate the training data. The outcome is avg_price_per_room.

str(hotel_train)

mean(complete.cases(hotel_train))

hotel_train |>
  ggplot(aes(historical_adr, avg_price_per_room)) +
  geom_point(alpha = 1 / 5)

hotel_train |>
  ggplot(aes(avg_price_per_room, meal)) +
  geom_boxplot()

hotel_train |>
  ggplot(aes(meal, children)) +
  geom_boxplot()

tr_agents <- as.character(unique(hotel_train$agent))
te_agents <- as.character(unique(hotel_test$agent))
setdiff(te_agents, tr_agents)
setdiff(tr_agents, te_agents)

hotel_train |>
  count(country) |>
  arrange(desc(n))

hotel_train |>
  count(agent) |>
  arrange(desc(n))

hotel_train |>
  count(market_segment) |>
  arrange(desc(n))

# ------------------------------------------------------------------------------
# Create a recipe() for the hotel data to...

hotel_rec <-
  recipe(avg_price_per_room ~ ., data = hotel_train) |>
  step_YeoJohnson(lead_time) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_spline_natural(arrival_date_num, deg_free = 10)


# ------------------------------------------------------------------------------
library(textrecipes)

hash_rec <-
  recipe(avg_price_per_room ~ ., data = hotel_train) |>
  step_YeoJohnson(lead_time) |>
  step_dummy_hash(agent, num_terms = tune("agent hash")) |>
  step_dummy_hash(company, num_terms = tune("company hash")) |>
  step_zv(all_predictors())

library(bonsai)
lgbm_spec <-
  boost_tree(trees = tune(), learn_rate = tune()) |>
  set_mode("regression") |>
  set_engine("lightgbm", num_threads = 1)

lgbm_wflow <- workflow(hash_rec, lgbm_spec)

lgbm_wflow |>
  extract_parameter_set_dials() |>
  update(trees = trees(c(1, 100))) |>
  grid_regular(levels = 3:6)
