% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\name{prop_plot}
\alias{prop_plot}
\title{Create propensity score distribution plot}
\usage{
prop_plot(e.hat, W)
}
\arguments{
\item{e.hat}{Vector of estimated propensity scores}

\item{W}{Vector of treatment assignments}
}
\value{
A ggplot object
}
\description{
Creates a density plot showing the distribution of propensity scores
             for treatment and control groups
}
