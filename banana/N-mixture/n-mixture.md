## N-mixture model

This is a very widely used model among ecologists to estimate number of (unmarked) individuals by repeated counts. By [Royle 2003](https://onlinelibrary.wiley.com/doi/full/10.1111/j.0006-341X.2004.00142.x)

We implemented a simpler version here, where there are R sites and each site is sampled T repeats, the data y_{it} are counts. The model is there is a latent N_i~Pois(lambda) and y_{it}~Bin(N_i, p) independent, the goal is to estimate p and lambda. 

![](https://raw.githubusercontent.com/YunyiShen/weird-posteriors/master/banana/N-mixture/p_lambda.png)
