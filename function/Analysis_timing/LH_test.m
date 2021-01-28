function [num]=LH_test(date,x)
%% ����˵��
% x       �������������У��д洢
% date    ���ھ���,��xͬά
% num      ������f��Ӧ�ı����
%% ��������
% ����Ԥ��
n=length(x);
mu_tao=zeros(n-1,1);%�Ӷ�Ӧ�ľ�ֵ����=1��N-1
mu_ntao=zeros(n-1,1);%n-�Ӷ�Ӧ�ľ�ֵ
%�����ֵ����
mu=mean(x);%ȫ���о�ֵ
for i=1:n-1%i=tao
    mu_tao(i)=mean(x(1:i));
    mu_ntao(i)=mean(x(n-i+1:n));
end
%����r(��)����
S=zeros(n-1,1);
D=zeros(n-1,1);
Z=zeros(n-1,1);
for i=1:n-1%��
    for j=1:i%��һ��i
         S(i)=S(i)+(x(j)-mu_tao(i))^2;
    end
    for j1=i+1:n%�ڶ���i
        D(i)=D(i)+(x(j1)-mu_ntao(n-i))^2;
    end
    for j2=1:n%������i
        Z(i)=Z(i)+(x(j2)-mu)^2;
    end
end
R=(S+D)./Z;%R
%����f(��)����
f=zeros(n-1,1);
for i=1:n-1%i=tao
    f(i)=sqrt(n/(i*(n-i)))*(R(i))^((2-n)/2);
end
num=date(find(f==max(f)));
%% ��ͼ
figure
hold on 
date1=datenum(date);
num1=date1(find(f==max(f)));
plot(date1(1:n-1),f);
plot([num1 num1],get(gca,'YLim'),'r');
axis([date1(1),date1(n-1),min(f),max(f)]);
datetick('x','yyyy','keeplimits');%�������ڣ��꣬�£���ʾ
title('LH�������');
xlabel('���');
ylabel('�����ܶ�ֵ');
end
        
