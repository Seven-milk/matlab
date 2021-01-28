function [z,p_value,slope,H]=MK_test(date,x)
%% MK���飬����ʱ��date,��ֵ����x,��������Լ�Zֵ����ͼ
%H0=0��Ϊ�����������p<alpha,�ܾ�H0,H=1,z>pz,zԽ��Խ����,H=1
%% ----------------------------------------
%����r���У�r���й�n-1����,��ʾ��i��λ�ã�>=2��ͬǰ��i-1��ֵ�Ƚϵľ�����һ��(n-1)����ʾ��2-n��*(n-1)����ʾ�ӵ�һ���ȵ���n-1�����ľ���
n=length(x);
r=zeros(n-1,n-1);
for i=2:length(x)
    for j=1:i-1
    r(i-1,j)=sign(x(i)-x(j));
    end
end
%����s�����r����
s=sum(sum(r));
VAR=n*(n-1)*(n*2+5)/18;
if length(x)<10
    error('�������й���')
end
%z����
if s>0
    z=(s-1)./(VAR^0.5);
elseif s<0
    z=(s+1)./(VAR^0.5);
else
    z=0;
end
%�жϾܾ���,H0,���������ƣ�Z��ӳ���в���̶ȣ�ZԽ��Խ���������ӱ�׼��̬�ֲ�
alpha=0.05;%˫�߼���
Z0=norminv(1-alpha/2,0,1);%��������ˮƽ������
% H=0;
zabs=abs(z);%�����и�������ֵӰ��������
if zabs>Z0
    H=1;%�ܾ�ԭ���裬��Ϊ��������
    disp('��������');
else
    H=0;%����ԭ���裬��Ϊ���Ʋ�����
    disp('���Ʋ�����');
end
p_value=2*(1-normcdf(zabs,0,1));%pֵ���㣬С��alpha1��ܾ�H0,˫�߼����ǵ��߼���Pֵ������
%% ��ͼ
figure
hold on 
date1=datenum(date);
plot(date1,x);%ԭ����
x1=polyfit(date1,x,1);
bi=polyval(x1,date1);%������
plot(date1,bi);
xlabel('���');
ylabel('����ֵ');
title('MK���Ƽ���');
set(gca,'XLim',[date1(1),date1(end)]);
datetick('x','yyyy','keeplimits');
hold off
%% ������б��slope
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
%�����Ѿ����飬һ��
    
    
    
    

