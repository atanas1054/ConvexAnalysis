function px = proj_halfspace(x, params)

% projection of x onto the half space
% {x \in \R^2 | <x,b> \leq \beta }
% output: px

% TODO
beta = params.beta;
b = params.b;

px = x + (beta - b'*x)*b/norm(b)^2;


end
