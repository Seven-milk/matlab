function [ Rsn,Rp ] = Yamamoto( y,x,IH,p,isp )
% [ Rsn,Rp ] = Yamamoto( y,x,IH,p,isp )
%  y: the sequence
%  x: the x-coordinate of sequence(set as [] if not use, default=1:length(y))
%  IH: the length of subsequence(default=20)
%  p: the level of significance for t-testing(default=0.05)
%  isp: whether plot a figure or not(1 for yes, 0 for no, default=1)
% Calculating and plotting the curve of the SNR for Yamamoto test.
%   Yamamoto method tests signal-to-noise ratio(SNR) of climate to discuss 
%   mutation problem, defined mutations and strong mutations by Rsn¡Ý1 and 
%   Rsn¡Ý2. This method is also based on testing the mean value difference 
%   between the two subsequences.
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

x=xlsread('shuju2008.xlsx','A1:A55'); 
y=xlsread('shuju2008.xlsx','H1:H55'); 

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
%    error('not enought input');
% end
if isempty(p)
    p = 0.05;
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
s1(i) = std(y(i:i+n1-1),1);
s2(i) = std(y(i+n1:i+N-1),1);
end
Rsn = abs(m1-m2)./(s1+s2);
tp = abs(tinv(p/2,N-2));
Rp = tp/sqrt(IH);

if ~isp
    return
end

xt = x(n1:length(y)-n2);
xl = [min(xt)-(max(xt)-min(xt))*.01 max(xt)+(max(xt)-min(xt))*.01];
plot(xt,Rsn,'color','b','linewidth',.8);
hold on
plot(xl,[Rp Rp],'color','r');

yl0 = get(gca,'ylim');
yl = [min(yl0)-(max(yl0)-min(yl0))*.02 max(yl0)+(max(yl0)-min(yl0))*.05];
set(gca,'xlim',xl,'ylim',yl,'Fontname','Times New Roman','FontSize',10);
text(xl(2)+(xl(2)-xl(1))*.005,Rp,['p=',num2str(p)],'Fontname','Times New Roman','FontSize',10);

title('Yamamoto method')
end

