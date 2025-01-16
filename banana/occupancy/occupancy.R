library(rstan)
options(mc.cores = 2)
rstan_options(auto_write = TRUE)


set.seed(42)
R <- 100 # sites
TT <- 8 # secondary occasions
p <- 0.1
psi <- 0.1

occupancy <- runif(R) < psi
detection <- matrix(runif(R * TT), R, TT) < p
detection <- detection * (occupancy %*% t(rep(1,TT)))

y <- rowSums(detection)

stan_data <- list(R = R, TT = TT, y = y)
model <- stan_model("./occupancy.stan")

samples <- sampling(model,  data = stan_data, chains = 4,
                    init = function() list(p = .5, psi = 0.5))


psi_p <- extract(samples,pars = c('psi','p'))
png("p_psi.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
plot(psi_p$psi, psi_p$p, xlab = "psi", ylab = "p", pch = 16)
dev.off()
