data {
  int<lower = 0> n;
  vector[n] y;
  vector[n] x;
}

parameters {
  real beta;
  real<lower = 0> sigma;
  real<lower = 0> lambda;
}

model {
    vector[n] mu;
    mu = beta * x;
    y ~ normal(mu, sigma);
    beta ~ double_exponential(0, lambda);
    sigma ~ gamma(.1, .1);
    lambda ~ gamma(.1, .1);
}

