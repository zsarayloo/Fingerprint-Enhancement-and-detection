function mth = compute_mean_angle(dEnergy,th)
global N_FFT;
sth         =   sin(2*th);
cth         =   cos(2*th);
num         =   sum(sum(dEnergy.*sth));
den         =   sum(sum(dEnergy.*cth));
mth         =   0.5*atan2(num,den);
if(mth <0)
    mth = mth+pi;
end;
