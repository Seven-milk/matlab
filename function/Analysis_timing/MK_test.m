function [z,p_value,slope,H]=MK_test(date,x)
%% MK检验，输入时间date,数值序列x,输出显著性及Z值，绘图
%H0=0认为不显著，输出p<alpha,拒绝H0,H=1,z>pz,z越大越显著,H=1
%% ----------------------------------------
%计算r序列，r序列共n-1长度,表示第i个位置（>=2）同前面i-1个值比较的矩阵，是一个(n-1)（表示从2-n）*(n-1)（表示从第一个比到第n-1个）的矩阵
n=length(x);
r=zeros(n-1,n-1);
for i=2:length(x)
    for j=1:i-1
    r(i-1,j)=sign(x(i)-x(j));
    end
end
%计算s，求和r矩阵
s=sum(sum(r));
VAR=n*(n-1)*(n*2+5)/18;
if length(x)<10
    error('输入序列过短')
end
%z计算
if s>0
    z=(s-1)./(VAR^0.5);
elseif s<0
    z=(s+1)./(VAR^0.5);
else
    z=0;
end
%判断拒绝域,H0,无显著趋势，Z反映序列差异程度，Z越大越显著，服从标准正态分布
alpha=0.05;%双边检验
Z0=norminv(1-alpha/2,0,1);%修正置信水平，这里
% H=0;
zabs=abs(z);%有正有负，绝对值影响显著性
if zabs>Z0
    H=1;%拒绝原假设，认为趋势显著
    disp('趋势显著');
else
    H=0;%接受原假设，认为趋势不显著
    disp('趋势不显著');
end
p_value=2*(1-normcdf(zabs,0,1));%p值计算，小于alpha1则拒绝H0,双边检验是单边检验P值的两倍
%% 绘图
figure
hold on 
date1=datenum(date);
plot(date1,x);%原序列
x1=polyfit(date1,x,1);
bi=polyval(x1,date1);%趋势线
plot(date1,bi);
xlabel('年份');
ylabel('序列值');
title('MK趋势检验');
set(gca,'XLim',[date1(1),date1(end)]);
datetick('x','yyyy','keeplimits');
hold off
%% 计算倾斜度slope
beta=[];
m=1;
for j=2:n
    for i=1:j-1
        beta(m)=(x(j)-x(i))/(j-i);
        m=m+1;
    end
end
slope=median(beta);
end
%程序已经检验，一致
    
    
    
    

