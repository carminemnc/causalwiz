#' Welfare Dataset (Small Version)
#'
#' @description
#' A subset of the General Social Survey (GSS) data used for causal inference analysis.
#' The GSS is a high-quality, representative sample of the adult population of the United States,
#' conducted regularly since 1972 to monitor trends in attitudes, behaviors, and attributes.
#'
#' @format A data frame with X rows and 9 columns:
#' \describe{
#'   \item{y}{Outcome variable}
#'   \item{w}{Treatment variable}
#'   \item{age}{Age of the respondent}
#'   \item{polviews}{Political views of the respondent}
#'   \item{income}{Income of the respondent}
#'   \item{educ}{Education level of the respondent}
#'   \item{marital}{Marital status of the respondent}
#'   \item{sex}{Sex of the respondent}
#' }
#'
#' @source Smith, Tom W., Michael Davern, Jeremy Freese, and Stephen L. Morgan.
#' General Social Surveys, 1972-2014.
#' Principal Investigator, Tom W. Smith; Co-Principal Investigators, Michael Davern,
#' Jeremy Freese, and Stephen L. Morgan, NORC ed. Chicago: NORC, 2018.
#'
#' @references
#' Smith, T. W. (2016). The General Social Surveys. NORC at the University of Chicago.
#' GSS Project Report No. 32.
#'
#' @examples
#' data(welfare_small)
#' head(welfare_small)
#' summary(welfare_small)
"welfare_small"

