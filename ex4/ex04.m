load('mnist.mat')
Xtrain = train_x;
Xtrain(:,size(Xtrain,2)+1) = 1;
Ytrain = train_y;
Ytrain = Ytrain(:,1);
Ytrain = (2*Ytrain/(max(Ytrain)))-1;

eps_ = 0.1;
C = 100;
%L = C/2*eps_^(-1/2)*sum(Ytrain.*Xtrain) + 1;
L = 100;
maxIter = 1000;
alphas = 1/L*ones(maxIter,1);

%plot hinge loss
x=[-10:0.1:10];
y = max(0,1-x);
plot(x,y);

%plot smooth hinge loss
y = smooth_hinge(x);
figure,plot(x,y);


%Gradient descent
if 1
[w1,TrainErrs1,TestErrs1,Objective1] = SVM_GradientDescent(train_x,train_y,test_x,test_y,C,alphas,maxIter,eps_);
end

%figure,semilogy(Objective);

%Neterov's algorithm
if 1
[w2,TrainErrs2,TestErrs2,Objective2] = SVM_nesterov(train_x,train_y,test_x,test_y,C,maxIter,L,eps_);
end
figure,semilogy(Objective1);
hold on;
semilogy(Objective2);
hold off;
