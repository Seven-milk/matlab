function [ UF,UB ] = MannKendall( x,y,p )
% [ UF,UB ] = MannKendall( x,y,p )
%  x: the x-coordinate of sequence(just for plot, set as [] if not use)
%  y: the sequence
%  p: the level of significance for z-testing
% Calculate and plot the curves of the UF and UB statistics for M-K test.
%   Mann-Kendall method is a non-parametric mutation testing mothed.
%   How to interpret the curves of UF and UB?
%   (1) If UF curves cross the confidence lines, the off-line intervals
%       denotes tendency of sequence is rising(decreasing) significantly
%       when.
%   (2) Under the condition of (1), the intersection of UF and UB which
%       locates between the confidence lines denotes where mutation begin.
%   (3) Notice: This testing method is excellent for mean value mutations,
%       but not efficient for others like turning, seesaw or variance
%       mutations.

N = length(y);
UF = SMK(y);
yy = reshape(y,1,length(y));
yy = fliplr(yy);
UB = -fliplr(SMK(yy));
zp(1:length(UF)) = norminv(p/2);

%return
figure
if isempty(x)
    plot(UF,'b');
    hold on
    plot(UB,'r--');
    hold on
    legend('UF','UB')
    plot(abs(zp),'k');
    hold on
    plot(-abs(zp),'k');
    hold on
    plot(zeros(1,N),'k');
else
    plot(x,UF,'b');
    hold on
    plot(x,UB,'r--');
    hold on
    legend('UF','UB')
    plot(x,abs(zp),'k');
    hold on
    plot(x,-abs(zp),'k');
    hold on
    plot(x,zeros(1,N),'k');
end
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

