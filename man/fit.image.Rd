% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit.image.R
\name{fit.image}
\alias{fit.image}
\title{Estimate the mean function via bivariate penalized spline over triangulation}
\usage{
fit.image(Y, Z, V.est, Tr.est, d.est = 5, r = 1, lambda = 10^(-6:3),
  proj.matrix = FALSE)
}
\arguments{
\item{Y}{a matrix of imaging data, each row corresponding to one subject/image.}

\item{Z}{a 2-column matrix specifying locations of each pixel/voxel.}

\item{V.est}{the 2-column matrix of vertices' coordinates in the triangulation for estimating mean function of the first set of imaging data.}

\item{Tr.est}{the 3-column matrix of indices of the vertices of triangles in the triangulation.}

\item{d.est}{degree of bivariate spline, default is 5.}

\item{r}{smoothness parameter. Default is 1.}

\item{lambda}{candidate of the penalty parameter. Default is \code{10^(-6:3)}.}

\item{proj.matrix}{a logical value indicating whether the projection matrix
will be returned for adjusting \eqn{\sigma(z)} in the construction of SCC, default is FALSE.}
}
\description{
This function is used to fit the mean function of the imaging data via  bivariate penalized spline over triangulation. The tuning parameter is selected by generalized cross validation.
}
\details{
This R package is the implementation program for manuscript entitled "Simultaneous Confidence Corridors for Mean Functions in Functional Data Analysis of Imaging Data" by Yueying Wang, Guannan Wang, Li Wang and R. Todd Ogden.
}
\examples{
# Triangulation information;
data(Brain.V2); data(Brain.Tr2); # triangulation No. 2;
V.est=Brain.V2; Tr.est=Brain.Tr2;
# Location information;
n1=40; n2=40;
npix=n1*n2
u1=seq(0,1,length.out=n1)
v1=seq(0,1,length.out=n2)
uu=rep(u1,each=n2)
vv=rep(v1,times=n1)
Z=as.matrix(cbind(uu,vv))
ind.inside=inVT(V.est,Tr.est,Z[,1],Z[,2])$ind.inside
# Parameters for bivariate spline over triangulation;
d.est=5; r=1;
# simulation parameters
n=50; lam1=0.5; lam2=0.2; mu.func=2; noise.type='Func';
lambda=10^{seq(-6,3,0.5)}
dat=data1g.image(n,Z,ind.inside,mu.func,noise.type,lam1,lam2)
Y=dat$Y
Ym=matrix(apply(Y,2,mean),nrow=1)
mfit=fit.image(Ym,Z,V.est,Tr.est,d.est,r,lambda)
plot(mfit)

}
