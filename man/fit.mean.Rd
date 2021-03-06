% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit.mean.R
\name{fit.mean}
\alias{fit.mean}
\title{Penalized least square estimation with GCV}
\usage{
fit.mean(B, Q2, K, lambda = 10^(-6:3), Y, proj.matrix = FALSE)
}
\arguments{
\item{B}{bivariate spline basis matrix.}

\item{Q2}{qr decomposition of the smoothness matrix.}

\item{K}{energy matrix.}

\item{lambda}{candidate of the penalty parameter.}

\item{Y}{a matrix of data with each row corresponding to one subject/image.}

\item{proj.matrix}{a logical value indicating whether the projection matrix
will be returned for adjusting \eqn{\sigma(z)} in the construction of SCC.}
}
\description{
The function selects penalty parameter via generalized
cross validation and solves penalized least square problem
in estimating mean functions with bivariate penalized splines.
}
