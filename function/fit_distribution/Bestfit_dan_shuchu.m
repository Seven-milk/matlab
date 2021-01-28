%����Ϊ�����ģ�����������ŷֲ����������޸�
function [p_best,string_best,aic,rho,h,p]=Bestfit_dan_shuchu(x)
%����x����������ʱ��Ҫ�����ĳ����ֵ���ۻ����ʣ����ӹ��ܣ�,���벻������
%���p_best���ŷֲ��ۻ����ʶ�Ӧy,��yȡxʱ�����������ֵ���ŷֲ��ۻ�����,string_best���ŷֲ��ַ���,uep����ֲ�,aicΪaic����ֵ
%�ֲ�����-------------------------------------------------------------------------------
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
%����ks����----------------------------------------------------------------------
%������
pc=[sp,spe,spgev,spev,sp3];%cdf,���۷ֲ�ɾ,spgp
rho={c_1,se,sgev,sev,spp3};%��������cell���кϲ�
m=[2,1,3,2,2];%������Ŀgamma=2;exp=1;gev=3;gumbel=2;gp=2;p3=2��ɾ��,2
string_={'����٤��ֲ�','����ָ���ֲ�','���ӹ��弫ֵ�ֲ�','���ӹ������ֲ�','����P3�ֲ�'};%�ֲ�˵������cell������кϲ���ɾ��,'���ӹ��������зֲ�'
for i=1:5
    try
    [h(i),p(i)]=kstest(x,[x,pc(:,i)]);%ԭ���裺���ֲ�һ�£�h=0���ܣ�h=1�ܽ�
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
    [h(i),p(i)]=kstest(x_,[x_,pc_1]);
    end
end
%���ŷֲ�---------------------------------------------------------
%-----------����aic
n=length(x);
mse=zeros(length(m),1);%�������
aic=zeros(length(m),1);%aic
for i=1:length(aic)
mse(i)=sum((pc(:,i)-uep).^2)./(n-m(i));
aic(i)=n*log(mse(i))+2*m(i);
end 
%����
if sum(h)==5%�����ûͨ������,ȫ��1
    p_best=uepk;
    string_best={'���Ӻ˷ֲ�'};
else%�ǿգ������۷ֲ�ͨ������
    p_best=pc(:,find(aic==min(aic)));%�������۷ֲ�,find�õ�������ţ�����ֵ
    string_best=string_(find(aic==min(aic)));%�������۷ֲ���Ӧ���ַ���
end
%-----------------------------------------------------------------
%plot��ͼ�������Ч����������x
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
legend('٤��ֲ�','ָ���ֲ�','���弫ֵ�ֲ�','�������ֲ�','P3�ֲ�','����ֲ�','�˷ֲ�');
xlabel('x');
ylabel('cdf');
hold off
end
