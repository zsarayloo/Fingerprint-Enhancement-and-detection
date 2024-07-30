function y = raised_cosine(nblock_sz,nover_lp)
n_win  =   (nblock_sz+2*nover_lp);
x       =   abs(-n_win/2:n_win/2-1);
y       =   0.5*(cos(pi*(x-nblock_sz/2)/nover_lp)+1);
y(abs(x)<nblock_sz/2)=1;