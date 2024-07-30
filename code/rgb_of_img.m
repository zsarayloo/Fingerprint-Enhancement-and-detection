function a=rgb_of_img(I)
im=I;
m=mat2gray(im);
in=gray2ind(m,256);
rgb=ind2rgb(in,hot(256));
a = imresize(rgb,[300,200]);


end
