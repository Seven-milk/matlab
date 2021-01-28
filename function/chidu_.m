function  [X]=chidu_(x,q)
%尺度计算，输入一个月尺度的向量值x，输出各尺度矩阵X，[尺度1向量 尺度2向量 尺度3向量 尺度4向量]
%% 参数说明
% x 一个月尺度向量
% q 需要计算的尺度
% X 各尺度向量矩阵
%% 程序主体
n=length(x);
X=zeros(n,q);
for i=1:q
%     x_=zeros(n-i+1,1);
%     for j=1:length(x_)
%     x_(j)=sum(x(j:j+i-1));
    for j=1:(n-i+1)
    X(j+i-1,i)=sum(x(j:j+i-1));
    end
%     X(:,i)=x_;
end
end