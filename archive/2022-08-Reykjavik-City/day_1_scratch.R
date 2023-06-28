library(tidymodels)
tidymodels_prefer()
theme_set(theme_bw())

set.seed(123)
frog_split <- initial_split(tree_frogs, prop = 0.8)
frog_train <- training(frog_split)
frog_test <- testing(frog_split)

nrow(frog_train)
nrow(frog_test)

# ------------------------------------------------------------------------------

frog_train %>%
  ggplot(aes(latency)) +
  geom_histogram(col = "white")

frog_train %>%
  ggplot(aes(latency)) +
  geom_histogram(col = "white") +
  scale_x_log10()

frog_train %>%
  ggplot(aes(treatment)) +
  geom_bar()  +
  facet_wrap(~ reflex)

stacks::tree_frogs %>%
  ggplot(aes(x = t_o_d)) +
  geom_histogram(stat = "count") +
  facet_wrap(~ hatched)

# ------------------------------------------------------------------------------
# section 3 hands-on

# Before:

tree_spec <-
  decision_tree() %>%
  set_mode("regression")

tree_wflow <-
  workflow() %>%
  add_formula(latency ~ .) %>%
  add_model(tree_spec)

# After (using linear regression)

linear_spec <- linear_reg()

linear_wflow <-
  workflow() %>%
  add_formula(latency ~ .) %>%
  add_model(linear_spec)

# or do this:
linear_wflow <-
  tree_wflow %>%
  update_model(linear_spec)

# you can do the same thing (updating) with the
# fitted workflow


# How do we get to the original lm object?

linear_fit <- fit(linear_wflow, frog_train)

lm_object <-
  linear_fit %>%
  extract_fit_engine()

tidy(lm_object)

# ------------------------------------------------------------------------------
# section 3 deployment

library(vetiver)
library(plumber)

v <- vetiver_model(tree_fit, model_name = "frog_hatching")


pr() %>%
  vetiver_api(v) %>%
  pr_run(port = 8080)



library(pins)
model_board <- board_temp(versioned = TRUE)
model_board %>% vetiver_pin_write(v)

# ------------------------------------------------------------------------------
# section 4

linear_fit %>%
  augment(frog_train) %>%
  ccc(latency, .pred)

linear_fit %>%
  augment(frog_test) %>%
  ccc(latency, .pred)

# ------------------------------------------------------------------------------
# section 5

nhl_train %>%
  ggplot(aes(x = shooter_type, fill = on_goal)) +
  geom_bar()

nhl_train %>%
  ggplot(aes(x = goal_difference)) +
  geom_bar()

set.seed(100)
nhl_train %>%
  sample_n(500) %>%
  plot_nhl_shots(emphasis = strength)

set.seed(100)
nhl_train %>%
  sample_n(500) %>%
  mutate(diff = format(goal_difference)) %>%
  plot_nhl_shots(emphasis = diff)

nhl_train %>%
  ggplot(aes(x = coord_x)) +
  geom_line(stat = "density")



