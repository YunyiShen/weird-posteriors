data {
  int<lower=0> R;       
  int<lower=0> T;       
  int<lower=0> y[R, T]; // Counts
  int<lower=0> K;       // Upper bound of population size
}

transformed data {
  int<lower=0> max_y[R];
  int<lower=0> N_ll;
  int foo[R];

  for (i in 1:R)
    max_y[i] = max(y[i]);
    
  for (i in 1:R) {
    foo[i] = K - max_y[i] + 1;
}
    N_ll = sum(foo);
}
   
parameters {
  real<lower = 0> lambda;
  real<lower = 0> p;
}

transformed parameters {
  real log_lambda=log(lambda); // Log population size
  real logit_p=logit(p); // Logit detection probability
}

model {
  
  for (i in 1:R) {
    vector[K - max_y[i] + 1] lp;

    for (j in 1:(K - max_y[i] + 1))
      lp[j] = poisson_log_lpmf(max_y[i] + j - 1 | log_lambda)
             + binomial_logit_lpmf(y[i] | max_y[i] + j - 1, logit_p);
    target += log_sum_exp(lp);
  }
}
