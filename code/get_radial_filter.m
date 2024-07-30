function rmsk = get_radial_filter(r0)
global N_FFT;
N          =   4;
r0         =   N_FFT/r0;
BW         =   r0*1.75-r0/1.75;
[x,y]      =   meshgrid(-N_FFT/2:N_FFT/2-1,-N_FFT/2:N_FFT/2-1);
r          =   sqrt(x.^2+y.^2);
num        =   (r*BW).^(2*N);
den        =   (r*BW).^(2*N)+((r.^2-r0.^2)).^(2*N);
rmsk       =   sqrt(num./den);