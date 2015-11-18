function [seq_x] = dykstra(x0,maxiter,check,proj_C,proj_D)

  fprintf('Dykstra projection algorithm\n');

  % initialization
  x_n = x0;
  p_n = 0;
  q_n = 0;
  
  % tape intermediate results
  seq_x = [x_n];
  
  for iter=1:maxiter
  
	y_n = proj_circle(x_n+p_n,proj_D.params);
	p_np1 = x_n + p_n - y_n;
	x_np1 = proj_halfspace(y_n+q_n,proj_C.params)
	q_np1 = y_n + q_n - x_np1;
    % TODO
    % tape intermediate results
    seq_x = [seq_x, x_np1];
	
	x_n = x_np1;
	p_n = p_np1;
	q_n = q_np1;

    if mod(iter, check) == 0
      fprintf('  iteration: %4d, x = (%5.2f,%5.2f)\n', iter, x_np1);
    end
  
    if norm(proj_C.fun(x_np1,proj_C.params)-proj_D.fun(x_np1,proj_D.params)) < 0.001
	break
	end
  end

