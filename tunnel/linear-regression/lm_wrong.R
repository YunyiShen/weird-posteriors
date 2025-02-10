library(rstan)
library(MASS)
options(mc.cores = 2)
rstan_options(auto_write = TRUE)
stan_model <- stan_model("lm_wrong.stan")

#### generate samples ####
set.seed(42)
n <- 100
x <- mvrnorm(n, c(0,0), matrix(c(1,-.995,-.995,1),2,2))
beta <- c(-10,10)
y <- x %*% beta + rnorm(n)

#### brute force ####
logposterior <- function(betaa, x, pp){
  loglikelihood <- dnorm(x %*% betaa, 0, 1, log = T) |> sum()
  logp = log(pp)
  log1mp = log(1-pp)
  logprior <-  dnorm(betaa, 0, 100, log = T) |> sum()
  loglikelihood + logprior
}

beta_val <- seq(-5, 5, length.out = 100)
grid <- expand.grid(x = beta_val, y = beta_val)
grid$logden <- 0
for(i in 1:nrow(grid)){
  grid$logden[i] <- logposterior(c(grid$x[i], grid$y[i]), x, 0.1)
}

png("beta_unnormalized.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
ggplot(grid, aes(x = x, y = y, z = exp(logden))) +
  geom_contour(bins = 100) + 
  xlab(expression(beta[1]))+
  ylab(expression(beta[2])) + 
  theme_bw()
dev.off()
write.csv(grid, "lm_wrong.csv")


#### sample ####
stan_data <- list(n = n, x = x, y = c(y))
tunnel <- sampling(stan_model,  data = stan_data, chains = 1, iter = 4000)

betas <- extract(tunnel,pars = c("beta"))$beta
png("beta.png", width = 6, height = 4, unit = "in", res = 300)
plot(betas, xlab = "beta_1", ylab = "beta_2", pch = 16)
dev.off()


