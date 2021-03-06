% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ppc-loo.R
\name{PPC-loo}
\alias{PPC-loo}
\alias{ppc_loo_pit}
\alias{ppc_loo_intervals}
\alias{ppc_loo_ribbon}
\title{LOO predictive checks}
\usage{
ppc_loo_pit(y, yrep, lw, pit, compare = c("uniform", "normal"), ...,
  size = 2, alpha = 1)

ppc_loo_intervals(y, yrep, lw, intervals, ..., prob = 0.9, size = 1,
  fatten = 3, order = c("index", "median"))

ppc_loo_ribbon(y, yrep, lw, intervals, ..., prob = 0.9, alpha = 0.33,
  size = 0.25)
}
\arguments{
\item{y}{A vector of observations. See \strong{Details}.}

\item{yrep}{An \eqn{S} by \eqn{N} matrix of draws from the posterior
predictive distribution, where \eqn{S} is the size of the posterior sample
(or subset of the posterior sample used to generate \code{yrep}) and
\eqn{N} is the number of observations (the length of \code{y}). The columns
of \code{yrep} should be in the same order as the data points in \code{y}
for the plots to make sense. See \strong{Details} for additional
instructions.}

\item{lw}{A matrix of (smoothed) log weights with the same dimensions as
\code{yrep}. See the \code{\link[loo]{psislw}} function in the \pkg{loo}
package, which returns smoothed weights that can be used to specify
\code{lw}.}

\item{pit}{For \code{ppc_loo_pit}, optionally a vector of precomputed PIT
values that can be specified instead of \code{y}, \code{yrep}, and
\code{lw} (these are all ignored if \code{pit} is specified). If not
specified the PIT values are computed internally before plotting.}

\item{compare}{For \code{ppc_loo_pit}, a string that can be either
\code{"uniform"} or \code{"normal"}. If \code{"uniform"} (the default) the
Q-Q plot compares computed PIT values to the standard uniform distribution.
If \code{compare="normal"}, the Q-Q plot compares standardized PIT values
to the standard normal distribution.}

\item{...}{Currently unused.}

\item{alpha, size, fatten}{Arguments passed to code geoms to control plot
aesthetics. For \code{ppc_loo_pit}, \code{size} and \code{alpha} are passed
to \code{\link[ggplot2]{geom_point}}. For \code{ppc_loo_intervals},
\code{size} and \code{fatten} are passed to
\code{\link[ggplot2]{geom_pointrange}}. For \code{ppc_loo_ribbon},
\code{alpha} and \code{size} are passed to
\code{\link[ggplot2]{geom_ribbon}}.}

\item{intervals}{For \code{ppc_loo_intervals} and \code{ppc_loo_ribbon},
optionally a matrix of precomputed LOO predictive intervals intervals with
that can be specified instead of \code{yrep} and \code{lw} (these are both
ignored if \code{intervals} is specified). If not specified the intervals
are computed internally before plotting. If specified, \code{intervals}
must be a matrix with number of rows equal to the number of data points and
three columns in the following order: the first for the lower bound of the
interval, the second for median (50\%), and the third for the interval
upper bound (column names are ignored).}

\item{prob}{A value between 0 and 1 indicating the desired probability mass
to include in the intervals. The default is 0.9.}

\item{order}{For \code{ppc_loo_intervals} A string indicating how to arrange
the plotted intervals. The default (\code{"index"}) is to plot them in the
order of the observations. The alternative (\code{"median"}) arranges them
by median value from smallest (left) to largest (right).}
}
\value{
A ggplot object that can be further customized using the
  \pkg{ggplot2} package.
}
\description{
Leave-One-Out (LOO) predictive checks. See the \strong{Plot Descriptions}
section below for details.
}
\section{Plot Descriptions}{

\describe{
\item{\code{ppc_loo_pit}}{
 The calibration of marginal predictions can be assessed using probability
 integral transformation (PIT) checks. LOO improves the check by avoiding the
 double use of data. See the section on marginal predictive checks in Gelman
 et al. (2013, p. 152--153). The default LOO PIT predictive check is a
 quantile-quantile (Q-Q) plot comparing the LOO PITs to the standard uniform
 distribution. Alternatively, setting the \code{compare} argument to
 \code{"normal"} will produce a Q-Q plot comparing standardized PIT values
 to the standard normal distribution.
}
\item{\code{ppc_loo_intervals, ppc_loo_ribbon}}{
 Similar to \code{\link{ppc_intervals}} and \code{\link{ppc_ribbon}} but the
 intervals are for the LOO predictive distribution.
}
}
}

\examples{

\dontrun{
library(rstanarm)
library(loo)

head(radon)
fit <- stan_lmer(log_radon ~ floor + log_uranium + floor:log_uranium
                   + (1 + floor | county), data = radon, cores = 2)
y <- radon$log_radon
yrep <- posterior_predict(fit)
psis <- psislw(-log_lik(fit), cores = 2)

# marginal predictive check using LOO probability integral transform
color_scheme_set("orange")
ppc_loo_pit(y, yrep, lw = psis$lw_smooth)
ppc_loo_pit(y, yrep, lw = psis$lw_smooth, compare = "normal")

# loo predictive intervals vs observations
sel <- 800:900
ppc_loo_intervals(y[sel], yrep[, sel], psis$lw_smooth[, sel],
                  prob = 0.9, size = 0.5)

color_scheme_set("gray")
ppc_loo_intervals(y[sel], yrep[, sel], psis$lw_smooth[, sel],
                  order = "median", prob = 0.8, size = 0.5)
}

}
\references{
Gelman, A., Carlin, J. B., Stern, H. S., Dunson, D. B., Vehtari,
  A., and Rubin, D. B. (2013). \emph{Bayesian Data Analysis.} Chapman & Hall/CRC
  Press, London, third edition. (p. 152--153)

Vehtari, A., Gelman, A., and Gabry, J. (2016). Practical
  Bayesian model evaluation using leave-one-out cross-validation and WAIC.
  \emph{Statistics and Computing}. Advance online publication.
  doi:10.1007/s11222-016-9696-4. arXiv preprint:
  \url{http://arxiv.org/abs/1507.04544/}
}
\seealso{
Other PPCs: \code{\link{PPC-discrete}},
  \code{\link{PPC-distributions}},
  \code{\link{PPC-errors}}, \code{\link{PPC-intervals}},
  \code{\link{PPC-overview}},
  \code{\link{PPC-scatterplots}},
  \code{\link{PPC-test-statistics}}
}
