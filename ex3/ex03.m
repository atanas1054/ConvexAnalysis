clear; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimization problem                        %
%                                             %
% min_u 0.5lambda||u-f||^2 + 0.5||D^h u||^2   %
%                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = 0.01;
domx = [0:h:pi];
load('data.mat','f','x_opt','E_opt'); 
N = length(f);
lambda = 180.0;
D = make_derivative_1D(N,h);

% algorithm parameters
L = lambda+4/h^2;
maxiter = 200;
check = 10;

% tape methods
xs = cell(0,0);
errs = cell(0,0);
Es = cell(0,0);
cols = cell(0,0);
legs = cell(0,0);
nmethods = 0;

% gradient descent
if 1
  % find optimal alpha
  alpha = 1.97/L;
  [x,seq_err,seq_E] = hb(f,f,lambda,D,alpha,0,maxiter,check,x_opt,E_opt);
  xs{end+1} = x;
  errs{end+1} = seq_err;
  Es{end+1} = seq_E;
  cols{end+1} = [0,0,0.8];
  legs{end+1} = 'gd';
  nmethods = nmethods + 1;
end

% heavy ball method
if 0
  % find optimal beta
  alpha = 1/L;
  beta = 0;
  [x,seq_err,seq_E] = hb(f,f,lambda,D,alpha,beta,maxiter,check,x_opt,E_opt);
  xs{end+1} = x;
  errs{end+1} = seq_err;
  Es{end+1} = seq_E;
  cols{end+1} = [0,0.7,0];
  legs{end+1} = 'hb';
  nmethods = nmethods + 1;
end

% heavy ball method (optimal)
if 0
  m = lambda;
  % TODO: set alpha, beta
  alpha = 4/(sqrt(L)+sqrt(m))^2;
  beta = ((sqrt(L)-sqrt(m))/(sqrt(L)+sqrt(m)))^2;
  [x,seq_err,seq_E] = hb(f,f,lambda,D,alpha,beta,maxiter,check,x_opt,E_opt);
  xs{end+1} = x;
  errs{end+1} = seq_err;
  Es{end+1} = seq_E;
  cols{end+1} = [0,1.0,0];
  legs{end+1} = 'hb opt';
  nmethods = nmethods + 1;
end

% conjugate gradient method
if 0
  [x,seq_err,seq_E] = cg(f,f,lambda,D,maxiter,check,x_opt,E_opt);
  xs{end+1} = x;
  errs{end+1} = seq_err;
  Es{end+1} = seq_E;
  cols{end+1} = [0.6,0,0];
  legs{end+1} = 'cg';
  nmethods = nmethods + 1;
end

% visualize the results
LEGS = cell(0,0);
figure(10);
plot(domx, f, 'LineWidth', 2, 'Color', [0.6,0.6,0.6]);
LEGS{end+1} = 'noisy signal';
axis([domx(1),domx(end),-1.2,1.2]);
hold on;
plot(domx,x_opt, '--', 'LineWidth', 2, 'Color', [0.9,0,0]);
LEGS{end+1} = 'direct method';
for i=1:length(cols)
  plot(domx, xs{i}, 'LineWidth', 2, 'Color', cols{i});  LEGS{end+1} = legs{i};
end
hold off;
legend(LEGS);

% convergence analysis

% TODO
if 0
%convergence of errors
  LEGS = cell(0,0);
  figure(11);
  loglog(errs{1}, 'LineWidth', 2, 'Color', cols{1});
  LEGS{end+1} = legs{1};
  hold on;
   for imethod=2:nmethods
    loglog(errs{imethod}, 'LineWidth', 2, 'Color', cols{imethod});
    LEGS{end+1} = legs{imethod};
  end
  hold off;
  xlabel('iterations n');
  ylabel('Sequence Error');
  legend(LEGS);
end

if 0
%convergence of function values
  LEGS = cell(0,0);
  figure(12);
  loglog(Es{1}, 'LineWidth', 2, 'Color', cols{1});
  LEGS{end+1} = legs{1};
  hold on;
   for imethod=2:nmethods
    loglog(Es{imethod}, 'LineWidth', 2, 'Color', cols{imethod});
    LEGS{end+1} = legs{imethod};
  end
  hold off;
  xlabel('iterations n');
  ylabel('Objective function error');
  legend(LEGS);
end



