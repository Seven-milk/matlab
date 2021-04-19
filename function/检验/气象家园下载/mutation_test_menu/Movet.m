function [ t,tp ] = Movet( y,x,IH,p,isp )
% [ t,tp ] = Movet( y,x,IH,p,isp )
%  y: the sequence
%  x: the x-coordinate of sequence(set as [] if not use, default=1:length(y))
%  IH: the length of subsequence(default=20)
%  p: the level of significance for t-testing(default=0.05)
%  isp: whether plot a figure or not(1 for yes, 0 for no, default=1)
% Calculating and plotting the curve of the t statistics for moving t test.
%   Moving t method is a mutation test by checking the mean value
%   difference between two subsequences in a sequence.
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

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
if nargin<1
    error('not enought input');
end
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
m1(i) = mean(y(i:i+n1-1));
m2(i) = mean(y(i+n1:i+N-1));
v1(i) = var(y(i:i+n1-1));
v2(i) = var(y(i+n1:i+N-1));
end
t = (m1-m2)./sqrt((n1*v1+n2*v2)/(N-2))./sqrt(1/n1+1/n2);
tp = abs(tinv(p/2,N-2));

if ~isp
    return
end

xt = x(n1:length(y)-n2);
xl = [min(xt)-(max(xt)-min(xt))*.01 max(xt)+(max(xt)-min(xt))*.01];
plot(xt,-t,'color','b','linewidth',.8);
hold on
plot(xl,[tp tp],'color','r');
hold on
plot(xl,[-tp -tp],'color','r');
hold on
plot(xl,[0 0],'color','k');

yl0 = get(gca,'ylim');
yl = [min(yl0)-(max(yl0)-min(yl0))*.02 max(yl0)+(max(yl0)-min(yl0))*.05];
set(gca,'xlim',xl,'ylim',yl,'Fontname','Times New Roman','FontSize',10);
text(xl(2)+(xl(2)-xl(1))*.005,tp,['p=',num2str(p)],'Fontname','Times New Roman','FontSize',10);
text(xl(2)+(xl(2)-xl(1))*.005,-tp,['p=',num2str(p)],'Fontname','Times New Roman','FontSize',10);

title('Moving t test')
end

