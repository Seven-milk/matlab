clc;
clear;
X=xlsread('shuju2008.xlsx','D1:D55'); %
[M,N]=size(X);
for n=1:M-1
    X1=X(1:n,1);
    X2=X(n+1:M,1);
        R(n,1)=(n*std(X1,1,1)*std(X1,1,1)+(M-n)*std(X2,1,1)*std(X2,1,1))/(M*std(X,1,1)*std(X,1,1));
        F(n,1)=1*(M/n/(M-n)).^0.5*R(n,1)^(-(M-2)/2);% 式中k为比例常数，一般取k=1
end
plot(F);
