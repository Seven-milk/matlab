%���ڻ��������ڼ���ʱ���������DS�ֲ�����P3�ֲ���ȥ��P3(p3����ʱ�䳤)��ȥ��һЩ������ܼ򻯳���
function [p_best]=Bestfit_dan_nop3(x,varargin)
%����x����������ʱ��Ҫ�����ĳ����ֵ���ۻ����ʣ����ӹ��ܣ�,���벻������
%���p_best���ŷֲ��ۻ����ʶ�Ӧy,��yȡxʱ�����������ֵ���ŷֲ��ۻ�����,string_best���ŷֲ��ַ���,uep����ֲ�,aicΪaic����ֵ
%�ֲ�����-------------------------------------------------------------------------------
%c_1������sp�ۻ����� gammma ʹ������gamcdf_modi������������������ﲻ��Ҫ����
sp=gamcdf_modi(x);
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
% [sp3,spp3]=Peason_Type_III(x);
%�����ۻ�Ƶ��uep,ecdf��������sort���ģ���Ҫ�������
[eps,xps]=ecdf(x);
uep=spline(xps(2:end),eps(2:end),x);
%�ǲ��������˹��ƣ��ۻ�����uepk��ksdensity��������ͨ������ʱ��ѡ��ǲ�����
uepk=ksdensity(x,x,'function','cdf');
%����ks����----------------------------------------------------------------------
%������
pc=[sp,spe,spgev,spev];%cdf,���۷ֲ�ɾ,spgp
% rho={c_1,se,sgev,sev};%��������cell���кϲ�
m=[2,1,3,2];%������Ŀgamma=2;exp=1;gev=3;gumbel=2;gp=2;p3=2��ɾ��,2
% string_={'����٤��ֲ�','����ָ���ֲ�','���ӹ��弫ֵ�ֲ�','���ӹ������ֲ�'};%�ֲ�˵������cell������кϲ���ɾ��,'���ӹ��������зֲ�'
j1=1;
num2=[];
for i=1:4
    try
    h=kstest(x,[x,pc(:,i)]);%ԭ���裺���ֲ�һ�£�h=0���ܣ�h=1�ܽ�
    catch
    %���в���˵�����ظ�ֵ,kstest��Ҫ����cdf��x���������ظ�ֵʱ�ǵ��������ã����ظ�ֵȥ��
    x_=sort(x);
    pc_1=sort(pc(:,i));
    j=1;
    for i1=1:(length(x_)-1)
        if x_(i1)==x_(i1+1)||pc_1(i1)==pc_1(i1+1)
         num(j)=i1;%��Ҫ�ҵ��ظ�ֵȥ����������x_����pc_best_�е��ظ�����Ҫ�ҵ���
         j=j+1;
        end
    end
    x_(num)=[];
    pc_1(num)=[];
    h=kstest(x_,[x_,pc_1]);
    end
    if h==1%�ܾ�����ͨ�����裬�÷ֲ�ȥ��
    num2(j1)=i;
    j1=j1+1;
    end
end
if isempty(num2)==0%����ûͨ����,��ɾ��
pc(:,num2)=[];
% rho(num2)=[];
m(num2)=[];
% string_(num2)=[];
end
%���ŷֲ�---------------------------------------------------------
if isempty(pc)==1%�����ûͨ������
    p_best=uepk;
%     rho_best=0;
%     aic_=0;
%     string_best={'���Ӻ˷ֲ�'};
else%�ǿգ������۷ֲ�ͨ������
%-----------����aic
    n=length(x);
    mse=zeros(length(m),1);%�������
    aic=zeros(length(m),1);%aic
    for i=1:length(aic)
    mse(i)=sum((pc(:,i)-uep).^2)./(n-m(i));
    aic(i)=n*log(mse(i))+2*m(i);
    end
    p_best=pc(:,find(aic==min(aic)));%�������۷ֲ�,find�õ�������ţ�����ֵ
%     rho_best=rho(find(aic==min(aic)));
%     string_best=string_(find(aic==min(aic)));%�������۷ֲ���Ӧ���ַ���
%     aic_best=aic(find(aic==min(aic)));
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
%������̶�����ֵ�ۻ����ʵĹ���-------------------------------------
%,����������Ϊ2���ı����pc_bestΪ��������ֵ��
if nargin==2
    %�ֲ�ֵ����
    spy=gamcdf_modi(x,varargin{1});
    spey=expcdf(varargin{1},se);
    spgevy=gevcdf(varargin{1},sgev(1),sgev(2),sgev(3));
    spevy=evcdf(varargin{1},sev(1),sev(2));
%   spgpy=gpcdf(varargin{1},sgp(1),sgp(2));
%     spp3y=Peason_Type_III(x,varargin{1});
    py=[spy,spey,spgevy,spevy];
    uepky=ksdensity(x,varargin{1},'function','cdf');
    %�������--------------------------
    if isempty(pc)==1%�����ûͨ������
        p_best=uepky;
    else
        p_best=py(:,find(aic==min(aic)));
    end
end
end
%�����Ѹģ��ȼ�������ѡ