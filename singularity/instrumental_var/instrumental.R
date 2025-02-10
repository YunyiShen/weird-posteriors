library(MASS)
beta <- .1
Pi <- .1
sigma <- 1
n <- 50


set.seed(42)
z <- runif(n) < 0.75
x <- z * Pi + rnorm(n)
y <- x * beta + rnorm(n)

#### brute force ####

# see https://www.econstor.eu/bitstream/10419/86743/1/08-036.pdf

logposterior <- function(beta, Pi, x, y, z, n){
  kern <- matrix(nrow = 2, ncol = 2)
  kern[1,1] <- sum( (y-x * beta)^2)
  kern[1,2] <- kern[2,1] <- sum((y-x*beta)*(x-z*Pi))
  kern[2,2] <- sum((x-z*Pi)^2)
  
  determinant(kern)$modulus * (-n/2)
}

beta_val <- seq(-15, 15, length.out = 300)
grid <- expand.grid(x = beta_val, y = beta_val)
grid$logden <- 0
for(i in 1:nrow(grid)){
  grid$logden[i] <- logposterior(grid$x[i], grid$y[i], x, y, z, n)
}

png("beta_pi.png", width = 6, height = 4, unit = "in", res = 300)
ggplot(grid, aes(x = x, y = y, z = exp(logden-max(logden)))) +
  geom_contour(bins = 20) + 
  xlab(expression(beta))+
  ylab(expression(Pi)) + 
  theme_bw()
dev.off()

image(matrix(exp(grid$logden-max(grid$logden)), 300,300))
write.csv(grid,"instrument.csv")
