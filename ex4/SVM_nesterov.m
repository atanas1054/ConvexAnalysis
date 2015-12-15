function [w,seq_TrainErrs,seq_TestErrs,seq_Objective] = SVM_nesterov(Xtrain,Ytrain,Xtest,Ytest,C,maxIter,L,eps_)

%add 1 to the last column of Xtrain (to get rid of b)
Xtrain(:,size(Xtrain,2)+1) = 1;
Xtest(:,size(Xtest,2)+1) = 1;
w_n = zeros(size(Xtrain,2),1);
%get only the labels for the digit '0'
Ytrain = Ytrain(:,1);
Ytrain = (2*Ytrain/(max(Ytrain)))-1;
Ytest = Ytest(:,1);
Ytest = (2*Ytest/(max(Ytest)))-1;
M = size(Xtrain,1);
Objective = [];
TrainErrs = [];
TestErros = [];
seq_Objective = [];
seq_TrainErrs = [];
seq_TestErrs = [];
y_w_n = w_n;
alpha_n = rand();


for iter=1:maxIter

%compute the gradient of the objective with respect to w
temp = Ytrain.*(Xtrain*y_w_n);
temp1 = 1/2*( (temp - 1 )./(sqrt((temp - 1).^2 + eps_)) - 1);
temp2 =  bsxfun(@times, Xtrain, Ytrain);
temp3 = bsxfun(@times, temp2,temp1);
grad_y_n  = (sum(temp3)*C/M)' + y_w_n;

w_np1 = y_w_n - 1/L*grad_y_n;
alpha_np1 = alpha_n/2*(-alpha_n + sqrt(alpha_n^2+4));
beta_n = alpha_n*(1-alpha_n)/(alpha_n^2+alpha_np1);
y_w_np1 = w_np1 + beta_n*(w_np1-w_n);

w_n = w_np1;
y_w_n = y_w_np1;
alpha_n = alpha_np1;

%store all the objective values
prev_Objective = Objective;
Objective = C/M*smooth_hinge((Xtrain*w_n)'*Ytrain)+1/2*norm(w_n,2).^2;
seq_Objective = [seq_Objective, Objective];
fprintf(' iteration: %4d, Objective = %10f \n', iter, Objective);

%calculate the trainerror by counting the missclassifications 
TrainErr = sum(sign(Xtrain*w_n) ~= Ytrain)/ size(Ytrain,1);
seq_TrainErrs = [seq_TrainErrs,TrainErr];

TestErr = sum(sign(Xtest*w_n) ~= Ytest) / size(Ytest,1);
seq_TestErrs = [seq_TestErrs,TestErr];

%stopping criteria
 if abs(Objective - prev_Objective) <0.001
 break
 end

end

w = w_n;

end