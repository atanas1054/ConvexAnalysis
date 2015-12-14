function f = smooth_hinge(x)

eps_ = 0.1;

f = 1/2*((1-x)+sqrt((x-1).^2+eps_));


end