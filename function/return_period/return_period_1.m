%计算单变量的重现期
function [cxq]=return_period_1(x,T,varargin)
%输入边缘值x，事件发生的平均间隔时间T
%输出cxq，样本
%可变输入，则输出给定值的重现期
[A]=Bestfit_dan_nop3(x);%使用Bestfit_nop3的简化程序，免得运算时长太大
%不需要0值处理，因为不需要copula拟合
%样本重现期计算
cxq=T./(1-A);
if nargin==3
    [A1]=Bestfit_dan_nop3(x,varargin{1});%使用Bestfit_nop3的简化程序，免得运算时长太大
    %样本重现期计算
    cxq=T./(1-A1);
end
end