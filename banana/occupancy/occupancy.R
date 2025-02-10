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

### brute force ##
logaddexp <- function(a, b) {
  max_ab <- pmax(a, b)  # Element-wise max to prevent overflow
  return(max_ab + log(exp(a - max_ab) + exp(b - max_ab)))
}

loglikoccu <- function(psi, p, y, TT){
  with_occu <- dbinom(y, TT, p, log = T)
  wo_occu <- dbinom(y, 0, p, log = T)
  sum(logaddexp( with_occu + log(psi), wo_occu + log(1-psi)))
}


p_vals <- seq(0.01, 0.99, length.out = 200)
psi_vals <- seq(0.01, 0.99, length.out = 100)
grid <- expand.grid(x = psi_vals, y = p_vals)
grid$logden <- 0

for(i in 1:nrow(grid)){
  grid$logden[i] <- loglikoccu(grid$x[i], grid$y[i], y, TT)
}

library(ggplot2)
png("p_psi_unnormalized.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
ggplot(grid, aes(x = x, y = y, z = exp(logden))) +
  geom_contour(bins = 20) + 
  xlab(expression(psi))+
  ylab("p") + 
  theme_bw()
dev.off()
write.csv(grid, "occu_unnormalized_den.csv")



### sampling ####
stan_data <- list(R = R, TT = TT, y = y)
model <- stan_model("./occupancy.stan")

samples <- sampling(model,  data = stan_data, chains = 4,
                    init = function() list(p = .5, psi = 0.5))


psi_p <- extract(samples,pars = c('psi','p'))
png("p_psi.png", width = 6, height = 4, unit = "in", res = 300)
par(mar = c(3,3,2,2), mgp = c(1.8, 0.5, 0))
plot(psi_p$psi, psi_p$p, xlab = "psi", ylab = "p", pch = 16)
dev.off()
