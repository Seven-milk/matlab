%copula���,������ĸ�ʽҪ�������
function [p_best,string_best,aic,rho]=Bestfit_copula_shuchu(A,B)
%ͬbestfit_dan������Ҫ���������ֵ�ĸ���ʱ���벻������,ͬ�����������Ե�ۻ�����ֵ
%����A=��Ե�ֲ��ۻ�����(һ��ѡ���ŵ�);B=��Ե�ֲ��ۻ�����;copulaepΪ����copula����ֵ,p_bestΪ�������۷ֲ����������ʣ�string_bestΪ��Ӧ�ַ���
%rho_bestΪ���ŷֲ��Ĳ���
%-----------------------------------------------����copula����
%�����������ú���(�������ú��ܺ�������������ǽ������ú����ĺ���)
%copula_ep���ú�������A,B,u,v��ABΪ��Ե�ֲ����У�uv�Ƕ�Ӧ�������ı�Ե�ֲ���(A<=u)���߼�������A(i)С��uʱ����1��A(i)����vʱ����0����˵õ�ͬʱС�ڵ�1������Ϊ0����������������������
%��ƽ����ɣ�����������(1)/����(1+0)��,������copula��ֵ�������Ӧ��uv�ľ���ֲ�ֵ
copula_ep=@(u,v)mean((A<=u).*(B<=v));
%���㾭��copula�ۻ����� copulaep
copulaep=zeros(size(A(:)));
for i=1:numel(copulaep)
    copulaep(i)=copula_ep(A(i),B(i));
end
%-----------------------------------------------���ۼ���
%copulafit
U=[A(:),B(:)];
rho_clayton=copulafit('clayton',U);
rho_frank=copulafit('frank',U);
rho_gumbel=copulafit('gumbel',U);
rho_gaussian=copulafit('gaussian',U);
[rho_t,nuhat]=copulafit('t',U);
%��������copula�ֲ�����ֵcdf
ccdf_clayton=copulacdf('clayton',U,rho_clayton);
ccdf_frank=copulacdf('frank',U,rho_frank);
ccdf_gumbel=copulacdf('gumbel',U,rho_gumbel);
ccdf_gaussian=copulacdf('gaussian',U,rho_gaussian);
ccdf_t=copulacdf('t',U,rho_t,nuhat); 
%-----------------------------------------------��������
n=length(A);%������(�����ǳɶ�����)
rho={rho_clayton,rho_frank,rho_gumbel,rho_gaussian(1,2),[rho_t(1,2),nuhat]};
string_={'����clayton�ֲ�','����frank�ֲ�','����gumbel�ֲ�','����gaussian�ֲ�','����t�ֲ�'};
cdf_=[ccdf_clayton,ccdf_frank,ccdf_gumbel,ccdf_gaussian,ccdf_t];
m=[1,1,1,1,2];%������Ŀ
mse=zeros(5,1);%�������
%------------------------------------------------ols����
% ols=zeros(5,1);
% for i=1:5
%     ols(i)=((sum((cdf_(:,i)-copulaep(:)).^2))/n)^(0.5);
% end
%-------------------------------------------------aic����
aic=zeros(5,1);
for i=1:5
    mse(i)=sum((cdf_(:,i)-copulaep(:)).^2)./(n-m(i));
    aic(i)=n*log(mse(i))+2*m(i);
end
%-------------------------------------------------�ж���ѡ�����
num=find(aic==min(aic));
p_best=cdf_(:,num);
string_best=string_(num);
%-----------------------------------------------aic����
%��ѡAIC׼��,������pc�����жϣ����pc_
% m=[1,1,1,2,2];
% pc=[ccdf_clayton,ccdf_frank,ccdf_gumbel,ccdf_gaussian,ccdf_t];%���۷ֲ�
% p0=copulaep;%����ֲ�
% mse=zeros(5,1);%�������
% aic=zeros(5,1);%�ĸ��ֲ����ĸ�aic
% for i=1:length(aic)
%     mse(i)=sum((pc(:,i)-p0).^2)./(n-m(i));
%     aic(i)=n*log(mse(i))+2*m(i);
% end
% p_best=pc(:,find(aic==min(aic)));%�������۷ֲ�,find�õ�������ţ�����ֵ
% string_best=string_(find(aic==min(aic)),:);%�������۷ֲ���Ӧ���ַ���
%------------------------------------------------------------------
%qqͼ����
figure
qqplot(p_best,copulaep);
xlabel('�����ۻ�����');
ylabel('�����ۻ�����');
title('qqͼ');
%-------------------------------------------------------------------
% %��ͼ,����ά,��ͼ��ʵû��Ҫ���������ݣ���Ϊ��������ֻ��һ���ߣ���ά�У���ʹ��������Ҳû��ʵ�ʺ��壩
% %�����õ����Ƿֲ������������ֻ��Ҫ���걸�����񻭳�����ͼ����
% % [a,b]=meshgrid(sort(A),sort(B));
% [a,b]=meshgrid(linspace(0,1,50));
% %�����Ӧ��άcopula�ֲ�����ֵ
% U_=[a(:),b(:)];
% if num==1
%      pc_=copulacdf('clayton',U_,rho_clayton);%��Ӧ��ͼ���ۻ�����
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

