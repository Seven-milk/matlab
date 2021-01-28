function [y,df,d2y]=w(x)
y=x-log(x)-2;
if nargout>1;
    ff=sym('x-log(x)-2');
    dy=diff(ff);
    dy=subs(dy,x);
end
if nargout==3;
    d2y=diff(ff,2);
    d2y=subs(d2y,x);
end
