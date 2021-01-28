%先优选再检验
%函数，求最优分布,从gamma_modi,gev,exp,gumbel,p3中找最好的（优选用AIC），进行检验，未通过检验时用非参数核分布
function [p_best,string_best,aic,rho_best,uep]=Bestfit_dan(x,varargin)
%输入x样本，如有时需要查给定某样本值的累积概率（增加功能）,输入不定参数
%输出p_best最优分布累积概率对应y,当y取x时，即输出样本值最优分布累积概率,string_best最优分布字符串,uep经验分布,aic为aic检验值
%c_1参数，sp累积概率 gammma 使用修正gamcdf_modi（内置了求参数，这里不需要再求）
[sp,c_1]=gamcdf_modi(x);
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
[sp3,spp3]=Peason_Type_III(x);
%经验累积频率uep,ecdf出来的是sort过的，需要查回样本
[eps,xps]=ecdf(x);
uep=spline(xps(2:end),eps(2:end),x);
%非参数法（核估计）累积概率uepk（ksdensity），都不通过检验时，选择非参数法
uepk=ksdensity(x,x,'function','cdf');
%-----------------------------------------------------------------
%优选AIC准则
%aic计算及判断,用样本x及其概率pc_best进行比较判断，输出y的p_c_best概率作为p_best
n=length(x);
pc=[sp,spe,spgev,spev,sp3];%理论分布删,spgp
string_=char('服从伽马分布','服从指数分布','服从广义极值分布','服从耿贝尔分布','服从P3分布');%删除,'服从广义帕累托分布'
m=[2,1,3,2,2];%参数数目gamma=2;exp=1;gev=3;gumbel=2;gp=2;p3=2，删除,2
p0=uep;%经验累积概率
mse=zeros(5,1);%均方误差
aic=zeros(5,1);%四个分布即四个aic
for i=1:length(aic)
    mse(i)=sum((pc(:,i)-p0).^2)./(n-m(i));
    aic(i)=n*log(mse(i))+2*m(i);
end
pc_best=pc(:,find(aic==min(aic)));%最优理论分布,find得到的是序号，不是值
string_c_best=string_(find(aic==min(aic)),:);%最优理论分布对应的字符串
if find(aic==min(aic))==1
    rho_c=c_1;
elseif find(aic==min(aic))==2
    rho_c=se;
elseif find(aic==min(aic))==3
    rho_c=sgev;
elseif find(aic==min(aic))==4
    rho_c=sev;
else
    rho_c=spp3;  
end
%检验ks检验
try
h=kstest(x,[x,pc_best]);%原假设：两分布一致，h=0接受，h=1拒接
catch
    %运行不了说明有重复值,kstest需要满足cdf随x单增，有重复值时非单增不可用，把重复值去掉
    x_=sort(x);
    pc_best_=sort(pc_best);
    j=1;
    for i=1:(length(x_)-1)
        if x_(i)==x_(i+1)||pc_best_(i)==pc_best_(i+1)
         num(j)=i;%需要找到重复值去掉（不论是x_还是pc_best_中的重复都需要找到）
         j=j+1;
        end
    end
    x_(num)=[];
    pc_best_(num)=[];
    h=kstest(x_,[x_,pc_best_]);
end
%最优分布，从最优理论分检验，通过是它，未通过是核分布
if h==0
    p_best=pc_best;%通过检验，取理论分布
    string_best=string_c_best;%对应字符串
    rho_best=rho_c;
else
    p_best=uepk;%未通过检验，取核分布
    string_best=char('服从核分布');%对应字符串
    rho_best=0;
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
%设置求固定样本值累积概率的功能,如果输入变量为2，改变输出pc_best为给定样本值的
if nargin==2
    spy=gamcdf_modi(x,varargin{1});
    spey=expcdf(varargin{1},se);
    spgevy=gevcdf(varargin{1},sgev(1),sgev(2),sgev(3));
    spevy=evcdf(varargin{1},sev(1),sev(2));
%     spgpy=gpcdf(varargin{1},sgp(1),sgp(2));
    spp3y=Peason_Type_III(x,varargin{1});
    uepky=ksdensity(x,varargin{1},'function','cdf');
    %最优理论分布
    if find(aic==min(aic))==1
        pc_best_y=spy;
        elseif find(aic==min(aic))==2
            pc_best_y=spey;
            elseif find(aic==min(aic))==3
                pc_best_y=spgevy;
                elseif find(aic==min(aic))==4
                    pc_best_y=spevy;
    else
                        pc_best_y=spp3y;             
    end
    if h==0
        p_best=pc_best_y;
    else
             p_best=uepky;
    end
        
end
end