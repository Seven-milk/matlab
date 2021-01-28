%����ѡ�ټ���
%�����������ŷֲ�,��gamma_modi,gev,exp,gumbel,p3������õģ���ѡ��AIC�������м��飬δͨ������ʱ�÷ǲ����˷ֲ�
function [p_best,string_best,aic,rho_best,uep]=Bestfit_dan(x,varargin)
%����x����������ʱ��Ҫ�����ĳ����ֵ���ۻ����ʣ����ӹ��ܣ�,���벻������
%���p_best���ŷֲ��ۻ����ʶ�Ӧy,��yȡxʱ�����������ֵ���ŷֲ��ۻ�����,string_best���ŷֲ��ַ���,uep����ֲ�,aicΪaic����ֵ
%c_1������sp�ۻ����� gammma ʹ������gamcdf_modi������������������ﲻ��Ҫ����
[sp,c_1]=gamcdf_modi(x);
%se����,spe�ۻ����� exp
se=expfit(x);
spe=expcdf(x,se);
%sgev����,spgev�ۻ����� GEV
sgev=gevfit(x);
spgev=gevcdf(x,sgev(1),sgev(2),sgev(3));
%sev����,spev�ۻ����� gumbel
sev=evfit(x);
spev=evcdf(x,sev(1),sev(2));
%sgp����,spgp�ۻ����� gp
% sgp=gpfit(sort(x));
% spgp=gpcdf(x,sgp(1),sgp(2));
%spp3����,sp3�ۻ����� p3
[sp3,spp3]=Peason_Type_III(x);
%�����ۻ�Ƶ��uep,ecdf��������sort���ģ���Ҫ�������
[eps,xps]=ecdf(x);
uep=spline(xps(2:end),eps(2:end),x);
%�ǲ��������˹��ƣ��ۻ�����uepk��ksdensity��������ͨ������ʱ��ѡ��ǲ�����
uepk=ksdensity(x,x,'function','cdf');
%-----------------------------------------------------------------
%��ѡAIC׼��
%aic���㼰�ж�,������x�������pc_best���бȽ��жϣ����y��p_c_best������Ϊp_best
n=length(x);
pc=[sp,spe,spgev,spev,sp3];%���۷ֲ�ɾ,spgp
string_=char('����٤��ֲ�','����ָ���ֲ�','���ӹ��弫ֵ�ֲ�','���ӹ������ֲ�','����P3�ֲ�');%ɾ��,'���ӹ��������зֲ�'
m=[2,1,3,2,2];%������Ŀgamma=2;exp=1;gev=3;gumbel=2;gp=2;p3=2��ɾ��,2
p0=uep;%�����ۻ�����
mse=zeros(5,1);%�������
aic=zeros(5,1);%�ĸ��ֲ����ĸ�aic
for i=1:length(aic)
    mse(i)=sum((pc(:,i)-p0).^2)./(n-m(i));
    aic(i)=n*log(mse(i))+2*m(i);
end
pc_best=pc(:,find(aic==min(aic)));%�������۷ֲ�,find�õ�������ţ�����ֵ
string_c_best=string_(find(aic==min(aic)),:);%�������۷ֲ���Ӧ���ַ���
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
%����ks����
try
h=kstest(x,[x,pc_best]);%ԭ���裺���ֲ�һ�£�h=0���ܣ�h=1�ܽ�
catch
    %���в���˵�����ظ�ֵ,kstest��Ҫ����cdf��x���������ظ�ֵʱ�ǵ��������ã����ظ�ֵȥ��
    x_=sort(x);
    pc_best_=sort(pc_best);
    j=1;
    for i=1:(length(x_)-1)
        if x_(i)==x_(i+1)||pc_best_(i)==pc_best_(i+1)
         num(j)=i;%��Ҫ�ҵ��ظ�ֵȥ����������x_����pc_best_�е��ظ�����Ҫ�ҵ���
         j=j+1;
        end
    end
    x_(num)=[];
    pc_best_(num)=[];
    h=kstest(x_,[x_,pc_best_]);
end
%���ŷֲ������������۷ּ��飬ͨ��������δͨ���Ǻ˷ֲ�
if h==0
    p_best=pc_best;%ͨ�����飬ȡ���۷ֲ�
    string_best=string_c_best;%��Ӧ�ַ���
    rho_best=rho_c;
else
    p_best=uepk;%δͨ�����飬ȡ�˷ֲ�
    string_best=char('���Ӻ˷ֲ�');%��Ӧ�ַ���
    rho_best=0;
end
%-----------------------------------------------------------------
%plot��ͼ�������Ч����������x
% figure
% hold on
% plot(sort(x),sort(p_best));
% plot(sort(x),sort(uep));
% legend('���ŷֲ�','����ֲ�');
% xlabel('x');
% ylabel('cdf');
% hold off
%������̶�����ֵ�ۻ����ʵĹ���,����������Ϊ2���ı����pc_bestΪ��������ֵ��
if nargin==2
    spy=gamcdf_modi(x,varargin{1});
    spey=expcdf(varargin{1},se);
    spgevy=gevcdf(varargin{1},sgev(1),sgev(2),sgev(3));
    spevy=evcdf(varargin{1},sev(1),sev(2));
%     spgpy=gpcdf(varargin{1},sgp(1),sgp(2));
    spp3y=Peason_Type_III(x,varargin{1});
    uepky=ksdensity(x,varargin{1},'function','cdf');
    %�������۷ֲ�
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