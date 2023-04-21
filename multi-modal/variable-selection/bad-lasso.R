library(rstan)
options(mc.cores = 4)
rstan_options(auto_write = TRUE)

#### generate samples ####
set.seed(42)
n <- 2

#x <- runif(n, -2,2)
x <- rep(1,n)
beta <- 5
y <- x * beta + rnorm(n, 0, 1)

#### sample ####
stan_data <- list(n = n, x = x, y = c(y))
stan_model <- stan_model("bad-lasso.stan")
bimodal <- sampling(stan_model,  data = stan_data, chains = 4, iter = 4000)

betas <- extract(bimodal,pars = c("beta"))$beta
png("beta.png", width = 6, height = 4, unit = "in", res = 300)
plot(density(betas), main = "", xlab = "", ylab = "density")
dev.off()
