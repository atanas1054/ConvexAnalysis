load('mnist.mat')
eps_ = 0.1;
L = 100;
C = 100;
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
[w,TrainErrs1,TestErrs,Objective1] = SVM_GradientDescent(train_x,train_y,test_x,test_y,C,alphas,maxIter,eps_);
end

%figure,semilogy(Objective);

%Neterov's algorithm
if 1
[w,TrainErrs2,TestErrs,Objective2] = SVM_nesterov(train_x,train_y,test_x,test_y,C,maxIter,L,eps_);
end
figure,semilogy(Objective1);
hold on;
semilogy(Objective2);
hold off;
