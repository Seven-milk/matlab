clc;clear;
x=xlsread('01.xlsx'); 
n=length(x);
for i=1:n
x(i)=(x(i)-min(x))/(max(x)-min(x));  %��һ��[��Сֵ������ֵ]
end