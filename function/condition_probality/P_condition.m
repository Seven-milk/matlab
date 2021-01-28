%�������ʺ���P(A|B)
function [P_con]=P_condition(x,y,x0,y0,varargin)
%% ����˵��
% x ����1����
% y ����2����
% x0 ����1��ֵ����X<=x�е�x
% y0 ����2��ֵ
% varargin �����¼��������Ӧ4�����-1,2,3,4
% P_con �����������
%% �¼�A���ʼ���
A=Bestfit_dan(x);
A0=Bestfit_dan(x,x0);
%% �¼�B���ʼ���
B=Bestfit_dan(y);
B0=Bestfit_dan(y,y0);
%% ���ϸ���C����
%C=Bestfit_copula(A,B);
C0=Bestfit_copula(A,B,A0,B0);
%% �������ʼ���
%���1��A<=a,B>b��P(A<=a��B>b)=U-C(U,V)
if varargin{1}==1
P_con=A0-C0;
%���2��A>a,B<=b��P(A>a��B<=b)=V-C(U,V)
elseif varargin{1}==2
P_con=B0-C0;
%���3��A>a,B>b��P(A>a��B>b)=1-U-V+C(U,V)
elseif varargin{1}==3
P_con=1-A0-B0+C0;
%���4��A<=a,B<=b��P(A<=a��B<=b)=C(U,V)
else
P_con=C0;
end
end