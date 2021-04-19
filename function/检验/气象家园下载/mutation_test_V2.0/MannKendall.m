function [ UF,UB ] = MannKendall( y,x,p,isp )
% [ UF,UB ] = MannKendall( y,x,p,isp )
%  y: the sequence
%  x: the x-coordinate of sequence(set as [] if not use, default=1:length(y))
%  p: the level of significance for z-testing(default=0.05)
%  isp: whether plot a figure or not(1 for yes, 0 for no, default=1)
% Calculating and plotting the curves of the UF and UB statistics for M-K test.
%   Mann-Kendall method is a non-parametric mutation testing mothed.
%   How to interpret the curves of UF and UB?
%   (1) If UF curves cross the confidence lines, the off-line intervals
%       denotes tendency of sequence is rising(decreasing) significantly
%       when.
%   (2) Under the condition of (1), the intersection of UF and UB that 
%       locates between the confidence lines denotes when mutation began.
%   (3) Notice: This testing method is excellent for mean value mutations,
%       but not efficient for others like turning, seesaw or variance
%       mutations.
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

if nargin<4
    isp = 1;
end
if nargin<3
    p = [];
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
if isempty(x)
    x = 1:length(y);
end

N = length(y);
UF = SMK(y);
yy = reshape(y,1,length(y));
yy = fliplr(yy);
UB = -fliplr(SMK(yy));
zp = abs(norminv(p/2));

if ~isp
    return
end

xl = [min(x)-(max(x)-min(x))*.01 max(x)+(max(x)-min(x))*.01];
plot(x,UF,'color',[0 .447 .741],'linewidth',.8);
hold on
plot(x,UB,'color',[.85 .325 .098],'linewidth',1.6);
hold on
ff = {'UF';'UB'};
legend(ff,'box','off','fontweight','normal')
plot(xl,[zp zp],'k');
hold on
plot(xl,-[zp zp],'k');
hold on
plot(xl,[0 0],'k');

yl0 = get(gca,'ylim');
yl = [min(yl0)-(max(yl0)-min(yl0))*.02 max(yl0)+(max(yl0)-min(yl0))*.05];
set(gca,'xlim',xl,'ylim',yl,'Fontname','Times New Roman','FontSize',10);
text(xl(2)+(xl(2)-xl(1))*.005,zp,['p=',num2str(p)],'Fontname','Times New Roman','FontSize',10);
text(xl(2)+(xl(2)-xl(1))*.005,-zp,['p=',num2str(p)],'Fontname','Times New Roman','FontSize',10);

title('Mann-Kendall method')

function U = SMK( Y )
N = length(Y);
s = zeros(1,N);
U(1) = 0;
for k=2:N
    r = 0;
    s(k) = 0;
    for j=1:k-1
        if Y(k)>Y(j)
            r = r+1;
        end
        s(k) = s(k-1)+r;
    end
    E = k*(k-1)/4;
    VAR = k*(k-1)*(2*k+5)/72;
    U(k) = (s(k)-E)/sqrt(VAR);
end

