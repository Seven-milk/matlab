%copula拟合,输出论文格式要求的内容
function [p_best,string_best,aic,rho]=Bestfit_copula_shuchu(A,B)
%同bestfit_dan，当需要求给定样本值的概率时输入不定参数,同样输入给定边缘累积概率值
%输入A=边缘分布累积概率(一般选最优的);B=边缘分布累积概率;copulaep为经验copula函数值,p_best为最优理论分布的样本概率，string_best为对应字符串
%rho_best为最优分布的参数
%-----------------------------------------------经验copula计算
%声明计算内置函数(分清内置和总函数，下面解释是解释内置函数的含义)
%copula_ep内置函数输入A,B,u,v；AB为边缘分布序列，uv是对应于样本的边缘分布；(A<=u)是逻辑函数，A(i)小于u时返回1，A(i)大于v时返回0，相乘得到同时小于的1，否则为0（功能类似于条件计数）
%求平均变成（符合条件数(1)/总数(1+0)）,即经验copula的值，输出对应于uv的经验分布值
copula_ep=@(u,v)mean((A<=u).*(B<=v));
%计算经验copula累积概率 copulaep
copulaep=zeros(size(A(:)));
for i=1:numel(copulaep)
    copulaep(i)=copula_ep(A(i),B(i));
end
%-----------------------------------------------理论计算
%copulafit
U=[A(:),B(:)];
rho_clayton=copulafit('clayton',U);
rho_frank=copulafit('frank',U);
rho_gumbel=copulafit('gumbel',U);
rho_gaussian=copulafit('gaussian',U);
[rho_t,nuhat]=copulafit('t',U);
%计算样本copula分布函数值cdf
ccdf_clayton=copulacdf('clayton',U,rho_clayton);
ccdf_frank=copulacdf('frank',U,rho_frank);
ccdf_gumbel=copulacdf('gumbel',U,rho_gumbel);
ccdf_gaussian=copulacdf('gaussian',U,rho_gaussian);
ccdf_t=copulacdf('t',U,rho_t,nuhat); 
%-----------------------------------------------参数输入
n=length(A);%样本数(这里是成对样本)
rho={rho_clayton,rho_frank,rho_gumbel,rho_gaussian(1,2),[rho_t(1,2),nuhat]};
string_={'服从clayton分布','服从frank分布','服从gumbel分布','服从gaussian分布','服从t分布'};
cdf_=[ccdf_clayton,ccdf_frank,ccdf_gumbel,ccdf_gaussian,ccdf_t];
m=[1,1,1,1,2];%参数数目
mse=zeros(5,1);%均方误差
%------------------------------------------------ols计算
% ols=zeros(5,1);
% for i=1:5
%     ols(i)=((sum((cdf_(:,i)-copulaep(:)).^2))/n)^(0.5);
% end
%-------------------------------------------------aic计算
aic=zeros(5,1);
for i=1:5
    mse(i)=sum((cdf_(:,i)-copulaep(:)).^2)./(n-m(i));
    aic(i)=n*log(mse(i))+2*m(i);
end
%-------------------------------------------------判断优选并输出
num=find(aic==min(aic));
p_best=cdf_(:,num);
string_best=string_(num);
%-----------------------------------------------aic计算
%优选AIC准则,样本的pc进行判断，输出pc_
% m=[1,1,1,2,2];
% pc=[ccdf_clayton,ccdf_frank,ccdf_gumbel,ccdf_gaussian,ccdf_t];%理论分布
% p0=copulaep;%经验分布
% mse=zeros(5,1);%均方误差
% aic=zeros(5,1);%四个分布即四个aic
% for i=1:length(aic)
%     mse(i)=sum((pc(:,i)-p0).^2)./(n-m(i));
%     aic(i)=n*log(mse(i))+2*m(i);
% end
% p_best=pc(:,find(aic==min(aic)));%最优理论分布,find得到的是序号，不是值
% string_best=string_(find(aic==min(aic)),:);%最优理论分布对应的字符串
%------------------------------------------------------------------
%qq图绘制
figure
qqplot(p_best,copulaep);
xlabel('理论累积概率');
ylabel('经验累积概率');
title('qq图');
%-------------------------------------------------------------------
% %绘图,做三维,绘图其实没必要用样本数据，因为样本数据只有一条线（三维中，即使扩成网格也没有实际含义）
% %样本得到的是分布（及其参数）只需要把完备的网格画出，做图即可
% % [a,b]=meshgrid(sort(A),sort(B));
% [a,b]=meshgrid(linspace(0,1,50));
% %计算对应三维copula分布函数值
% U_=[a(:),b(:)];
% if num==1
%      pc_=copulacdf('clayton',U_,rho_clayton);%对应绘图的累积概率
%      pd_=copulapdf('clayton',U_,rho_clayton);
% elseif num==2
% pc_=copulacdf('frank',U_,rho_frank);
% pd_=copulapdf('frank',U_,rho_frank);
% elseif num==3
% pc_=copulacdf('gumbel',U_,rho_gumbel);
% pd_=copulapdf('gumbel',U_,rho_gumbel);
% elseif num==4
% pc_=copulacdf('gaussian',U_,rho_gaussian);
% pd_=copulapdf('gaussian',U_,rho_gaussian);
% else
% pc_=copulacdf('t',U_,rho_t,nuhat); 
% pd_=copulapdf('t',U_,rho_t,nuhat); 
% end
% % pc_=reshape(pc_,length(A),length(B));
% pc_=reshape(pc_,50,50);
% pd_=reshape(pd_,50,50);
% figure
% surfc(a,b,pc_);
% xlabel('u');
% ylabel('v');
% zlabel('copula');
% title('cdf')
% figure
% surfc(a,b,pd_);
% xlabel('u');
% ylabel('v');
% zlabel('copula');
% title('pdf')
% figure
% contour(a,b,pc_);
% xlabel('u');
% ylabel('v');
% title('cdf')
% figure
% contour(a,b,pd_);
% xlabel('u');
% ylabel('v');
% title('pdf')
%----------------------------------------------------------
end

