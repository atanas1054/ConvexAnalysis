function [seq_x,seq_f,seq_grad] = gd(x0,alphas,maxiter,check,lambda,mu)

  fprintf('Gradient Descent\n');

  % initialization
  x_n = x0; % TODO
  f_n = 0.5*lambda*log(mu+x_n^2); % TODO

  % tape intermediate results
  seq_x = [x_n];
  seq_f = [f_n];
  seq_grad = [];
  
  for iter=1:maxiter
  
    % TODO
	grad = lambda*x_n / (x_n^2 + mu);
	x_np1 = x_n - alphas(iter)*grad;
	f_np1 = 0.5*lambda*log(mu+x_np1^2);
	%x(n+1) = x(n) -alpha*grad(f(x(n)))

    % tape intermediate results
    seq_x = [seq_x, x_np1];
    seq_f = [seq_f, f_np1];
    seq_grad = [seq_grad, grad];
	
	x_n = x_np1;
  
    if mod(iter, check) == 0
      fprintf('  iteration: %4d, x = %10f, f(x) = %10f, |f^prime(x)|: %10f\n', iter, x_np1, f_np1, abs(grad));
    end
  
  end

