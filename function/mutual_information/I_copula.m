%二维互信息计算，基于copula熵
function [I,p]=I_copula(x,y)
%% 参数说明
%xy    两随机变量原始数据，列向量
%% 参数预设及相关性度量
n=length(x);%n 样本序列长度
p=corr(x,y);%p 两随机变量的相关系数
%% copula拟合
A=Bestfit_dan(x);%x单变量拟合
B=Bestfit_dan(y);%y单变量拟合
C=Bestfit_copulapdf(A,B);%copula拟合出概率密度
close all
%% 计算互信息，求和（积分）
I=-sum(log(C))/n;
end
%r=sqrt(1-exp(2*I));