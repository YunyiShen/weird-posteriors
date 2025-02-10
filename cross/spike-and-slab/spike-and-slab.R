library(rstan)
options(mc.cores = 2)
rstan_options(auto_write = TRUE)

#### generate samples ####
set.seed(43)
n <- 10

x <- matrix(runif(2*n, -2,2), n, 2)
beta <- c(0., 0.)
y <- x %*% beta + rnorm(n, 0, 1)

#### brute force ####
logaddexp <- function(a, b) {
  max_ab <- pmax(a, b)  # Element-wise max to prevent overflow
  return(max_ab + log(exp(a - max_ab) + exp(b - max_ab)))
}

logposterior <- function(betaa, x, y, pp){
  loglikelihood <- dnorm(y, x %*% betaa, 1, log = T) |> sum()
  logp = log(pp)
  log1mp = log(1-pp)
  logprior <- logaddexp( dnorm(betaa, 0, 0.1) + logp,  dnorm(betaa, 0, 100) + log1mp) |> sum()
  loglikelihood + logprior
}

beta_val <- seq(-2, 2, length.out = 100)
grid <- expand.grid(x = beta_val, y = beta_val)
grid$logden <- 0
for(i in 1:nrow(grid)){
  grid$logden[i] <- logposterior(c(grid$x[i], grid$y[i]), x, y,0.1)
}

library(ggplot2)
png("beta_unnormalized.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
ggplot(grid, aes(x = x, y = y, z = exp(logden))) +
  geom_contour(bins = 20) + 
  xlab(expression(beta[1]))+
  ylab(expression(beta[2])) + 
  theme_bw()
dev.off()
write.csv(grid, "spike-slab.csv")


#### sample ####
stan_data <- list(n = n, x = x, y = c(y), p = 0.1)
stan_model <- stan_model("spike-and-slab.stan")
cross <- sampling(stan_model,  data = stan_data, chains = 1, iter = 4000)

betas <- extract(cross,pars = c("beta"))$beta
png("beta.png", width = 6, height = 4, unit = "in", res = 300)
plot(betas, xlab = "beta_1", ylab = "beta_2", pch = 16, xlim = c(-2,2), ylim = c(-2,2))
dev.off()
