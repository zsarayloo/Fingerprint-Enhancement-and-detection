function d = angular_distance(th,t0)
d = abs(th-t0);
d = min(d,2*pi-d);