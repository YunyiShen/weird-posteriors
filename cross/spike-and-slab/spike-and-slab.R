library(rstan)
options(mc.cores = 2)
rstan_options(auto_write = TRUE)

#### generate samples ####
set.seed(42)
n <- 10

x <- matrix(runif(2*n, -2,2), n, 2)
beta <- c(0., 0.)
y <- x %*% beta + rnorm(n, 0, 1)

#### sample ####
stan_data <- list(n = n, x = x, y = c(y), p = 0.1)
stan_model <- stan_model("spike-and-slab.stan")
cross <- sampling(stan_model,  data = stan_data, chains = 1, iter = 4000)

betas <- extract(cross,pars = c("beta"))$beta
png("beta.png", width = 6, height = 4, unit = "in", res = 300)
plot(betas, xlab = "beta_1", ylab = "beta_2", pch = 16, xlim = c(-2,2), ylim = c(-2,2))
dev.off()
