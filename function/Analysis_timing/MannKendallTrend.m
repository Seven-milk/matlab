%���Ĳο�����
function [Beta,MKResult,S_stdS,ConInterval] = MannKendallTrend(X,Alpha)
% ʱ���������ݵ�Mann-Kendall���Ʒ���
%
% ԭ���裺 H0  Beta == 0
% �� |Z| <= pNorm ,�����ڵ�ǰ������ˮƽAlpha�½���ԭ����
% �� Z > pNorm , �����ڵ�ǰ������ˮƽAlpha����Ϊ���������ƣ���ʱBeta > 0
% �� Z < -pNorm ,�����ڵ�ǰ������ˮƽAlpha����Ϊ���½����ƣ���ʱBeta < 0
%
% MKResult = [Z,pNorm];    (ͳ����S�ı�׼��)Zͳ�������ϲ��λ��
%
% Input
% X                             - ʱ���������ݣ�����
% Alpha                         - ������ˮƽ
%
% Output
% Beta                          - �������ƴ�С����б�Ȼ�б��(����仯���Ƶ�����)
% MKResult                      - MK���Ƽ����Zͳ������Z��λ����[Z,pNorm]
% S_stdS                        - ͳ����S����׼�[S,sqrt(varS)];
% ConInterval                   - ��������
%
%
%
%  -----------------------------------------------------

if (nargin < 2) || (isempty(Alpha)), Alpha = 0.05; end


N = length(X);
if N < 8, error('Error:MannKendallTrend: Ҫ������������Ŀ��С��8��'); end
% if N < 41, error('Error:MannKendallTrend: Ҫ������������Ŀ��С��40��'); end

S = 0;                                           % ʱ������X��MK���Ƽ����ͳ����S
for ii = 1:(N - 1)
for jj = ii:N
S = S + sign(X(jj) - X(ii));
end
end

% ���㷽��
varS = ( N * ( N - 1 ) * ( 2 * N + 5 ) ) / 18;

% ���� Z ͳ��������ͳ�������ӱ�׼��̬�ֲ�
if S == 0
Z = 0;
elseif S > 0
Z = (S - 1) / sqrt(varS);
else
Z = (S + 1) / sqrt(varS);
end

% ԭ���裺 H0  Beta == 0
% �� |Z| <= pNorm ,�����ڵ�ǰ������ˮƽAlpha�½���ԭ����
% �� Z > pNorm , �����ڵ�ǰ������ˮƽAlpha����Ϊ����������
% �� Z < -pNorm ,�����ڵ�ǰ������ˮƽAlpha����Ϊ���½�����
pNorm = norminv(1 - Alpha / 2);

% �����������Ƶı仯����
NCn2 = N * (N - 1) / 2;
XNew = zeros(1,NCn2);
kk = 1;
for ii = 1:(N - 1)
for jj = (ii+1):N
XNew(kk) = (X(jj) - X(ii)) / (jj - ii);
kk = kk + 1;
end
end
Beta = median(XNew);                             % �������Ƶı仯����

XNewSort = sort(XNew);                           % ��С��������
pos1 = fix((NCn2 - pNorm * sqrt(varS) ) / 2);
pos2 = fix((NCn2 + pNorm * sqrt(varS) ) / 2);
LConLimit = XNewSort(pos1);                      % ������������
UConLimit = XNewSort(pos2 + 1);                  % ������������

ConInterval = [LConLimit,UConLimit];             % ��������
S_stdS = [S,sqrt(varS)];
MKResult = [Z,pNorm];                            % MK���Ƽ�����

% end of function MannKendallTrend
%%