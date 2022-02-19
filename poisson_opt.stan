data {
  int seasons; 
  int Gp[seasons]; 
  int Goals[seasons]; 
  real mean_sigma;
  real sd_sigma;
}

parameters {
  vector[(seasons-1)] lambda_0;
  real lmean_0;
  real<lower =0> sigma;
}transformed parameters{

vector[seasons] lambda;

lambda[1] = exp(lmean_0);




for(i in 2:seasons){

  
lambda[i] = lambda[i-1]*exp(lambda_0[i-1]*sigma);
  
}

}
model {

vector[seasons] lgp;

for(i in 1:seasons){
  lgp[i] = lambda[i]*Gp[i];
}

 
  Goals ~ poisson(lgp);
  
  
  lmean_0 ~ normal(log((7.0/16.0)),0.5); 
  lambda_0 ~ normal(0,1);
  

  sigma ~ normal(mean_sigma, sd_sigma)T[0.0,];
  
}
generated quantities{
  
  
  
  int pred_goals[seasons]; 

for(i in 1:seasons){
pred_goals[i] = poisson_rng(lambda[i]*Gp[i]);
}
  
}

