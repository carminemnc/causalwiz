#' @importFrom stats as.formula var
#' @importFrom splines bs
NULL

#' Generate formula for model specification
#'
#' @description Provides a formula for model specification based on given variables and model type.
#' @param vars Character vector of variable names.
#' @param model_spec Character string specifying the model type: 'linear', 'interaction', or 'splines'.
#' @return A formula object.
#' @export
get_formula <- function(vars, model_spec = 'linear') {
  if (model_spec == 'linear') {
    fmla <- paste0("~", paste0(vars, collapse = "+"))
  } else if (model_spec == 'interaction') {
    fmla <- paste("~ 0 +", paste(apply(expand.grid(vars, vars), 1, function(x) paste0(x, collapse="*")), collapse="+"))
  } else if (model_spec == 'splines'){
    fmla <- paste0("~", paste0("bs(", vars, ", df=3)", collapse="+"))
  } else {
    stop("Invalid model specification, please choose between 'linear', 'interaction', 'splines'.")
  }

  # Print the formula for user reference
  cat("Generated formula:\n", paste("w", fmla), "\n")

  return(stats::as.formula(fmla))
}

#' Calculate covariate balance metrics
#'
#' @description Calculates unadjusted and adjusted covariate balance metrics using AIPW method.
#' @param XX Matrix of covariates.
#' @param W Vector of treatment assignments.
#' @param e.hat Vector of estimated propensity scores.
#' @return A list containing adjusted and unadjusted covariate balance metrics.
#' @export
aipw_balancer <- function(XX, W, e.hat) {
  # Unadjusted
  means.treat <- colMeans(XX[W == 1,, drop = FALSE])
  means.ctrl <- colMeans(XX[W == 0,, drop = FALSE])
  abs.mean.diff <- abs(means.treat - means.ctrl)
  var.treat <- apply(XX[W == 1,, drop = FALSE], 2, var)
  var.ctrl <- apply(XX[W == 0,, drop = FALSE], 2, var)
  std <- sqrt(var.treat + var.ctrl)
  unadjusted <- abs.mean.diff / std

  # Adjusted
  means.treat.adj <- colMeans(XX * W / e.hat)
  means.ctrl.adj <- colMeans(XX * (1 - W) / (1 - e.hat))
  abs.mean.diff.adj <- abs(means.treat.adj - means.ctrl.adj)
  var.treat.adj <- apply(XX * W / e.hat, 2, var)
  var.ctrl.adj <- apply(XX * (1 - W) / (1 - e.hat), 2, var)
  std.adj <- sqrt(var.treat.adj + var.ctrl.adj)
  adjusted <- abs.mean.diff.adj / std.adj

  list(
    adjusted_cov = adjusted,
    unadjusted_cov = unadjusted
  )
}
