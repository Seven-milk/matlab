%�����ά����ͬ��������
function [tx,lh]=return_period(x,y,T,varargin)
%�����Եֵx,y�����뷢�����¼���ƽ�����ʱ��T
%�������������lh,tx
%�ɱ����룬�������������Եֵvarargin{1}��varargin{2}�����������������
%��Ե�ֲ����
[A]=Bestfit_dan_nop3(x);%ʹ��nop3�򻯳��򣬼�С�����ٶȣ���ΪDSһ�㲻���������
[B]=Bestfit_dan_nop3(y);
%����Ե�ֲ�AB��0ֵ����-------------------------------------------------------
num1=find(A==0);%�����gamfit_modi�ظ�����Ϊ�����0ֵ��������٤��gamfit_modi�Ѿ���P_BEST��0ֵ�����ˣ����������û��0��
if isempty(num1)==0
A(num1)=0.000001;
end
num2=find(B==0);
if isempty(num2)==0
B(num2)=0.000001;
end
%---------------1����
num3=find(A==1);
if isempty(num3)==0
A(num3)=0.999999;
end
num4=find(B==1);
if isempty(num4)==0
B(num4)=0.999999;
end
%-----------------------------------------------------------------------
%COPULA���
[C]=Bestfit_copula(A,B);
%���������ڼ���
tx=T./(C-A-B+1);
lh=T./(1-C);
%-------------------------------------------------------
%�������������ֵ�����ڣ��������return_period(x,y,T,x1,y1)
if nargin==5
    [A1]=Bestfit_dan_nop3(x,varargin{1});
    [B1]=Bestfit_dan_nop3(y,varargin{2});
        %---------------0ֵ����
            num1=find(A1==0);%�����gamfit_modi�ظ�����Ϊ�����0ֵ��������٤��gamfit_modi�Ѿ���P_BEST��0ֵ�����ˣ����������û��0��
        if isempty(num1)==0
            A1(num1)=0.000001;
        end
        num2=find(B1==0);
        if isempty(num2)==0
            B1(num2)=0.000001;
        end
        %---------------1����
            num3=find(A1==1);
        if isempty(num3)==0
        A1(num3)=0.999999;
        end
        num4=find(B1==1);
        if isempty(num4)==0
        B1(num4)=0.999999;
        end
    [C1]=Bestfit_copula(A,B,A1,B1); 
    %�����ڼ���
        tx=T./(C1-A1-B1+1);
        lh=T./(1-C1);
end
end
