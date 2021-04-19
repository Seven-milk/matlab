function [ WA,chip ] = LePage( y,x,IH,p,isp )
% [ WA,chip ] = LePage( y,x,IH,p,isp )
%  y: the sequence
%  x: the x-coordinate of sequence(set as [] if not use, default=1:length(y))
%  IH: the length of subsequence(default=20)
%  p: the level of significance for chi2-testing(default=0.05)
%  isp: whether plot a figure or not(1 for yes, 0 for no, default=1)
% Calculating and plotting the curve of the WA statistics for Le Page test.
%   Le Page method is a distribution-free multi-sample non-parametric 
%   mutation test method, which is used to test the significance of
%   discrepancy between two independent ensembles. Its statistic WA
%   combines Wilcoxon Rank Sum Test(help ranksum) and Ansari-Bradley Test
%   (help ansaribradley).
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

x=xlsread('shuju2008.xlsx','A1:A55'); 
y=xlsread('shuju2008.xlsx','L1:L55'); 

if nargin<5
    isp = 1;
end
if nargin<4
    p = [];
end
if nargin<3
    IH = [];
end
if nargin<2
    x = [];
end
% if nargin<1
%   error('not enought input');
% end
if isempty(p)
    p = .05;
end
if isempty(IH)
    IH = 20;
end
if isempty(x)
    x = 1:length(y);
end

n1 = IH;
n2 = n1;
N = n1+n2;
for i = 1:length(y)-N+1
% y1(:) = y(i:i+n1-1);
% y2(:) = y(i+n1:i+N-1);
[~,~,Wstats] = ranksum(y(i:i+n1-1),y(i+n1:i+N-1));
W = Wstats.ranksum;
EW = n1*(N+1)/2;
VW = n1*n2*(N+1)/12;
[~,~,Astats] = ansaribradley(y(i:i+n1-1),y(i+n1:i+N-1));
A = Astats.W;
EA = n1*(N+2)/4;
VA = n1*n2*(N^2-4)/48/(N-1);
WA(i) = (W-EW)^2/VW+(A-EA)^2/VA;
end
chip1 = chi2inv(1-p/2,2);
chip2 = chi2inv(p/2,2);
chip = [chip1 chip2];

if ~isp
    return
end

xt = x(n1:length(y)-n2);
xl = [min(xt)-(max(xt)-min(xt))*.01 max(xt)+(max(xt)-min(xt))*.01];
plot(xt,WA,'color','b','linewidth',.8);
hold on
plot(xl,[chip1 chip1],'color','r');
hold on
plot(xl,[chip2 chip2],'color','r');

yl0 = get(gca,'ylim');
yl = [min(yl0)-(max(yl0)-min(yl0))*.02 max(yl0)+(max(yl0)-min(yl0))*.05];
set(gca,'xlim',xl,'ylim',yl,'Fontname','Times New Roman','FontSize',10);
text(xl(2)+(xl(2)-xl(1))*.005,chip1,['p=',num2str(p)],'Fontname','Times New Roman','FontSize',10);
text(xl(2)+(xl(2)-xl(1))*.005,chip2,['p=',num2str(p)],'Fontname','Times New Roman','FontSize',10);

title('Le Page method')
end

