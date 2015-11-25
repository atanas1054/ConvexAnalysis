function [x_np1, seq_err, seq_E] = cg(x0,f,lambda,D,maxiter,check,x_opt, E_opt)

  fprintf('Conjugate Gradient method\n');
   
  %grid size
  h = 0.01;
  
  %A matrix
  A=zeros(length(f));
  A(1,1) = 1/h^2;
  A(1,2) = -1/h^2;
  A(length(f),length(f)) = 1/h^2;
  A(length(f),length(f)-1) = -1/h^2;
  for i=2:length(f)-1
      A(i,i-1) = -1/h^2;
      A(i,i+1) = -1/h^2;
      A(i,i) = 2/h^2;
  end
  A = eye(length(f))*lambda + A;
  
  %b is lambda*f
  r0 = lambda*f-A*x0;
  p0 = r0;
  r_n = r0;
  p_n = p0;
  x_n = x0;
 
  seq_err = [norm(x_opt-x_n)];
  seq_E = [E_opt - lambda/2*norm(x_n-f)^2+1/2*norm(D*x_n)^2];
  
  for iter=1:maxiter
  a_n = dot(r_n,r_n)/dot(p_n,A*p_n);
  x_np1 = x_n + a_n*p_n;
  r_np1 = r_n - a_n*A*p_n;
  b_n = dot(r_np1,r_np1)/dot(r_n,r_n);
  p_np1 = r_np1 + b_n*p_n;
  
  x_n = x_np1;
  r_n = r_np1;
  p_n = p_np1;
  
  seq_err = [seq_err,norm(x_opt-x_np1)^2];
  seq_E = [seq_E, abs(E_opt - lambda/2*norm(x_np1-f)^2+1/2*norm(D*x_np1)^2)];
	
	if mod(iter, check) == 0
      fprintf('  iteration: %4d, E = %10f,\n', iter,lambda/2*norm(x_n-f)^2+1/2*norm(D*x_n)^2);
    end
  
  end
  

end
  





