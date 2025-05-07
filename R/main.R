#' @importFrom dplyr %>%
#' @importFrom stats sd pnorm coef lm
#' @importFrom lmtest coeftest
#' @importFrom sandwich vcovHC
#' @importFrom grf causal_forest average_treatment_effect
#' @importFrom glmnet cv.glmnet
#' @import ggplot2
#' @importFrom stats model.matrix predict
NULL

#' Estimate treatment effects using IPW or AIPW methods
#'
#' @description
#' Estimates causal effects using either Inverse Probability Weighting (IPW) or
#' Augmented Inverse Probability Weighting (AIPW) methods.
#'
#' @param data Data frame containing the analysis dataset
#' @param estimation_method Character, either 'IPW' or 'AIPW'
#' @param outcome Character, name of the outcome variable
#' @param treatment Character, name of the treatment variable
#' @param covariates Character vector of covariate names
#' @param model_specification Character, type of model specification ('linear', 'interaction', or 'splines')
#' @param output Logical, whether to return detailed output
#'
#' @return If output=TRUE, returns a list containing:
#'   \item{estimation_value}{The estimated treatment effect}
#'   \item{ate_results}{Detailed results including standard errors and p-values}
#'   \item{e_hat}{Estimated propensity scores}
#'   \item{model_spec_matrix}{Model specification matrix}
#'   \item{treatment_variable}{Treatment indicator vector}
#'
#' @examples
#' \dontrun{
#' data <- data.frame(
#'   y = rnorm(100),
#'   w = rbinom(100, 1, 0.5),
#'   x1 = rnorm(100),
#'   x2 = rnorm(100)
#' )
#'
#' results <- ipw_estimators(
#'   data = data,
#'   estimation_method = "IPW",
#'   outcome = "y",
#'   treatment = "w",
#'   covariates = c("x1", "x2")
#' )
#' }
#'
#' @export
ipw_estimators <- function(data,
                           estimation_method,
                           outcome,
                           treatment,
                           covariates,
                           model_specification = 'linear',
                           output = FALSE) {

  # Input validation
  if (!estimation_method %in% c('IPW', 'AIPW')) {
    stop("estimation_method must be either 'IPW' or 'AIPW'")
  }

  if (!all(c(treatment, outcome, covariates) %in% names(data))) {
    stop("Some variables not found in data")
  }

  # Extract variables
  tvar <- data[[treatment]]
  ovar <- data[[outcome]]

  # Get formula and create model matrix
  XX <- model.matrix(get_formula(covariates, model_specification), data)

  # Difference in means (benchmark)
  diffm <- lm(as.formula(paste0(outcome, '~', treatment)), data = data)
  dim_results <- coeftest(diffm, vcov. = vcovHC(diffm, type = "HC2"))[2,]

  # Print benchmark results
  cat('\nDifference-in-means estimation (benchmark):\n')
  print(dim_results)

  # Main estimation
  cat('\n', estimation_method, 'estimation:\n')

  if (estimation_method == 'AIPW') {
    # Causal forest estimation
    forest <- causal_forest(
      X = XX,
      W = tvar,
      Y = ovar,
      num.trees = 100
    )

    forest.ate <- average_treatment_effect(forest, method = 'AIPW')
    e.hat <- forest$W.hat

    ate.results <- c(
      Estimate = unname(forest.ate[1]),
      "Std Error" = unname(forest.ate[2]),
      "t value" = unname(forest.ate[1]) / unname(forest.ate[2]),
      "Pr(>|t|)" = 2 * (1 - pnorm(abs(unname(forest.ate[1]) / unname(forest.ate[2]))))
    )

    estimation <- unname(forest.ate[1])

  } else {
    # IPW estimation
    logit <- cv.glmnet(
      x = XX,
      y = tvar,
      family = 'binomial'
    )

    e.hat <- predict(logit, XX, s = 'lambda.min', type = 'response')

    z <- ovar * (tvar / e.hat - (1 - tvar) / (1 - e.hat))
    ate.est <- mean(z)
    ate.se <- sd(z) / sqrt(length(z))

    ate.results <- c(
      Estimate = ate.est,
      "Std Error" = ate.se,
      "t value" = ate.est / ate.se,
      "Pr(>|t|)" = 2 * (pnorm(1 - abs(ate.est / ate.se)))
    )

    estimation <- ate.est
  }

  print(ate.results)

  if (output) {
    return(list(
      estimation_value = estimation,
      ate_results = ate.results,
      e_hat = e.hat,
      model_spec_matrix = XX,
      treatment_variable = tvar
    ))
  }
}
