%fingerprint enhancement by STFT

clear all
close all
clc 

%%%%%%
img=imread('H (5).jpg');
nI= rgb2ycbcr(img);
I=nI(:,:,3);


[oriented_img,frequency_img,bandwith_img,energy_img,enh_img] =fingerprint_enhance(I);



figure,imshow(img),title('orginal image');

figure,imshow(enh_img),title('enhanced image');

figure,view_orientation_image(oriented_img,energy_img),title('oriented image');;

rgb_fimg=rgb_of_img(frequency_img);
figure,imshow(rgb_fimg),title('frequency image');

rgb_enimg=rgb_of_img(energy_img);
figure,imshow(rgb_enimg),title('energy image');

rgb_bwimg=rgb_of_img(bandwith_img);
figure,imshow(rgb_bwimg),title('angular coherence image');


