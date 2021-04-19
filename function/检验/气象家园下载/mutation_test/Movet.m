function [ t ] = Movet( x,y,IH,p )
% [ t ] = Movet( x,y,IH,p )
%  x: the x-coordinate of sequence(just for plot, set as [] if not use)
%  y: the sequence
%  IH: the length of subsequence
%  p: the level of significance for t-testing
% Calculate and plot the curve of the t statistics for moving t test.
%   Moving t method is a mutation test by checking the mean value
%   difference between two subsequences in a sequence.

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
tp(1:length(t)) = tinv(p/2,N-2);

%return
figure
if isempty(x)
    plot(-t,'color','b');
    hold on
    plot(abs(tp),'color','r');
    hold on
    plot(-abs(tp),'color','r');
    hold on
    plot(zeros(1,length(tp)),'color','k');
else
    xt = x(n1:length(y)-n2);
    plot(xt,-t,'color','b');
    hold on
    plot(xt,abs(tp),'color','r');
    hold on
    plot(xt,-abs(tp),'color','r');
    hold on
    plot(xt,zeros(1,length(tp)),'color','k');
end
title('Moving t test')
end

