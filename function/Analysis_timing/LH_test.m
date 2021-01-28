function [num]=LH_test(date,x)
%% 变量说明
% x       输入待检验的序列，列存储
% date    日期矩阵,与x同维
% num      输出最大f对应的变异点
%% 程序主体
% 参数预设
n=length(x);
mu_tao=zeros(n-1,1);%τ对应的均值，τ=1：N-1
mu_ntao=zeros(n-1,1);%n-τ对应的均值
%计算均值序列
mu=mean(x);%全序列均值
for i=1:n-1%i=tao
    mu_tao(i)=mean(x(1:i));
    mu_ntao(i)=mean(x(n-i+1:n));
end
%计算r(τ)序列
S=zeros(n-1,1);
D=zeros(n-1,1);
Z=zeros(n-1,1);
for i=1:n-1%τ
    for j=1:i%第一个i
         S(i)=S(i)+(x(j)-mu_tao(i))^2;
    end
    for j1=i+1:n%第二个i
        D(i)=D(i)+(x(j1)-mu_ntao(n-i))^2;
    end
    for j2=1:n%第三个i
        Z(i)=Z(i)+(x(j2)-mu)^2;
    end
end
R=(S+D)./Z;%R
%计算f(τ)序列
f=zeros(n-1,1);
for i=1:n-1%i=tao
    f(i)=sqrt(n/(i*(n-i)))*(R(i))^((2-n)/2);
end
num=date(find(f==max(f)));
%% 绘图
figure
hold on 
date1=datenum(date);
num1=date1(find(f==max(f)));
plot(date1(1:n-1),f);
plot([num1 num1],get(gca,'YLim'),'r');
axis([date1(1),date1(n-1),min(f),max(f)]);
datetick('x','yyyy','keeplimits');%返回日期（年，月）显示
title('LH变异诊断');
xlabel('年份');
ylabel('概率密度值');
end
        
