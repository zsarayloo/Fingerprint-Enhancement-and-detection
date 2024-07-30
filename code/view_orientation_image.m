function view_orientation_image(o,varargin)
    [h,w]   =   size(o);
    x       =   0:w-1;
    y       =   0:h-1;
    if(nargin == 1)
        quiver(x,y,cos(o),sin(o)); 
    else
        e = varargin{1};
        imagesc(e);
        quiver(x,y,e.*cos(o),e.*sin(o));
    end;
    axis([0 w 0 h]),axis image, axis ij;
