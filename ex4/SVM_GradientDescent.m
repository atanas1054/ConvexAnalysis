function [w,seq_TrainErrs,seq_TestErrs,seq_Objective] = SVM_GradientDescent(Xtrain,Ytrain,Xtest,Ytest,C,alphas,maxIter,eps_)

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
seq_TestErrs = [];
seq_Objective = [];
seq_TrainErrs = [];

for iter=1:maxIter

%compute the gradient of the objective (with respect to w)
temp = Ytrain.*(Xtrain*w_n);
temp1 = 1/2*( (temp - 1 )./(sqrt((temp - 1).^2 + eps_)) - 1);
temp2 =  bsxfun(@times, Xtrain, Ytrain);
temp3 = bsxfun(@times, temp2,temp1);
grad_w = (sum(temp3)*C/M)' + w_n;

%update w (gradient descent step)
w_np1 = w_n - alphas(iter)*grad_w;

w_n = w_np1;

prev_Objective = Objective;
Objective = C/M*smooth_hinge((Xtrain*w_n)'*Ytrain)+1/2*norm(w_n,2).^2;
%store objective values
seq_Objective = [seq_Objective, Objective];

fprintf(' iteration: %4d, Objective = %10f \n', iter, Objective);

TrainErr = sum(sign(Xtrain*w_n) ~= Ytrain) / size(Ytrain,1);
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