function [ t0,P ] = Pettitt( x,y )
% [ t0,P ] = Pettitt( x,y )
%  x: the x-coordinate of sequence(just for pointing, set as [] if not use)
%  y: the sequence
%  t0: where the mutation point locate
%  P: a statistic and considering the significance of mutation point when 
%     P¡Ü0.5 
% Find and calculate the value of mutation point by Pettitt test.
%   Pettitt method is a non-parametric mutation test like M-K test. 

N = length(y);
s = zeros(1,N);
for k=2:N
    r = 0;
    s(k) = 0;
    for j=1:k-1
        if y(k)>y(j)
            r = r+1;
        elseif y(k)<y(j)
            r = r-1;
        end
        s(k) = s(k-1)+r;
    end
end
kt0 = max(abs(s));
t0 = find(s==kt0);
if ~isempty(x)
    t0 = x(t0);
end
P = 2*exp(-6*kt0^2*(N^3+N^2));
end

