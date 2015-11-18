function [seq_x] = pocs(x0,maxiter,check,proj_C,proj_D)

  fprintf('Alternating projection method\n');

  % initialization
  x_n = x0;

  % tape intermediate results
  seq_x = [x_n];
  
  for iter=1:maxiter
  
    % TODO
	pd = proj_circle(x_n,proj_D.params);
	x_np1 = proj_halfspace(pd,proj_C.params);
    
    % tape intermediate results
    seq_x = [seq_x, x_np1];
	
	x_n = x_np1;
  
    if mod(iter, check) == 0
      fprintf('  iteration: %4d, x = (%5.2f,%5.2f)\n', iter, x_np1);
    end
	
	 if norm(proj_C.fun(x_np1,proj_C.params)-proj_D.fun(x_np1,proj_D.params)) < 0.001
	break
	end
  
  end

