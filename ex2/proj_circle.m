function px = proj_circle(x, params)

  r = params.r; % radius of the circle
  c = params.c; % center of the circle

  px = c+r*([x(1)-c(1);x(2)-c(2)])/norm(([x(1)-c(1);x(2)-c(2)])); %TODO;
 
end
