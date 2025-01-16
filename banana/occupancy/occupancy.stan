// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> R;
  int<lower=0> TT;
  int<lower=0> y[R];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0, upper = 1> psi;
  real<lower=0, upper = 1> p;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  real tmp;
  for(i in 1:R){
    tmp = 0;
    tmp = y[i] * log(p) + (TT-y[i]) * log1m(p) + log(psi);
    if(y[i]==0){
      tmp = log_sum_exp(log1m(psi), tmp);
    }
    target += tmp;
  }
}

