%函数为了论文，输出而对最优分布函数做的修改
function [p_best,string_best,aic,rho,h,p]=Bestfit_dan_shuchu(x)
%输入x样本，如有时需要查给定某样本值的累积概率（增加功能）,输入不定参数
%输出p_best最优分布累积概率对应y,当y取x时，即输出样本值最优分布累积概率,string_best最优分布字符串,uep经验分布,aic为aic检验值
%分布计算-------------------------------------------------------------------------------
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
%检验ks检验----------------------------------------------------------------------
%先整合
pc=[sp,spe,spgev,spev,sp3];%cdf,理论分布删,spgp
rho={c_1,se,sgev,sev,spp3};%参数，用cell进行合并
m=[2,1,3,2,2];%参数数目gamma=2;exp=1;gev=3;gumbel=2;gp=2;p3=2，删除,2
string_={'服从伽马分布','服从指数分布','服从广义极值分布','服从耿贝尔分布','服从P3分布'};%分布说明，用cell数组进行合并，删除,'服从广义帕累托分布'
for i=1:5
    try
    [h(i),p(i)]=kstest(x,[x,pc(:,i)]);%原假设：两分布一致，h=0接受，h=1拒接
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
    [h(i),p(i)]=kstest(x_,[x_,pc_1]);
    end
end
%最优分布---------------------------------------------------------
%-----------计算aic
n=length(x);
mse=zeros(length(m),1);%均方误差
aic=zeros(length(m),1);%aic
for i=1:length(aic)
mse(i)=sum((pc(:,i)-uep).^2)./(n-m(i));
aic(i)=n*log(mse(i))+2*m(i);
end 
%最优
if sum(h)==5%如果都没通过检验,全是1
    p_best=uepk;
    string_best={'服从核分布'};
else%非空，有理论分布通过检验
    p_best=pc(:,find(aic==min(aic)));%最优理论分布,find得到的是序号，不是值
    string_best=string_(find(aic==min(aic)));%最优理论分布对应的字符串
end
%-----------------------------------------------------------------
%plot绘图，看拟合效果，用样本x
figure
hold on
for i=1:5
if i==find(aic==min(aic))
    plot(sort(x),sort(pc(:,i)),'-.');
else
    plot(sort(x),sort(pc(:,i)));
end
end
plot(sort(x),sort(uep),'--');
plot(sort(x),sort(uepk),':');
legend('伽马分布','指数分布','广义极值分布','耿贝尔分布','P3分布','经验分布','核分布');
xlabel('x');
ylabel('cdf');
hold off
end
