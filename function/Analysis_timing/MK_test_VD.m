function [num,UF,UB]=MK_test_VD(date,x)
%MK������ϵĳ���,�������Ϊ�����������õ�flipud
%����UFK-------------------------------------------------------
n=length(x);
function UF=UFK(x)
%����a����----------------------------------------
a=zeros(n,n);
for i=1:n
    for j=1:i
        a(i,j)=x(i)>x(j);%���߼���ʽ2>1������1
    end
end
%����sk����,UFK----------------------------------------
S=zeros(n-1,1);
UF=zeros(n,1);
for k=1:n-1
    S(k)=sum(sum(a(1:(k+1),:)));%S��n-1�����ӵڶ�����͵���n��
    E=(k+2)*(k+1)/4;%��ֵ��ע������k��Ӧ��2��n����Ϊ��ŷ��㣬����k=1:n-1�����Լ�1
    V=k*(k+1)*(2*(k+1)+5)/72;%����
    UF(k+1)=(S(k)-E)/(V^0.5);%��2��ʼ��Ĭ��UF1=0��UF(K+1)��S(k)��Ӧ��k=1��UF2,S(1)-S2   ɾ%abs
end
end
%--------------------------------------------------
%����UFK,UBK
UF=UFK(x);
UB=-flipud(UFK(flipud(x')'));%x��ת���õ������UF-����ʱ���ᣩ+UB��ת������ʱ����һ�£�
%��0.5Ϊ����ˮƽ���ٽ�ֵΪ+-1.96
h1=zeros(n,1);
h2=zeros(n,1);
h3=zeros(n,1);
h1(:)=1.96;
h2(:)=-1.96;
h3(:)=0;
%��ͼ
figure
hold on 
date1=datenum(date);
% date1=date;
plot(date1,UF,'r');%UF����
plot(date1,UB,'b');%UB����
plot(date1,h1,'-.');%���ٽ�
plot(date1,h2,'-.');%���ٽ�
plot(date1,h3,'-.');%���ٽ�
legend('UF','UB','1.96','-1.96','0');
xlabel('���');
ylabel('����ֵ');
title('MK�������');
datetick('x','yyyy');
hold off
%Ѱ�ұ����
U1=UF-UB;
log_=zeros(length(U1),1);
for i1=1:length(U1)-1
    log_(i1)=U1(i1)*U1(i1+1);
end
num1=[];
num1=find(log_<0);%�����ڣ�����i��i+1֮����ڱ����,���Ϊ�����ݣ����ڶ�������ʱ��
if isempty(num1)==0%���ǿգ����ڱ����
    num=date(num1);%���Ϊdate���飬��cell��ȽϺ�
else
    num=datetime(0,0,0);
end
end