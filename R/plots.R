#' @importFrom rlang .data
NULL

#' Custom theme for ggplot2
#'
#' @description Creates a custom theme for ggplot2 visualizations with support for dark and light modes
#' @param mode Character string specifying the theme mode ("dark" or "light")
#' @return A ggplot2 theme object
#' @import ggplot2
#' @export
#' @examples
#' \dontrun{
#' # Dark mode
#' ggplot(...) + ctheme("dark")
#'
#' # Light mode
#' ggplot(...) + ctheme("light")
#' }
ctheme <- function(mode = "dark") {
  # Definizione colori
  colors <- if (mode == "dark") {
    list(
      background = "#242728",
      text = "#eaeaea",
      grid_major = "grey30",
      grid_minor = "grey20",
      strip = "#0085A1"
    )
  } else if (mode == "light") {
    list(
      background = "#eaeaea",
      text = "#242728",
      grid_major = "grey70",
      grid_minor = "grey80",
      strip = "#0085A1"
    )
  } else {
    stop("mode must be either 'dark' or 'light'")
  }

  # Crea il tema
  theme(
    # Sfondi
    plot.background = element_rect(fill = colors$background),
    panel.background = element_rect(fill = colors$background),

    # Testo
    text = element_text(color = colors$text),
    axis.text = element_text(color = colors$text),
    axis.title = element_text(color = colors$text),
    title = element_text(face = 'italic', size = 13),

    # Strip (facet)
    strip.background = element_rect(fill = colors$strip),
    strip.text = element_text(
      color = if(mode == "dark") "#eaeaea" else "#FFFFFF",
      face = "bold",
      size = 12
    ),

    # Griglie
    panel.grid.major = element_line(color = colors$grid_major),
    panel.grid.minor = element_line(color = colors$grid_minor),

    # Legenda
    legend.background = element_blank(),
    legend.text = element_text(color = colors$text),
    legend.title = element_blank(),
    legend.position = 'top'
  )
}

#' Create covariates balance plot
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_vline facet_wrap labs
#' @importFrom dplyr filter
#' @importFrom tidyr pivot_longer
#' @importFrom rlang .data
#' @param XX Matrix of covariates
#' @param unadjusted Vector of unadjusted values
#' @param adjusted Vector of adjusted values
#' @return A ggplot object
#' @export
cov_bal_plot <- function(XX, unadjusted, adjusted) {

  # Create a data frame for plotting
  pdata <- data.frame(
    covariate = colnames(XX),
    unadjusted = unadjusted,
    adjusted = adjusted
  )

  # melting dataframe
  pdatamelt <- pdata %>%
    dplyr::filter(.data$covariate != "(Intercept)") %>%
    tidyr::pivot_longer(cols = c("unadjusted", "adjusted"),
                        names_to = "type",
                        values_to = "value")

  p <- ggplot(pdatamelt, aes(x = .data$value,
                             y = factor(.data$covariate))) +
    geom_point(size = 3) +
    geom_vline(xintercept = seq(0, 1, by = 0.25),
               linetype = "dashed",
               alpha = 0.5) +
    facet_wrap(~type, ncol = 2) +
    labs(x = 'SMD', y = NULL, title = 'Covariates balance')

  return(p)
}

#' Create propensity score distribution plot
#'
#' @description Creates a density plot showing the distribution of propensity scores
#'              for treatment and control groups
#' @param e.hat Vector of estimated propensity scores
#' @param W Vector of treatment assignments
#' @return A ggplot object
#' @import ggplot2 dplyr
#' @export
prop_plot <- function(e.hat, W) {
  p <- data.frame(ps = e.hat, treatment = as.factor(W)) %>%
    ggplot(aes(x = .data$ps, fill = .data$treatment)) +
    geom_density(alpha = 0.5) +
    labs(x = "Propensity Score",
         y = "Density",
         title = "Propensity Score Distribution") +
    scale_fill_manual(values = c("#0085A1", 'red'),
                      labels = c("Control", "Treatment"))

  return(p)
}
