function [ WA ] = LePage( x,y,IH,p )
% [ WA ] = LePage( x,y,IH,p )
%  x: the x-coordinate of sequence(just for plot, set as [] if not use)
%  y: the sequence
%  IH: the length of subsequence
%  p: the level of significance for chi2-testing
% Calculate and plot the curve of the WA statistics for Le Page test.
%   Le Page method is a distribution-free multi-sample non-parametric 
%   mutation test method, which is used to test the significance of
%   discrepancy between two independent ensembles. Its statistic WA
%   combines Wilcoxon Rank Sum Test(help ranksum) and Ansari-Bradley Test
%   (help ansaribradley).

n1 = IH;
n2 = n1;
N = n1+n2;
for i = 1:length(y)-N+1
y1(:) = y(i:i+n1-1);
y2(:) = y(i+n1:i+N-1);
[~,~,Wstats] = ranksum(y1,y2);
W = Wstats.ranksum;
EW = n1*(N+1)/2;
VW = n1*n2*(N+1)/12;
[~,~,Astats] = ansaribradley(y1,y2);
A = Astats.W;
EA = n1*(N+2)/4;
VA = n1*n2*(N^2-4)/48/(N-1);
WA(i) = (W-EW)^2/VW+(A-EA)^2/VA;
end
chip1(1:length(WA)) = chi2inv(1-p/2,2);
chip2(1:length(WA)) = chi2inv(p/2,2);

%return
figure
if isempty(x)
    plot(WA,'color','b');
    hold on
    plot(chip1,'color','r');
    hold on
    plot(chip2,'color','r');
else
    xt = x(n1:length(y)-n2);
    plot(xt,WA,'color','b');
    hold on
    plot(xt,chip1,'color','r');
    hold on
    plot(xt,chip2,'color','r');
end
title('Le Page method')
end

