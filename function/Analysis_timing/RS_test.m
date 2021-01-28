%RS的变异诊断
function [deta_H,flag]=RS_test(x,d)%,输出flag_max,deta_H_max
%% 参数说明
% x 待检验的序列,输入列向量
% d 参数，最小段长度，通常取10
% deta_H 输出的绝对值H差，是从d~n-d这么长，最大的地方为变异点
% flag 对应于deta_H的序号
% % flag_max 最大deta_H的序号
% % deta_H_max 最大deta_H
%% 参数预设
n1=length(x);
%% 对切割点两端计算指数差
for i1=d:n1-d
    x_left=x(1:d);
    x_right=x(d+1:end);
    deta_H(i1-d+1)=abs(RS_(x_left)-RS_(x_right));
end
flag=[d:n1-d];
% flag_max=flag(find(deta_H==max(deta_H))-d+1);
% deta_H_max=max(deta_H);
%% 绘图
figure 
plot(flag-d+1,deta_H);
xlabel('序号');
ylabel('deta_H');
title('R/S变异诊断');
%-----------------------------------------------------------------------子函数，为了区分改为RS_
function [H]=RS_(x)
%% 预设参数
n=length(x);
n_max=floor(n/2);%最大区间长度为floor(n/2),因为区间数目要大于1
%% 计算RS统计量R_S
%划分区间计算区间内的RS
for i=2:n_max%以长度i划分子区间,最小为2，因为计算极差最小要有两个
    m=floor(n/i);%区间数目
%     while m>1%区间数目需要大于1，前面定义了，肯定大于1 
    x_=x(1:m*i);%取整为x_
    x_1=reshape(x_,i,m);%分区间
      for j=1:m%每个区间内计算
    mu(j)=mean(x_1(:,j));%区间均值序列
    s(j)=std(x_1(:,j));%区间标准差
        for j1=1:length(x_1(:,j))
            b(j1,j)=sum(x_1(1:j1,j)-mu(j));%区间累积离差
        end
    b1(j)=max(b(:,j))-min(b(:,j));%区间极差
      end
    RS(i-1)=mean(b1./s);%计算RS
%     clear mu s b b1
end
%% 最小二乘，计算Hrust指数
%log(RS)~log([2:n_max])
t=log([2:n_max]);%区间长度对数化序列
H_=polyfit(t,log(RS),1);%拟合出系数
H=H_(1);%斜率即为H指数
end
end
    
   

    
    
    
    
    
    
    

