library(rstan)
options(mc.cores = 4)
rstan_options(auto_write = TRUE)

#### generate samples ####
set.seed(42)
TT <- 5

mu <- -1.02
phi <- -0.95
sigma <- 0.1

epst <- rnorm(TT, 0, 1)
deltat <- rnorm(TT, 0, 1)

h <- c()
h[1] <- rnorm(1, mu, sigma/sqrt(1-phi^2))
for(t in 2:TT){
  h[t] <- mu + phi * (h[t-1] - mu) + sigma * epst[t]
}

y <- rnorm(TT, 0, exp(h/2))

#### sample ####
stan_model <- stan_model("stochastic-volacity.stan")

stan_data <- list(T = TT, y = y)
mushroom <- sampling(stan_model,  data = stan_data, chains = 2, iter = 4000)

param <- extract(mushroom,pars = c('mu','phi'))
pairs(param)
png("mu_phi.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
plot(param$mu, param$phi, xlab = "mu", ylab = "phi", pch = 16)
dev.off()
