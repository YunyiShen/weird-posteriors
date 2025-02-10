library(rstan)
options(mc.cores = 2)
rstan_options(auto_write = TRUE)

#### generate samples ####
set.seed(42)
R <- 20
TT <- 5
p <- 0.1
lambda <- 20

y <- matrix(0, R,TT)

for(i in 1:R){
  Ni <- rpois(1,lambda)
  for(t in 1:TT){
    y[i,t] <- rbinom(1,Ni,p)
  }
}

##### brute force the unnormalized posterior ####


loglikNmix <- function(lambda, p, y, K = 200){
  poislik <- dpois(0:K, lambda, log = T)
  poislik <- poislik-log(sum(exp(poislik)))
  binomlik <- sapply(0:K, function(
    N, yy, pp) rowSums(dbinom(yy, N, p, log = T)), yy = y, pp = p)
  apply(binomlik, 1, `+`, poislik) |> exp() |> colSums() |> log() |> sum()
}

p_vals <- seq(0.01, 0.99, length.out = 200)
lambda_vals <- seq(0.1, 100, length.out = 100)
grid <- expand.grid(x = lambda_vals, y = p_vals)
grid$logden <- 0

for(i in 1:nrow(grid)){
  grid$logden[i] <- loglikNmix(grid$x[i], grid$y[i],y)
}
library(ggplot2)

png("p_lambda_unnormalized.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
ggplot(grid, aes(x = x, y = y, z = exp(logden))) +
  geom_contour(bins = 10) + 
  xlab(expression(lambda))+
  ylab("p") + 
  theme_bw()
dev.off()


write.csv(grid, "nmixture_unnormalized_den.csv")

#### sample ####
stan_data <- list(K = 100, 
                  R = R,
                  T = TT, 
                  y = y)

stan_model <- stan_model("N-mixture.stan")

banana <- sampling(stan_model,  data = stan_data, chains = 1,
                   init = function() list(p = .5, lambda = 20))



#### plot ####
lambda_p <- extract(banana,pars = c('lambda','p'))
png("p_lambda.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
plot(lambda_p$lambda, lambda_p$p, xlab = "lambda", ylab = "p", pch = 16)
dev.off()



