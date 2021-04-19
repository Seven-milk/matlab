% 刘朋编写克拉默突变检验
clc;
clear;
x=xlsread('shuju2008.xlsx','A1:A55'); 
y=xlsread('shuju2008.xlsx','I1:I55'); 
n=length(y);
n1=5; %步长取五年
t=fix(n/n1);
Y=mean(y);
Var=var(y);
for i=1:n-4
    Y1(i,1)=mean(y(i:i+4));
    t1(i,1)=mean(Y1(i));
    t(i,1)=(t1(i)-Y)/Var;
    T(i,1)=sqrt((n1*(n-2))/(n-n1*(1+t(i))))*t(i);
end

plot(T);