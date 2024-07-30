
function [oimg,fimg,bwimg,eimg,enhimg] =  fingerprint_enhance(img)

%% initial data
global N_FFT;
N_FFT=32;     %size of FFT
block_sz=12;  %size of the block
over_lp=6;    %size of overlap
algha=0.4;    %root filtering
r_min=5;      %min allowable ridge spacing
r_max=20;     %maximum allowable ridge spacing
pre_filter =1;
[n_row,n_col]=size(img);
img=im2double(img);    %convert to DOUBLE

nblk_row=floor((n_row-2*over_lp)/block_sz);
nblk_col=floor((n_col-2*over_lp)/block_sz);
str_fft=zeros(nblk_row*nblk_col,N_FFT*N_FFT); %stores FFT
n_win =block_sz+2*over_lp; %size of analysis window.

warning off MATLAB:divideByZero

%% outputs
oimg=zeros(nblk_row,nblk_col);
fimg=zeros(nblk_row,nblk_col);
bwimg=zeros(nblk_row,nblk_col);
eimg=zeros(nblk_row,nblk_col);
enhimg=zeros(n_row,n_col);


%% precomputations

[x,y]=meshgrid(0:n_win-1,0:n_win-1);
dMult=(-1).^(x+y); %used to center the FFT
[x,y]=meshgrid(-N_FFT/2:N_FFT/2-1,-N_FFT/2:N_FFT/2-1);
r =sqrt(x.^2+y.^2)+eps;
th=atan2(y,x);
th(th<0) =th(th<0)+pi;
w=raised_cosine_window(block_sz,over_lp); %spectral window


%% FFT Analysis

for i = 0:nblk_row-1
    nRow = i*block_sz+over_lp+1;
    for j = 0:nblk_col-1
        nCol = j*block_sz+over_lp+1;
        
        %extract local block
        blk=img(nRow-over_lp:nRow+block_sz+over_lp-1,nCol-over_lp:nCol+block_sz+over_lp-1);
        
        %remove dc
        dAvg=sum(sum(blk))/(n_win*n_win);
        blk =blk-dAvg;   %remove DC content
        blk =blk.*w;     %multiply by spectral window
        
        % pre_filtering
        
        blkfft=fft2(blk.*dMult,N_FFT,N_FFT);
        if(pre_filter)
            dEnergy=abs(blkfft).^2;
            blkfft=blkfft.*sqrt(dEnergy);      %root filtering(for diffusion)
        end;
        str_fft(nblk_col*i+j+1,:) = transpose(blkfft(:));
        dEnergy =abs(blkfft).^2;             %----REDUCE THIS COMPUTATION----
        
        %compute statistics
        
        dTotal=sum(sum(dEnergy));%/(N_FFT*N_FFT);
        fimg(i+1,j+1)=N_FFT/(compute_mean_frequency(dEnergy,r)+eps); %ridge separation
        oimg(i+1,j+1)=compute_mean_angle(dEnergy,th);         %ridge angle
        eimg(i+1,j+1)=log(dTotal+eps);                        %used for segmentation
    end;%for j
end;%for i


%computations

[x,y]=meshgrid(-N_FFT/2:N_FFT/2-1,-N_FFT/2:N_FFT/2-1);
dMult=(-1).^(x+y); %used to center the FFT


%process the resulting maps

for i = 1:3
    oimg = smoothen_orientation_image(oimg);            %smoothen orientation image
end;
fimg=smoothen_frequency_image(fimg,r_min,r_max,5); %diffuse frequency image
cimg=compute_coherence(oimg);                    %coherence image for bandwidth
bwimg=get_angular_bw_image(cimg);                 %QUANTIZED bandwidth image
%-------------------------
%FFT reconstruction
%-------------------------
for i = 0:nblk_row-1
    for j = 0:nblk_col-1
        nRow = i*block_sz+over_lp+1;
        nCol = j*block_sz+over_lp+1;
        %--------------------------
        %apply the filters
        %--------------------------
        blkfft  =   reshape(transpose(str_fft(nblk_col*i+j+1,:)),N_FFT,N_FFT);
        %--------------------------
        %reconstruction
        %--------------------------
        af      =   get_angular_filter(oimg(i+1,j+1),bwimg(i+1,j+1));
        rf      =   get_radial_filter(fimg(i+1,j+1));
        blkfft  =   blkfft.*(af).*(rf);
        blk     =   real(ifft2(blkfft).*dMult);
        enhimg(nRow:nRow+block_sz-1,nCol:nCol+block_sz-1)=blk(over_lp+1:over_lp+block_sz,over_lp+1:over_lp+block_sz);
    end;%for j
end;%for i
%end block processing
%--------------------------
%contrast enhancement
%--------------------------
enhimg =sqrt(abs(enhimg)).*sign(enhimg);
enhimg =imscale(enhimg);
enhimg =im2uint8(enhimg);

%--------------------------
%clean up the image
%--------------------------
emsk            = segment_print(enhimg,0);
enhimg(emsk==0) = 128;
