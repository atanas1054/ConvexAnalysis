clear; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimization problem              %
%                                   %
% min_x f(x),                       %
%                                   %
%     f(x) = 0.5*lambda*log(mu+x^2) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dom = -2:0.1:4;
lambda = 1;
mu = 0.1;
f = 0.5*lambda*log(mu+dom.^2);
f_opt = -1.1513; % TODO
x_opt = 0; % TODO

% parameter 
maxiter = 500;
check = 10;
L = 1.5811; % TODO

% initialization
x0 = 0.5;
f0 = 0.5*lambda*log(mu+x0^2);

% tape methods
xs = cell(0,0);
fs = cell(0,0);
cols = cell(0,0);
grads = cell(0,0);
legs = cell(0,0);
nmethods = 0;

% add legend entry for function plot
legs{end+1} = 'f';

% gradient descent with constant step size rule 1
if 1
  alphas = 1/L*ones(maxiter,1);
  [xs_, fs_, grads_] = gd(x0,alphas,maxiter,check,lambda,mu);

  xs{end+1} = xs_;
  fs{end+1} = fs_;
  grads{end+1} = grads_;
  cols{end+1} = [0,0.7,0];
  legs{end+1} = 'gd-cs1';
  nmethods = nmethods + 1;
end

% gradient descent with constant step size rule 2
if 1
  alphas = 2/L*ones(maxiter,1);
  [xs_, fs_, grads_] = gd(x0,alphas,maxiter,check,lambda,mu);

  xs{end+1} = xs_;
  fs{end+1} = fs_;
  grads{end+1} = grads_;
  cols{end+1} = [0,0.4,0];
  legs{end+1} = 'gd-cs2';
  nmethods = nmethods + 1;
end

% gradient descent with variable step size rule
if 1
  alphas = 2/L./(sqrt(1:maxiter));
  [xs_, fs_, grads_] = gd(x0,alphas,maxiter,check,lambda,mu);

  xs{end+1} = xs_;
  fs{end+1} = fs_;
  grads{end+1} = grads_;
  cols{end+1} = [0,0.0,0.9];
  legs{end+1} = 'gd-vs';
  nmethods = nmethods + 1;
end

% plot objective function and iterations of GD
figure(1);
plot(dom, f, 'LineWidth', 2, 'Color', 'red');
axis([dom(1), dom(end), f_opt, 2]);
hold on;
for imethod=1:nmethods
  plot(xs{imethod},fs{imethod},'o-', 'MarkerSize', 4, 'LineWidth', 1, 'Color', cols{imethod});
end
legend(legs);
hold off;


% convergence of function values
if 0
  LEGS = cell(0,0);
  figure(2);
  loglog((fs{1} - f_opt)./(f0-f_opt), 'LineWidth', 2, 'Color', cols{1});
  LEGS{end+1} = legs{2};
  hold on;
  for imethod=2:nmethods
    loglog((fs{imethod} - f_opt)./(f0-f_opt), 'LineWidth', 2, 'Color', cols{imethod});
    LEGS{end+1} = legs{1+imethod};
  end
  hold off;
  xlabel('iterations n');
  ylabel('(f(x^n)-f^*)/(f(x^0)-f^*)');
  legend(LEGS, 'Location', 'SouthWest');
end

% convergence of arguments 
if 0
  LEGS = cell(0,0);
  figure(4);
  loglog(abs(xs{1} - x_opt), 'LineWidth', 2, 'Color', cols{1});
  LEGS{end+1} = legs{2};
  hold on;
  for imethod=2:nmethods
    loglog(abs(xs{imethod} - x_opt), 'LineWidth', 2, 'Color', cols{imethod});
    LEGS{end+1} = legs{1+imethod};
  end
  hold off;
  xlabel('iterations n');
  ylabel('|x^n - x^*|');
  legend(LEGS);
end

% convergence of gradient
if 0
  LEGS = cell(0,0);
  figure(3);
  loglog(abs(grads{1}), 'LineWidth', 2, 'Color', cols{1});
  LEGS{end+1} = legs{2};
  hold on;
   for imethod=2:nmethods
    loglog(abs(grads{imethod}), 'LineWidth', 2, 'Color', cols{imethod});
    LEGS{end+1} = legs{1+imethod};
  end
  hold off;
  xlabel('iterations n');
  ylabel('|f^prime(x)|');
  legend(LEGS);
  % TODO 
end

%convergence rate

if 1
expression = (2*L*((0.5*lambda*log(mu+x0^2))-f_opt))^1/2;
n = [1:500];
n = 1./((n+1).^1/2);
n = n*expression;
figure(4);
plot(n);
  
end



