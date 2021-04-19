function [ t,tp ] = Cramert( y,x,n1,p,isp )
% [ t,tp ] = Cramert( y,x,n1,p,isp )
%  y: the sequence
%  x: the x-coordinate of sequence(set as [] if not use, default=1:length(y))
%  n1: the length of subsequence(default=20)
%  p: the level of significance for t-testing(default=0.05)
%  isp: whether plot a figure or not(1 for yes, 0 for no, default=1)
% Calculating and plotting the curve of the t statistics for Cramer test.
%   Cramer method is a mutation test by testing the mean value difference 
%   between the subsequence and the total sequence.
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
    n1 = [];
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
if isempty(n1)
    n1 = 20;
end
if isempty(x)
    x = 1:length(y);
end

n = length(y);
for i = 1:n-n1+1
m1(i) = mean(y(i:i+n1-1));
end
tao = (m1-mean(y))/std(y);
t = tao.*sqrt(n1*(n-2)./(n-n1*(1+tao)));
tp = abs(tinv(p/2,2*n1-2));

if ~isp
    return
end

[~,I]=min(abs(x(1:n1)-median(x(1:n1))));
xt = x(I:I+length(t)-1);
xl = [min(xt)-(max(xt)-min(xt))*.01 max(xt)+(max(xt)-min(xt))*.01];
plot(xt,t,'color','b','linewidth',.8);
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

title('Cramer method')
end

