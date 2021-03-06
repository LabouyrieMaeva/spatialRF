% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rank_spatial_predictors.R
\name{rank_spatial_predictors}
\alias{rank_spatial_predictors}
\title{Ranks spatial predictors}
\usage{
rank_spatial_predictors(
  data = NULL,
  dependent.variable.name = NULL,
  predictor.variable.names = NULL,
  distance.matrix = NULL,
  distance.thresholds = NULL,
  ranger.arguments = NULL,
  spatial.predictors.df = NULL,
  ranking.method = c("effect", "moran"),
  reference.moran.i = 1,
  verbose = FALSE,
  n.cores = NULL,
  cluster.ips = NULL,
  cluster.cores = NULL,
  cluster.user = Sys.info()[["user"]],
  cluster.port = "11000"
)
}
\arguments{
\item{data}{Data frame with a response variable and a set of predictors. Default: \code{NULL}}

\item{dependent.variable.name}{Character string with the name of the response variable. Must be in the column names of \code{data}. Default: \code{NULL}}

\item{predictor.variable.names}{Character vector with the names of the predictive variables. Every element of this vector must be in the column names of \code{data}. Default: \code{NULL}}

\item{distance.matrix}{Squared matrix with the distances among the records in \code{data}. The number of rows of \code{distance.matrix} and \code{data} must be the same. If not provided, the computation of the Moran's I of the residuals is omitted. Default: \code{NULL}}

\item{distance.thresholds}{Numeric vector with neighborhood distances. All distances in the distance matrix below each value in \code{dustance.thresholds} are set to 0 for the computation of Moran's I. If \code{NULL}, it defaults to seq(0, max(distance.matrix), length.out = 4). Default: \code{NULL}}

\item{ranger.arguments}{List with \link[ranger]{ranger} arguments. See \link{rf} or \link{rf_repeat} for further details.}

\item{spatial.predictors.df}{Data frame of spatial predictors.}

\item{ranking.method}{Character, method used by to rank spatial predictors. The method "effect" ranks spatial predictors according how much each predictor reduces Moran's I of the model residuals, while the method "moran" ranks them by their own Moran's I.}

\item{reference.moran.i}{Moran's I of the residuals of the model without spatial predictors. Default: \code{1}}

\item{verbose}{Logical, ff \code{TRUE}, messages and plots generated during the execution of the function are displayed, Default: \code{TRUE}}

\item{n.cores}{Integer, number of cores to use during computations. If \code{NULL}, all cores but one are used, unless a cluster is used. Default = \code{NULL}}

\item{cluster.ips}{Character vector with the IPs of the machines in a cluster. The machine with the first IP will be considered the main node of the cluster, and will generally be the machine on which the R code is being executed.}

\item{cluster.cores}{Numeric integer vector, number of cores to use on each machine.}

\item{cluster.user}{Character string, name of the user (should be the same throughout machines). Defaults to the current system user.}

\item{cluster.port}{Character, port used by the machines in the cluster to communicate. The firewall in all computers must allow traffic from and to such port. Default: \code{"11000"}}
}
\value{
A list with three slots:
\itemize{
\item \code{method}: Character, name of the method used to rank the spatial predictors.
\item \code{criteria}: Data frame with two different configurations depending on the ranking method. If \code{ranking.method = "effect"}, the columns contain the names of the spatial predictors, the r-squared of the model, the Moran's I of the model residuals, the difference between the Moran's I of the model including the given spatial predictor, and the Moran's I of the model fitted without spatial predictors, and the interpretation of the Moran's I value. If \code{ranking.method = "moran"}, only the name of the spatial predictor and it's Moran's I are in the output data frame.
\item \code{ranking}: Ordered character vector with the names of the spatial predictors selected.
}
}
\description{
Ranks spatial predictors generated by \code{\link[=mem_multithreshold]{mem_multithreshold()}} or \code{\link[=pca_multithreshold]{pca_multithreshold()}} by their effect in reducing the Moran's I of the model residuals (\code{ranking.method = "effect"}), or by their own Moran's I (\code{ranking.method = "moran"}).

In the former case, one model of the type \code{y ~ predictors + spatial_predictor_X} is fitted per spatial predictor, and the Moran's I of the model residuals residuals is compared with the one of the model without spatial predictors (\code{y ~ predictors}), to finally rank the spatial predictor from maximum to minimum difference in Moran's I.

In the latter case, the spatial predictors are ordered by their Moran's I alone (this is the faster option).

In both cases, spatial predictors with no effect (no reduction of Moran's I  or Moran's I of the spatial predictor equal or lower than 0) are removed.

This function has been designed to be used internally by \code{\link[=rf_spatial]{rf_spatial()}} rather than directly by a user.
}
\examples{
\donttest{
if(interactive()){
 data("distance_matrix")

 spatial.predictors.df <- pca_distance_matrix(
   x = distance_matrix[1:50, 1:50],
   distance.thresholds = c(0, 100, 1000)
 )

 #ranking by the Moran's I of the spatial predictor
 rank <- rank_spatial_predictors(
   distance.matrix = distance_matrix[1:50, 1:50],
   distance.thresholds = c(0, 100, 1000),
   spatial.predictors.df = spatial.predictors.df,
   ranking.method = "effect",
   n.cores = 1
 )
 rank$ranking.criteria
 rank$ranking
 }
}
}
