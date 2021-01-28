%计算二维联合同现重现期
function [tx,lh]=return_period(x,y,T,varargin)
%输入边缘值x,y，输入发生该事件的平均间隔时间T
%输出样本重现期lh,tx
%可变输入，可以输入给定边缘值varargin{1}，varargin{2}，计算给定的重现期
%边缘分布拟合
[A]=Bestfit_dan_nop3(x);%使用nop3简化程序，减小运算速度（因为DS一般不服从这个）
[B]=Bestfit_dan_nop3(y);
%两边缘分布AB的0值处理-------------------------------------------------------
num1=find(A==0);%不会和gamfit_modi重复，因为如果有0值，且满足伽马gamfit_modi已经将P_BEST中0值修正了，这里出来就没有0了
if isempty(num1)==0
A(num1)=0.000001;
end
num2=find(B==0);
if isempty(num2)==0
B(num2)=0.000001;
end
%---------------1处理
num3=find(A==1);
if isempty(num3)==0
A(num3)=0.999999;
end
num4=find(B==1);
if isempty(num4)==0
B(num4)=0.999999;
end
%-----------------------------------------------------------------------
%COPULA拟合
[C]=Bestfit_copula(A,B);
%样本重现期计算
tx=T./(C-A-B+1);
lh=T./(1-C);
%-------------------------------------------------------
%若相求给定样本值重现期，修正输出return_period(x,y,T,x1,y1)
if nargin==5
    [A1]=Bestfit_dan_nop3(x,varargin{1});
    [B1]=Bestfit_dan_nop3(y,varargin{2});
        %---------------0值修正
            num1=find(A1==0);%不会和gamfit_modi重复，因为如果有0值，且满足伽马gamfit_modi已经将P_BEST中0值修正了，这里出来就没有0了
        if isempty(num1)==0
            A1(num1)=0.000001;
        end
        num2=find(B1==0);
        if isempty(num2)==0
            B1(num2)=0.000001;
        end
        %---------------1处理
            num3=find(A1==1);
        if isempty(num3)==0
        A1(num3)=0.999999;
        end
        num4=find(B1==1);
        if isempty(num4)==0
        B1(num4)=0.999999;
        end
    [C1]=Bestfit_copula(A,B,A1,B1); 
    %重现期计算
        tx=T./(C1-A1-B1+1);
        lh=T./(1-C1);
end
end
