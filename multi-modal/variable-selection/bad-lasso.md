# Bayesian Adaptive LASSO for variable selection

LASSO can be viewed as MAP of regression with Laplace prior. One can in turn put a prior on on the parameter of Laplace. By doing this one can have a meaningful bimodal posterior representing if the parameter is close to 0. 

In this example we estimate the mean of a Gaussian with unknown variance. We put a Laplace prior on the mean and Gamma prior on the variance. We put a Gamma prior on the parameter of Laplace.

![](https://raw.githubusercontent.com/YunyiShen/weird-posteriors/master/multi-modal/variable-selection/beta.png)