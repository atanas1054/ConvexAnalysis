clear; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimization problem              %
%                                   %
% find x \in C \cap D               %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define the sets and projection functions
[X,Y] = meshgrid(0.5:0.001:3.0,-1.5:0.001:1.0);

b = [1;1];
beta  = 1.0;
C = X.*b(1) + Y*b(2) <= beta;
r2 = 3/2;
c2 = [r2;r2];
D = sqrt((X-c2(1)).^2 + (Y-c2(2)).^2) <= r2;

proj_C.fun = @proj_halfspace;
params_C.b = b;
params_C.beta = beta;
proj_C.params = params_C;
proj_D.fun = @proj_circle;
params_D.c = c2;
params_D.r = r2;
proj_D.params = params_D;

% visualize the sets in figure 1
figure(1);
contour(X,Y,C,[0.5,0.5],'LineWidth', 1, 'Color','red');
hold on;
contour(X,Y,D,[0.5,0.5],'LineWidth', 1, 'Color','blue');
hold off;
axis equal;
axis([X(1,1),X(1,end),Y(1,1),Y(end,1)])

% parameter 
maxiter = 100;
check = 10;

% initialization
x0 = [2.5;-1];

% tape methods
xs = cell(0,0);
cols = cell(0,0);
grads = cell(0,0);
legs = cell(0,0);
nmethods = 0;

% add legend entry for function plot
legs{end+1} = 'C';
legs{end+1} = 'D';

% alternating projection method
if 1
  xs{end+1} = pocs(x0,maxiter,check,proj_C,proj_D);
  cols{end+1} = [0,0.7,0];
  legs{end+1} = 'pocs';
  nmethods = nmethods + 1;
end

% averaged projection method
if 1
  xs{end+1} = avrg_proj(x0,maxiter,check,proj_C,proj_D);
  cols{end+1} = [0,0,0.7];
  legs{end+1} = 'avrg proj';
  nmethods = nmethods + 1;
end

% Dykstra's projection algorithm 
if 1
  xs{end+1} = dykstra(x0,maxiter,check,proj_C,proj_D);
  cols{end+1} = [0.7,0,0];
  legs{end+1} = 'dykstra';
  nmethods = nmethods + 1;
end

figure(1);
hold on;
for imethod=1:nmethods
  plot(xs{imethod}(1,:),xs{imethod}(2,:),'x-', 'MarkerSize', 8, 'LineWidth', 1, 'Color', cols{imethod});
end
hold off;
legend(legs);


