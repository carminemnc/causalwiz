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
#' @param ... Additional arguments passed to underlying functions:
#'        For IPW method:
#'          cv.glmnet() arguments:
#'            All arguments are supported with their default values.
#'
#'        For AIPW method:
#'          causal_forest() arguments:
#'            All arguments are supported with num.trees defaulting to 100 instead of 2000.
#'            Other arguments maintain their default values.
#'
#'          average_treatment_effect() arguments:
#'            All arguments are supported with method defaulting to 'AIPW'.
#'            Other arguments maintain their default values.
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
#' # Basic usage
#' results <- ipw_estimators(
#'   data = data,
#'   estimation_method = "IPW",
#'   outcome = "y",
#'   treatment = "w",
#'   covariates = c("x1", "x2"),
#'   model_specification = 'linear',
#'   output = TRUE
#' )
#'
#' # Using additional parameters with AIPW
#' results_aipw <- ipw_estimators(
#'   data = data,
#'   estimation_method = "AIPW",
#'   outcome = "y",
#'   treatment = "w",
#'   covariates = c("x1", "x2"),
#'   model_specification = 'linear',
#'   output = TRUE,
#'   # causal_forest() arguments
#'   num.trees = 100,
#'   # average_treatment_effect() arguments
#'   target.sample = "control"
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
                           output = FALSE,
                           ...) {

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

  # Validate treatment variable
  if (!all(tvar %in% c(0, 1))) {
    stop("Treatment variable must be binary (0 or 1)")
  }

  # Get formula and create model matrix
  XX <- try(stats::model.matrix(get_formula(covariates, model_specification), data))
  if (inherits(XX, "try-error")) {
    stop("Error creating model matrix. Check your covariates and model specification.")
  }

  # Difference in means (benchmark)
  diffm <- try({
    model <- stats::lm(as.formula(paste0(outcome, '~', treatment)), data = data)
    lmtest::coeftest(model, vcov. = sandwich::vcovHC(model, type = "HC2"))[2,]
  })

  if (!inherits(diffm, "try-error")) {
    cat('\nDifference-in-means estimation (benchmark):\n')
    print(diffm)
  } else {
    warning("Could not compute difference-in-means estimation")
  }

  # Main estimation
  cat('\n', estimation_method, 'estimation:\n')

  if (estimation_method == 'AIPW') {
    # Define base arguments for causal_forest
    forest_base_args <- list(
      X = XX,
      W = tvar,
      Y = ovar
    )

    # Get all additional arguments
    extra_args <- list(...)

    # Set only num.trees default if not provided by user
    if (is.null(extra_args$num.trees)) {
      extra_args$num.trees <- 100
    }
    # Set only method default if not provided by user
    if (is.null(extra_args$method)) {
      extra_args$method <- 'AIPW'
    }

    # Define which arguments belong to average_treatment_effect
    ate_params <- c("target.sample", "method", "subset",
                    "debiasing.weights", "compliance.score",
                    "num.trees.for.weights")

    # Separate arguments for each function
    ate_args <- extra_args[names(extra_args) %in% ate_params]
    forest_args <- c(forest_base_args,extra_args[!names(extra_args) %in% ate_params])

    # Fit causal forest
    forest <- tryCatch({
      do.call(grf::causal_forest, forest_args)
    }, error = function(e) {
      stop("Error in causal forest estimation: ", e$message)
    })

    # Calculate average treatment effect
    forest.ate <- tryCatch({
      do.call(grf::average_treatment_effect,c(list(forest = forest), ate_args))
    }, error = function(e) {
      stop("Error in average treatment effect calculation: ", e$message)
    })

    e.hat <- forest$W.hat

    ate.results <- c(
      Estimate = unname(forest.ate[1]),
      "Std Error" = unname(forest.ate[2]),
      "t value" = unname(forest.ate[1]) / unname(forest.ate[2]),
      "Pr(>|t|)" = 2 * (1 - stats::pnorm(abs(unname(forest.ate[1]) / unname(forest.ate[2]))))
    )

    estimation <- unname(forest.ate[1])

  } else {
    # IPW estimation
    logit <- do.call(glmnet::cv.glmnet, c(
      list(x = XX, y = tvar, family = 'binomial')
    ))

    e.hat <- stats::predict(logit, XX, s = 'lambda.min', type = 'response')

    z <- ovar * (tvar / e.hat - (1 - tvar) / (1 - e.hat))
    ate.est <- mean(z)
    ate.se <- stats::sd(z) / sqrt(length(z))

    ate.results <- c(
      Estimate = ate.est,
      "Std Error" = ate.se,
      "t value" = ate.est / ate.se,
      "Pr(>|t|)" = 2 * (stats::pnorm(1 - abs(ate.est / ate.se)))
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
