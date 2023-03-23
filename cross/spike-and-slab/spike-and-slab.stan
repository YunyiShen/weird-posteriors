data {
  int<lower = 0> n;
  vector[n] y;
  matrix[n,2] x;
  real<lower = 0, upper = 1> p;
}

parameters {
  vector[2] beta;
  real<lower = 0> sigma;
}

model {
  vector[4] tmp;
  sigma ~ gamma(1,1);
  
  y ~ normal(x * beta, sigma);
  
  // spike-and-slab
  tmp[1] = normal_lpdf(beta[1] | 0, 0.1) + normal_lpdf(beta[2] | 0, 0.1) + 
          log(p) + log(p);
  tmp[2] = normal_lpdf(beta[1] | 0, 0.1) + normal_lpdf(beta[2] | 0, 100) + 
          log(p) + log(1-p);
  tmp[3] = normal_lpdf(beta[1] | 0, 100) + normal_lpdf(beta[2] | 0, 0.1) + 
          log(1-p) + log(p);
  tmp[4] = normal_lpdf(beta[1] | 0, 100) + normal_lpdf(beta[2] | 0, 100) + 
          log(1-p) + log(1-p);
  
  target += log_sum_exp(tmp);
  
}


