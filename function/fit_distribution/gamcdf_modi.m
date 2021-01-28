%修正gamcdf，修正0值影响
function [Hx,c_1]=gamcdf_modi(x,varargin)
%若想求固定样本值的概率，输入varargin按样本x拟合，输出y的累积概率，y取x时输出样本的累积概率
n=length(x);
m=0;
for i=1:n%计算0值并处理
    if x(i)==0
        m=m+1;
    end
end
    q=m/n;%0值概率
    num=find(x==0);%统计0值位置
    x(num)=[];%0值去掉
    c_1=gamfit(x);
    Gx=gamcdf(x,c_1(1),c_1(2));
    Hx=q+(1-q)*Gx;%修正后概率,不含0值
    if q~=0   %只要非0项存在，即要还原0值概率
    for i=1:length(num)
    Hx=[Hx(1:num(i)-1);q;Hx(num(i):length(Hx))];%将0值概率补充回来
    end
    end
    if nargin==2
        Hx=q+(1-q)*gamcdf(varargin{1},c_1(1),c_1(2));
    end
end