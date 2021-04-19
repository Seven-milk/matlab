function [ t ] = Cramert( x,y,n1,p )
% [ t ] = Cramert( x,y,n1,p )
%  x: the x-coordinate of sequence(just for plot, set as [] if not use)
%  y: the sequence
%  n1: the length of subsequence
%  p: the level of significance for t-testing
% Calculate and plot the curve of the t statistics for Cramer test.
%   Cramer method is a mutation test by testing the mean value difference 
%   between the subsequence and the total sequence.

n = length(y);
for i = 1:n-n1+1
m1(i) = mean(y(i:i+n1-1));
end
tao = (m1-mean(y))/std(y);
t = tao.*sqrt(n1*(n-2)./(n-n1*(1+tao)));
tp(1:length(t)) = tinv(p/2,2*n1-2);

%return
figure
if isempty(x)
    plot(t,'color','b');
    hold on
    plot(abs(tp),'color','r');
    hold on
    plot(-abs(tp),'color','r');
    hold on
    plot(zeros(1,length(tp)),'color','k');
else
    [~,I]=min(abs(x(1:n1)-median(x(1:n1))));
    xt = x(I:I+length(tp)-1);
    plot(xt,t,'color','b');
    hold on
    plot(xt,abs(tp),'color','r');
    hold on
    plot(xt,-abs(tp),'color','r');
    hold on
    plot(xt,zeros(1,length(tp)),'color','k');
end
title('Cramer method')
end

