%由于滑动重现期计算时间过长，而DS又不服从P3分布，去掉P3(p3运算时间长)并去掉一些输出功能简化程序
function [p_best]=Bestfit_dan_nop3(x,varargin)
%输入x样本，如有时需要查给定某样本值的累积概率（增加功能）,输入不定参数
%输出p_best最优分布累积概率对应y,当y取x时，即输出样本值最优分布累积概率,string_best最优分布字符串,uep经验分布,aic为aic检验值
%分布计算-------------------------------------------------------------------------------
%c_1参数，sp累积概率 gammma 使用修正gamcdf_modi（内置了求参数，这里不需要再求）
sp=gamcdf_modi(x);
%se参数,spe累积概率 exp
se=expfit(x);
spe=expcdf(x,se);
%sgev参数,spgev累积概率 GEV
sgev=gevfit(x);
spgev=gevcdf(x,sgev(1),sgev(2),sgev(3));
%sev参数,spev累积概率 gumbel
sev=evfit(x);
spev=evcdf(x,sev(1),sev(2));
%sgp参数,spgp累积概率 gp
% sgp=gpfit(sort(x));
% spgp=gpcdf(x,sgp(1),sgp(2));
%spp3参数,sp3累积概率 p3
% [sp3,spp3]=Peason_Type_III(x);
%经验累积频率uep,ecdf出来的是sort过的，需要查回样本
[eps,xps]=ecdf(x);
uep=spline(xps(2:end),eps(2:end),x);
%非参数法（核估计）累积概率uepk（ksdensity），都不通过检验时，选择非参数法
uepk=ksdensity(x,x,'function','cdf');
%检验ks检验----------------------------------------------------------------------
%先整合
pc=[sp,spe,spgev,spev];%cdf,理论分布删,spgp
% rho={c_1,se,sgev,sev};%参数，用cell进行合并
m=[2,1,3,2];%参数数目gamma=2;exp=1;gev=3;gumbel=2;gp=2;p3=2，删除,2
% string_={'服从伽马分布','服从指数分布','服从广义极值分布','服从耿贝尔分布'};%分布说明，用cell数组进行合并，删除,'服从广义帕累托分布'
j1=1;
num2=[];
for i=1:4
    try
    h=kstest(x,[x,pc(:,i)]);%原假设：两分布一致，h=0接受，h=1拒接
    catch
    %运行不了说明有重复值,kstest需要满足cdf随x单增，有重复值时非单增不可用，把重复值去掉
    x_=sort(x);
    pc_1=sort(pc(:,i));
    j=1;
    for i1=1:(length(x_)-1)
        if x_(i1)==x_(i1+1)||pc_1(i1)==pc_1(i1+1)
         num(j)=i1;%需要找到重复值去掉（不论是x_还是pc_best_中的重复都需要找到）
         j=j+1;
        end
    end
    x_(num)=[];
    pc_1(num)=[];
    h=kstest(x_,[x_,pc_1]);
    end
    if h==1%拒绝即不通过假设，该分布去掉
    num2(j1)=i;
    j1=j1+1;
    end
end
if isempty(num2)==0%存在没通过的,给删了
pc(:,num2)=[];
% rho(num2)=[];
m(num2)=[];
% string_(num2)=[];
end
%最优分布---------------------------------------------------------
if isempty(pc)==1%如果都没通过检验
    p_best=uepk;
%     rho_best=0;
%     aic_=0;
%     string_best={'服从核分布'};
else%非空，有理论分布通过检验
%-----------计算aic
    n=length(x);
    mse=zeros(length(m),1);%均方误差
    aic=zeros(length(m),1);%aic
    for i=1:length(aic)
    mse(i)=sum((pc(:,i)-uep).^2)./(n-m(i));
    aic(i)=n*log(mse(i))+2*m(i);
    end
    p_best=pc(:,find(aic==min(aic)));%最优理论分布,find得到的是序号，不是值
%     rho_best=rho(find(aic==min(aic)));
%     string_best=string_(find(aic==min(aic)));%最优理论分布对应的字符串
%     aic_best=aic(find(aic==min(aic)));
end
%-----------------------------------------------------------------
%plot绘图，看拟合效果，用样本x
% figure
% hold on
% plot(sort(x),sort(p_best));
% plot(sort(x),sort(uep));
% legend('最优分布','经验分布');
% xlabel('x');
% ylabel('cdf');
% hold off
%设置求固定样本值累积概率的功能-------------------------------------
%,如果输入变量为2，改变输出pc_best为给定样本值的
if nargin==2
    %分布值计算
    spy=gamcdf_modi(x,varargin{1});
    spey=expcdf(varargin{1},se);
    spgevy=gevcdf(varargin{1},sgev(1),sgev(2),sgev(3));
    spevy=evcdf(varargin{1},sev(1),sev(2));
%   spgpy=gpcdf(varargin{1},sgp(1),sgp(2));
%     spp3y=Peason_Type_III(x,varargin{1});
    py=[spy,spey,spgevy,spevy];
    uepky=ksdensity(x,varargin{1},'function','cdf');
    %修正输出--------------------------
    if isempty(pc)==1%如果都没通过检验
        p_best=uepky;
    else
        p_best=py(:,find(aic==min(aic)));
    end
end
end
%程序已改，先检验再优选