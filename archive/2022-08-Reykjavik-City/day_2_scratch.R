nhl_glm_res %>%
  collect_predictions() %>%
  roc_curve(on_goal, estimate = .pred_yes) %>%
  ggplot(aes(x = 1 - specificity, y = sensitivity)) +
  geom_step() +
  geom_abline(col = "red") +
  coord_equal()

nhl_glm_res %>%
  collect_predictions() %>%
  pr_curve(on_goal, estimate = .pred_yes)

nhl_glm_res %>%
  collect_predictions() %>%
  gain_curve(on_goal, estimate = .pred_yes) %>%
  autoplot()

# ------------------------------------------------------------------------------

knots_1 <-
  recipe(on_goal ~ ., data = nhl_train) %>%
  step_lencode_mixed(shooter, goaltender, outcome = vars(on_goal)) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_mutate(
    angle = abs( atan2(abs(coord_y), (89 - coord_x) ) * (180 / pi) ),
    defensive_zone = ifelse(coord_x <= -25.5, 1, 0),
    behind_goal_line = ifelse(coord_x >= 89, 1, 0)
  ) %>%
  step_zv(all_predictors()) %>%
  step_ns(angle, options = list(knots = c(0, .1, .6, .8, 1)))

knots_2 <-
  recipe(on_goal ~ ., data = nhl_train) %>%
  step_lencode_mixed(shooter, goaltender, outcome = vars(on_goal)) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_mutate(
    angle = abs( atan2(abs(coord_y), (89 - coord_x) ) * (180 / pi) ),
    defensive_zone = ifelse(coord_x <= -25.5, 1, 0),
    behind_goal_line = ifelse(coord_x >= 89, 1, 0)
  ) %>%
  step_zv(all_predictors()) %>%
  step_ns(angle, options = list(knots = c(0, .2, .3, .7, 1)))

library(corrplot)

Chicago %>%
  mutate(day = wday(date,label = TRUE)) %>%
  filter(!(day %in% c("Sat", "Sun"))) %>%
  select(all_of(stations)) %>%
  cor() %>%
  corrplot(tl.cex = 1/5, order = "hclust")
