function bwimg = get_angular_bw_image(c)
bwimg   =   zeros(size(c));
bwimg(:,:)    = pi/2;                       %med bw
bwimg(c<=0.7) = pi;                         %high bw
bwimg(c>=0.9) = pi/6;                       %low bw