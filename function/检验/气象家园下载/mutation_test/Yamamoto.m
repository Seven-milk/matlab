function [ Rsn ] = Yamamoto( x,y,IH )
% [ Rsn ] = Yamamoto( x,y,IH )
%  x: the x-coordinate of sequence(just for plot, set as [] if not use)
%  y: the sequence
%  IH: the length of subsequence
% Calculate and plot the curve of the SNR for Yamamoto test.
%   Yamamoto method tests signal-to-noise ratio(SNR) of climate to discuss 
%   mutation problem, defined mutations and strong mutations by Rsn¡Ý1 and 
%   Rsn¡Ý2. This method is also based on testing the mean value difference 
%   between the two subsequences.

n1 = IH;
n2 = n1;
N = n1+n2;
for i = 1:length(y)-N+1
m1(i) = mean(y(i:i+n1-1));
m2(i) = mean(y(i+n1:i+N-1));
s1(i) = std(y(i:i+n1-1));
s2(i) = std(y(i+n1:i+N-1));
end
Rsn = abs(m1-m2)./(s1+s2);
R1(1:length(Rsn)) = 1;
R2(1:length(Rsn)) = 2;

%return
figure
if isempty(x)
    plot(Rsn,'color','b');
    hold on
    plot(R1,'color','r');
    hold on
    plot(R2,'color','r');
else
    xt = x(n1:length(y)-n2);
    plot(xt,Rsn,'color','b');
    hold on
    plot(xt,R1,'color','r');
    hold on
    plot(xt,R2,'color','r');
end
title('Yamamoto method')
end

