%抄的参考程序
function [Beta,MKResult,S_stdS,ConInterval] = MannKendallTrend(X,Alpha)
% 时间序列数据的Mann-Kendall趋势分析
%
% 原假设： H0  Beta == 0
% 当 |Z| <= pNorm ,表明在当前显著性水平Alpha下接受原假设
% 当 Z > pNorm , 表明在当前显著性水平Alpha下认为有上升趋势：此时Beta > 0
% 当 Z < -pNorm ,表明在当前显著性水平Alpha下认为有下降趋势：此时Beta < 0
%
% MKResult = [Z,pNorm];    (统计量S的标准化)Z统计量，上侧分位数
%
% Input
% X                             - 时间序列数据，向量
% Alpha                         - 显著性水平
%
% Output
% Beta                          - 衡量趋势大小的倾斜度或斜率(整体变化趋势的速率)
% MKResult                      - MK趋势检验的Z统计量及Z分位数，[Z,pNorm]
% S_stdS                        - 统计量S及标准差，[S,sqrt(varS)];
% ConInterval                   - 置信区间
%
%
%
%  -----------------------------------------------------

if (nargin < 2) || (isempty(Alpha)), Alpha = 0.05; end


N = length(X);
if N < 8, error('Error:MannKendallTrend: 要求数据样本数目不小于8！'); end
% if N < 41, error('Error:MannKendallTrend: 要求数据样本数目不小于40！'); end

S = 0;                                           % 时间序列X的MK趋势检验的统计量S
for ii = 1:(N - 1)
for jj = ii:N
S = S + sign(X(jj) - X(ii));
end
end

% 计算方差
varS = ( N * ( N - 1 ) * ( 2 * N + 5 ) ) / 18;

% 计算 Z 统计量，该统计量服从标准正态分布
if S == 0
Z = 0;
elseif S > 0
Z = (S - 1) / sqrt(varS);
else
Z = (S + 1) / sqrt(varS);
end

% 原假设： H0  Beta == 0
% 当 |Z| <= pNorm ,表明在当前显著性水平Alpha下接受原假设
% 当 Z > pNorm , 表明在当前显著性水平Alpha下认为有上升趋势
% 当 Z < -pNorm ,表明在当前显著性水平Alpha下认为有下降趋势
pNorm = norminv(1 - Alpha / 2);

% 计算整体趋势的变化速率
NCn2 = N * (N - 1) / 2;
XNew = zeros(1,NCn2);
kk = 1;
for ii = 1:(N - 1)
for jj = (ii+1):N
XNew(kk) = (X(jj) - X(ii)) / (jj - ii);
kk = kk + 1;
end
end
Beta = median(XNew);                             % 整体趋势的变化速率

XNewSort = sort(XNew);                           % 从小到大排序
pos1 = fix((NCn2 - pNorm * sqrt(varS) ) / 2);
pos2 = fix((NCn2 + pNorm * sqrt(varS) ) / 2);
LConLimit = XNewSort(pos1);                      % 置信区间下限
UConLimit = XNewSort(pos2 + 1);                  % 置信区间上限

ConInterval = [LConLimit,UConLimit];             % 置信区间
S_stdS = [S,sqrt(varS)];
MKResult = [Z,pNorm];                            % MK趋势检验结果

% end of function MannKendallTrend
%%