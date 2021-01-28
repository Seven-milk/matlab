%条件概率函数P(A|B)
function [P_con]=P_condition(x,y,x0,y0,varargin)
%% 参数说明
% x 变量1序列
% y 变量2序列
% x0 变量1阈值，即X<=x中的x
% y0 变量2阈值
% varargin 输入事件情况，对应4种情况-1,2,3,4
% P_con 输出条件概率
%% 事件A概率计算
A=Bestfit_dan(x);
A0=Bestfit_dan(x,x0);
%% 事件B概率计算
B=Bestfit_dan(y);
B0=Bestfit_dan(y,y0);
%% 联合概率C计算
%C=Bestfit_copula(A,B);
C0=Bestfit_copula(A,B,A0,B0);
%% 条件概率计算
%情况1，A<=a,B>b：P(A<=a，B>b)=U-C(U,V)
if varargin{1}==1
P_con=A0-C0;
%情况2，A>a,B<=b：P(A>a，B<=b)=V-C(U,V)
elseif varargin{1}==2
P_con=B0-C0;
%情况3，A>a,B>b：P(A>a，B>b)=1-U-V+C(U,V)
elseif varargin{1}==3
P_con=1-A0-B0+C0;
%情况4，A<=a,B<=b：P(A<=a，B<=b)=C(U,V)
else
P_con=C0;
end
end