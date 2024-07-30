function mr = compute_mean_frequency(dEnergy,r)
global N_FFT;
num         =   sum(sum(dEnergy.*r));
den         =   sum(sum(dEnergy));
mr          =   num/(den+eps);
