sim_2026_conf_data <- function(n = 1000, difficulty = 1.5, seed = 2026) {
  # difficulty increases overlap/noise
  suppressPackageStartupMessages(require(MASS))
  suppressPackageStartupMessages(require(tibble))
  suppressPackageStartupMessages(require(dplyr))
  suppressPackageStartupMessages(require(cli))
  suppressPackageStartupMessages(require(withr))
  if (n < 2) {
    cli::cli_abort("Argument {.arg n} is {n} and should be greater than 1.")
  }
  prototypes <-
    tibble::tribble(
      ~pred_1           , ~pred_2           , ~class    ,
      3.28385296346227  , 2.11058971029925  , "class_1" ,
      1.99295985710468  , 1.29885307640971  , "class_1" ,
      1.11494066108671  , 1.21112054125805  , "class_1" ,
      1.58111481590246  , 1.04218159451577  , "class_1" ,
      0.933085519387167 , 0.742725131304698 , "class_1" ,
      1.4813502452831   , 0.665580991017953 , "class_1" ,
      1.79156331324896  , 1.09236969962912  , "class_1" ,
      0.923296041770621 , 1.10380372095596  , "class_1" ,
      1.68315280724302  , 1.33041377334919  , "class_1" ,
      1.19866733597084  , 0.913813852383717 , "class_1" ,
      1.21017916146048  , 0.808210972924222 , "class_1" ,
      1.13245205436588  , 0.897627091290441 , "class_1" ,
      2.50846619675937  , 1.17435059747938  , "class_1" ,
      1.28628643618461  , 0.662757831681574 , "class_1" ,
      1.18400347284807  , 0.531478917042255 , "class_1" ,
      1.75891786370839  , 0.838849090737255 , "class_1" ,
      3.25296465824517  , 0.869231719730976 , "class_1" ,
      1.52024064112227  , 0.812913356642856 , "class_1" ,
      2.17488310497008  , 0.761175813155731 , "class_1" ,
      2.67761156819852  , 1.77815125038364  , "class_1" ,
      0.740532929217641 , 0.198657086954423 , "class_1" ,
      0.839240780692042 , 0.819543935541869 , "class_1" ,
      1.29963032151854  , 1.0884904701824   , "class_1" ,
      1.4465240666747   , 1.25527250510331  , "class_1" ,
      3.04219904485381  , 1.96284268120124  , "class_1" ,
      1.0853944363856   , 1.10037054511756  , "class_1" ,
      0.98739746060067  , 0.57287160220048  , "class_1" ,
      0.6247625813215   , 0.658964842664435 , "class_1" ,
      2.39474208147888  , 3.34301449715077  , "class_2" ,
      3.3672385428119   , 3.49136169383427  , "class_2" ,
      1.98026216144135  , 2.69355108559591  , "class_2" ,
      2.23553665400076  , 3.38039216005703  , "class_2" ,
      2.6127276840127   , 3.58194965837332  , "class_2" ,
      1.03264330095748  , 2.6605809124273   , "class_2" ,
      1.32384265697982  , 2.2718416065365   , "class_2" ,
      3.28684624690373  , 3.75792718311333  , "class_2" ,
      2.08400408000751  , 2.77742682238931  , "class_2" ,
      2.26735948348643  , 2.78461729263288  , "class_2" ,
      1.42353606661629  , 2.67760695272049  , "class_2" ,
      1.53131837869764  , 2.6170003411209   , "class_2" ,
      1.61364532554137  , 2.70671778233676  , "class_2" ,
      1.97133695928657  , 3.40071063677323  , "class_2" ,
      3.66748486153303  , 4.5408048108305   , "class_2" ,
      1.97829784636368  , 2.55022835305509  , "class_2" ,
      2.95997306916169  , 3.36285930295868  , "class_2" ,
      1.75332108738671  , 3.09551804232315  , "class_2" ,
      1.73381492536004  , 2.96411814315148  , "class_2" ,
      1.80346467761371  , 3.23502315949522  , "class_2" ,
      1.72063832900463  , 2.79448804665917  , "class_2" ,
      2.58120454555321  , 3.3727279408856   , "class_2" ,
      0                 , 1.5               , "class_1" ,
      2.75              , 1.5               , "class_1" ,
      3                 , 1.6               , "class_1" ,
      3.5               , 1.8               , "class_1" ,
      3.75              , 2                 , "class_1" ,
      0.5               , 1.25              , "class_1" ,
      0.5               , 1.75              , "class_1" ,
      0.3               , 2                 , "class_1" ,
      0.25              , 0.7               , "class_1" ,
      1                 , 1.2               , "class_1" ,
      4                 , 2.5               , "class_1" ,
      4                 , 3.2               , "class_1" ,
      4.2               , 3.5               , "class_1"
    )

  num_proto <- nrow(prototypes)
  cov_mat <- matrix(c(0.2, 0.1, 0.1, 0.2), ncol = 2) * difficulty
  cov2cor(cov_mat)

  sim_dat <- NULL
  lvls <- paste0("class_", 1:2)

  iter <- max(1, ceiling(n / num_proto))

  withr::with_seed(
    {
      for (j in 1:nrow(prototypes)) {
        cent <- prototypes[j, 1:2] |> as.numeric()
        tmp <- MASS::mvrnorm(iter, mu = cent, Sigma = cov_mat)
        if (is.vector(tmp)) {
          tmp <- matrix(tmp, nrow = 1)
        }
        colnames(tmp) <- paste0("pred_", 1:2)
        tmp <- tibble::as_tibble(tmp)
        tmp$class <- prototypes$class[j]
        sim_dat <- dplyr::bind_rows(sim_dat, tmp)
      }

      sim_dat <-
        sim_dat |>
        dplyr::slice_sample(n = n) |>
        dplyr::mutate(
          pred_1 = as.numeric(scale(pred_1)),
          pred_2 = as.numeric(scale(pred_2)),
          class = factor(class, levels = lvls)
        )
    },
    seed = seed
  )

  sim_dat
}
