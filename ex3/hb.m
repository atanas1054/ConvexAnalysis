function [x_np1, seq_err, seq_E] = hb(x0,f,lambda,D,alpha,beta,maxiter,check,x_opt, E_opt)

  if beta == 0
    fprintf('Gradient Descent method\n');
  else
    fprintf('Heavy-ball method\n');
  end
  
  x_n = x0; 
  x_n_1 = zeros(size(f,1),1);
  seq_err = [norm(x_opt-x_n,1)^2];
  seq_E = [E_opt - lambda/2*norm(x_n-f)^2+1/2*norm(D*x_n)^2];
  
  %grid size
  h = 0.01;
  
  %get a preliminary matrix in order to compute the gradient of E
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
	
  for iter=1:maxiter
	
	%gradient of E
	grad = A*x_n - lambda*f;
	x_np1 = x_n - alpha*grad+beta*(x_n-x_n_1);
	
	x_n_1 = x_n;
	x_n = x_np1;
	
	seq_err = [seq_err,norm(x_opt-x_np1,1)];
	seq_E = [seq_E, abs(E_opt - (lambda/2*norm(x_np1-f)^2+1/2*norm(D*x_np1)^2))];
	
	if mod(iter, check) == 0
      fprintf('  iteration: %4d, E = %10f,\n', iter,lambda/2*norm(x_np1-f)^2+1/2*norm(D*x_np1)^2);
    end
	 
  end
  
  end

