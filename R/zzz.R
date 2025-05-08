#' @importFrom ggplot2 update_geom_defaults
NULL

.onLoad <- function(libname, pkgname) {
  # Make sure ggplot2 is available
  if (requireNamespace("ggplot2", quietly = TRUE)) {
    ggplot2::update_geom_defaults("point", list(colour = 'red'))
    ggplot2::update_geom_defaults("line", list(colour = 'red'))
  }
}
