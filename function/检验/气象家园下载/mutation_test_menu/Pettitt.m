function [ t0,P ] = Pettitt( y,x )
% [ t0,P ] = Pettitt( y,x )
%  y: the sequence
%  x: the x-coordinate of sequence(set as [] if not use, default=1:length(y))
%  t0: where the mutation point locate
%  P: a statistic and considering the significance of mutation point when 
%     P¡Ü0.5 
% Finding and calculating the value of mutation point by Pettitt test.
%   Pettitt method is a non-parametric mutation test like M-K test. 
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

if nargin<2
    x = [];
end
if nargin<1
    error('not enought input');
end
if isempty(x)
    x = 1:length(y);
end

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
t0 = x(abs(s)==kt0);
P = 2*exp(-6*kt0^2/(N^3+N^2));
if P<=.5
    disp([num2str(t0),' is a significant mutation point']);
else
    disp([num2str(t0),' is not a significant mutation point']);
end
end

