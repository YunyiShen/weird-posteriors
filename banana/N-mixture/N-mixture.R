library(rstan)
options(mc.cores = 2)
rstan_options(auto_write = TRUE)

#### generate samples ####
set.seed(42)
R <- 20
TT <- 5
p <- 0.1
lambda <- 30

y <- matrix(0, R,TT)

for(i in 1:R){
  Ni <- rpois(1,lambda)
  for(t in 1:TT){
    y[i,t] <- rbinom(1,Ni,p)
  }
}

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



