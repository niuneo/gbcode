#' @import mvtnorm MASS

#### regrDataset ####
#' Generator of nonlinear regression dataset
#'
#' @author Gianluca Bontempi  \email{gbonte@@ulb.ac.be}
#' @references \url{mlg.ulb.ac.be}
#' @title Generator of nonlinear regression dataset
#'@export
#'
#'@param N: number of observations
#'@param n: number of observed variables
#'@param neff: number of effective features
#'@param sdn: standard deviation of Gaussian noise
#'@param seed: seed random generator
#'
#'@examples
#'
#'N<-100
#'n<-5
#'neff<-3
#'R<-regrDataset(N,n,neff,0.1)
#'X<-R$X
#'Y<-R$Y
#'@name regrDataset
#'
#'
#'
regrDataset<-function(N,n,neff,sdn,seed=0){
  set.seed(seed)
  Sigma=Posdef(n)
  X<-scale(rmvnorm(N,sigma=Sigma ))
  feat<-sample(n,neff)
  Y<-nonlin.fct(X[,feat],sample(11,1))+rnorm(N,sd=sdn)
  list(X=X,Y=Y,feat=feat)
}




Posdef <- function (n, ev = runif(n, 0, 10)) {
Z <- matrix(ncol=n, rnorm(n^2))
decomp <- qr(Z)
Q <- qr.Q(decomp)
R <- qr.R(decomp)
d <- diag(R)
ph <- d / abs(d)
O <- Q %*% diag(ph)
Z <- t(O) %*% diag(ev) %*% O
return(Z)
}

nonlin.fct<-function(X,f=1){
  n<-NCOL(X)
  N<-NROW(X)

  fx<-sample(n,sample(2:(n-2),1))
  fy<-setdiff(1:n,fx)
  if (length(fx)==1)
    x=abs(X[,fx])
  else
    x=apply(abs(X[,fx]),1,mean)

  if (length(fy)==1)
    y=abs(X[,fy])
  else
    y=apply(abs(X[,fy]),1,mean)

  switch(f,
         {Yhat=log(x^2+y^2)},
         {Yhat=sqrt(abs(sin(x^2+y^2)))},
         {Yhat=log(x*y^2+x^2*y)},
         {Yhat=sqrt(abs(x^2/(y+1)))},
         {Yhat=1/(x^2+y^2+1)},
         {Yhat=(x*sin(x*y))/(x^2+y^2+1)},
         {Yhat=y*exp(2*x^2)},
         {Yhat=y*sin(x)+x*sin(y)},
         {Yhat=(x^3-2*x*y+y^2)/(x^2+y^2+1)},
         {Yhat=x+y+apply(X[,fx],1,mean)},
         {Yhat=sin(x)+log(y)})

  return(Yhat)
}

