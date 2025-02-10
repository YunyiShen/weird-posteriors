library(rstan)
options(mc.cores = 4)
rstan_options(auto_write = TRUE)

#### generate samples ####
set.seed(42)
n <- 5

#x <- runif(n, -2,2)
x <- rep(1,n)
beta <- 5
sdd <- 8
y <- x * beta + rnorm(n, 0, sdd)
#### brute force 

logposterior <- function(beta, lambda, y, x){
  loglik_ <- dnorm(y, beta * x, sdd, log = T) |> sum()
  prior_ <- dexp(abs(beta), lambda, log = T)
  #hyperprior <- dgamma(lambda, 0.1, 0.1, log = T)
  hyperprior <- dunif(lambda, 0.001, 10, log = T)
  loglik_+prior_+hyperprior
  
}

beta_val <- seq(-5, 20, length.out = 200)
lambda_val <- seq(0.01, 10, length.out = 200)
grid <- expand.grid(x = beta_val, y = lambda_val)
grid$logden <- 0
for(i in 1:nrow(grid)){
  grid$logden[i] <- logposterior(grid$x[i], grid$y[i], y, x)
}

png("beta_lambda.png", width = 6, height = 4, unit = "in", res = 300)
ggplot(grid, aes(x = x, y = y, z = exp(logden))) +
  geom_contour(bins = 30) + 
  xlab(expression(beta))+
  ylab(expression(lambda)) + 
  theme_bw()
dev.off()

plot(beta_val, rowSums(matrix(exp(grid$logden),200,200)))
write.csv(grid, "bad-lasso.csv")




#### sample ####
stan_data <- list(n = n, x = x, y = c(y))
stan_model <- stan_model("bad-lasso.stan")
bimodal <- sampling(stan_model,  data = stan_data, chains = 4, iter = 4000)

betas <- extract(bimodal,pars = c("beta"))$beta
png("beta.png", width = 6, height = 4, unit = "in", res = 300)
plot(density(betas), main = "", xlab = "", ylab = "density")
dev.off()
