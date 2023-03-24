library(rstan)
library(MASS)
options(mc.cores = 2)
rstan_options(auto_write = TRUE)
stan_model <- stan_model("lm_wrong.stan")

#### generate samples ####
set.seed(42)
n <- 100
x <- mvrnorm(n, c(0,0), matrix(c(1,.995,.995,1),2,2))
beta <- c(-10,10)
y <- x %*% beta + rnorm(n)

#### sample ####
stan_data <- list(n = n, x = x, y = c(y))
tunnel <- sampling(stan_model,  data = stan_data, chains = 1, iter = 4000)

betas <- extract(tunnel,pars = c("beta"))$beta
png("beta.png", width = 6, height = 4, unit = "in", res = 300)
plot(betas, xlab = "beta_1", ylab = "beta_2", pch = 16)
dev.off()


