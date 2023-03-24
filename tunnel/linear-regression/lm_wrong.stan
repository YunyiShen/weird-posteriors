data {
  int<lower = 0> n;
  vector[n] y;
  matrix[n,2] x;
}

parameters {
  vector[2] beta;
  real<lower = 0> sigma;
}

model {
  
  y ~ normal(x * beta, sigma);
  
}

