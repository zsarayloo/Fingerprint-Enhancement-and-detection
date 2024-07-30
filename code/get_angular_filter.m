function rmsk = get_angular_filter(t0,BW)
global N_FFT;
[x,y]   =   meshgrid(-N_FFT/2:N_FFT/2-1,-N_FFT/2:N_FFT/2-1);
r       =   sqrt(x.^2+y.^2);
th      =   atan2(y,x);
th(th<0)=   th(th<0)+2*pi;  %unsigned
t1      =   mod(t0+pi,2*pi);
%-----------------
%first lobe
%-----------------
d          = angular_distance(th,t0);
msk        = 1+cos(d*pi/BW);
msk(d>BW)  = 0;
rmsk       = msk;                              %save first lobe

%-----------------
%second lobe
%-----------------
d          = angular_distance(th,t1);
msk        = 1+cos(d*pi/BW);
msk(d>BW)  = 0;
rmsk       = (rmsk+msk);
