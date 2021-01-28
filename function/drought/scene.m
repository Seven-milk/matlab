function [y]=scene(x,alpha)
%基于给定样本，拟合分布定情景(alpha为情景)如50%，75%
p_best=Bestfit_dan(x);
%删去重复值
x_=sort(x);
p_=sort(p_best);
j=1;
num=[];
    for i=1:(length(x_)-1)
        if x_(i)==x_(i+1)||p_(i)==p_(i+1)
         num(j)=i;%需要找到重复值去掉（不论是x_还是pc_best_中的重复都需要找到）
         j=j+1;
        end
    end
    if isempty(num)==0
x_(num)=[];
p_(num)=[];
    end
y=spline(sort(p_),sort(x_),alpha);
end