data {
  int N; // number of data points
  int S; // number of subjects
  vector[N] measured_error;
  vector[N] subject;
  vector[N] phase;
}
parameters {
  // subject level means and SDs
  vector[S] mu_subject;
  vector[S]<lower=0> sigma_subject;
  
  // subject level change parameter
  vector[S] mu_subject_change;
  vector[S] sigma_subject_change;
  
  // group level means and SDs
  real mu_mean;
  real<lower=0> mu_sd;
  
  real sigma_mode;
  real<lower=0> sigma_sd;
  
  real mu_change_mean;
  real<lower=0> mu_change_sd;
  
  real sigma_change_mean;
  real<lower=0> sigma_change_sd;
}
transformed parameters{
  vector[N] mu_calculated;
  vector[N] sd_calculated;
  
  real sigma_shape;
  real sigma_rate;
  
  for(i in 1:N){
    mu_calculated[N] = mu_subject[subject[N]] + phase[N]*mu_subject_change[subject[N]];
    sigma_calculated[N] = sigma_subject[subject[N]] + phase[N]*sigma_subject_change[subject[N]];
  }
  
  sigma_rate = ( sigma_mode + sqrt( sigma_mode^2 + 4*sigma_sd^2 ) ) / ( 2 * sigma_sd^2 );
  sigma_shape = 1 + sigma_mode * sigma_rate;
}
model {
  measured_error ~ normal(mu_calculated, sigma_calculated);
  mu_subject ~ normal(mu_mean, mu_sd);
  sigma_subject ~ gamma(sigma_rate, sigma_shape);
  mu_change_subject ~ normal(mu_change_mean, mu_change_sd);
  sigma_change_subject ~ normal(sigma_change_mean, sigma_change_sd);
  
  mu_mean ~ normal(0, 10);
  mu_sd ~ gamma();
  sigma_mode ~ gamma();
  sigma_sd ~ gamma();
  mu_change_mean ~ normal(0,5);
  mu_change_sd ~ gamma();
  sigma_change_mean ~ normal(0, 100);
  sigma_change_sd ~ gamma();
  
}