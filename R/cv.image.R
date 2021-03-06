#' Choose triangulation for estimating mean functions via leave-image-out cross-validation
#'
#' The function selects triangulation for estimating mean function based on leave-image-out cross-validation.
#'
#' @param Y a matrix of imaging data, each row corresponding to one subject/image.
#' @param Z a 2-column matrix specifying locations of each pixel/voxel.
#' @param d.est degree of bivariate spline, default is 5.
#' @param r smoothness parameter. Default is 1.
#' @param V.ests lists of matrices containing vertices' information of triangulation candidates.
#' @param Tr.ests list of 3-column matrices specifying triangles in the triangulation candidates.
#' @param lambda the vector of the candidates of penalty parameter.
#' @param nfold number of folds in k-fold cross-validation. Default is 10.
#'
#' @details This R package is the implementation program for manuscript entitled "Simultaneous Confidence Corridors for Mean Functions in Functional Data Analysis of Imaging Data" by Yueying Wang, Guannan Wang, Li Wang and R. Todd Ogden.
#'
#' @examples
#' # Triangulation information;
#' data(Brain.V1); data(Brain.Tr1); # triangulation No. 1;
#' data(Brain.V2); data(Brain.Tr2); # triangulation No. 2;
#' data(Brain.V3); data(Brain.Tr3); # triangulation No. 3;
#' V.ests=list(V1=Brain.V1,V2=Brain.V2,V3=Brain.V3);
#' Tr.ests=list(Tr1=Brain.Tr1,Tr2=Brain.Tr2,Tr3=Brain.Tr3);
#' # Location information;
#' n1=40; n2=40;
#' npix=n1*n2
#' u1=seq(0,1,length.out=n1)
#' v1=seq(0,1,length.out=n2)
#' uu=rep(u1,each=n2)
#' vv=rep(v1,times=n1)
#' Z=as.matrix(cbind(uu,vv))
#' ind.inside=inVT(Brain.V1,Brain.Tr1,Z[,1],Z[,2])$ind.inside
#' # Parameters for bivariate spline over triangulation;
#' d.est=5; r=1;
#' # simulation parameters
#' n=50; lam1=0.5; lam2=0.2; mu.func=2; noise.type='Func';
#' lambda=10^{seq(-6,3,0.5)}
#' dat=data1g.image(n,Z,ind.inside,mu.func,noise.type,lam1,lam2)
#' Y=dat$Y
#' tri.est=cv.image(Y,Z,d.est,r,V.ests,Tr.ests,lambda)
#' tri.est$tri.select; V.est=tri.est$V.est; Tr.est=tri.est$Tr.est;
#'
#' @export
cv.image <- function(Y,Z,d.est=5,r=1,V.ests,Tr.ests,lambda,nfold=10){
  Bfull <- basis.image(Z,V.ests,Tr.ests,d.est,r)
  B.ests <- Bfull$B.ests
  Q2.ests <- Bfull$Q2.ests
  K.ests <- Bfull$K.ests
  ind.inside <- Bfull$ind.inside

  n <- nrow(Y)
  npix <- length(ind.inside)
  Y <- Y[,ind.inside]

  ntri <- length(B.ests)
  ind.cv <- sample(1:n,size=n,replace=FALSE)
  fsize <- floor(n/nfold)
  fold.ids <- vector("list",length=nfold)
  for (ifold in 1:nfold){
    if (ifold<nfold){
      fold.ids[[ifold]] <- sort(ind.cv[(1:fsize)+(ifold-1)*fsize])
    } else if (ifold==nfold){
      fold.ids[[ifold]] <- sort(ind.cv[((ifold-1)*fsize+1):n])
    }
  }
  mse <- vector(length=ntri)
  for(itri in 1:ntri){
    B.est <- B.ests[[itri]];
    Q2.est <- Q2.ests[[itri]];
    K.est <- K.ests[[itri]];

    mse.cv <- lapply(fold.ids,FUN=function(ind.test){
      Y.train <- Y[-ind.test,]
      Y.test <- Y[ind.test,]
      Ym.train <- matrix(apply(Y.train,2,mean),nrow=1)
      mfit.train <- fit.mean(B.est,Q2.est,K.est,lambda,Ym.train)
      mu.train <- mfit.train$Yhat
      mu.test.mtx <- matrix(rep(t(mu.train),times=length(ind.test)),nrow=length(ind.test),byrow=TRUE)
      R0.test <- Y.test-mu.test.mtx
      mse <- apply(R0.test^2,1,mean)
      return(mse)
    })
    mse[[itri]] <- mean(unlist(mse.cv))
  }
  tri.select <- which.min(mse)
  B.est <- B.ests[[tri.select]]
  Q2.est <- Q2.ests[[tri.select]]
  K.est <- K.ests[[tri.select]]
  V.est <- V.ests[[tri.select]]
  Tr.est <- Tr.ests[[tri.select]]
  list(tri.select=tri.select,V.est=V.est,Tr.est=Tr.est,
       B.est=B.est,Q2.est=Q2.est,K.est=K.est)
}
