%��ά����Ϣ���㣬����copula��
function [I,p]=I_copula(x,y)
%% ����˵��
%xy    ���������ԭʼ���ݣ�������
%% ����Ԥ�輰����Զ���
n=length(x);%n �������г���
p=corr(x,y);%p ��������������ϵ��
%% copula���
A=Bestfit_dan(x);%x���������
B=Bestfit_dan(y);%y���������
C=Bestfit_copulapdf(A,B);%copula��ϳ������ܶ�
close all
%% ���㻥��Ϣ����ͣ����֣�
I=-sum(log(C))/n;
end
%r=sqrt(1-exp(2*I));