function xr=Newton(fun,x0,D)
[f0,df]=feval(fun,x0);
if df==0;
    error('d[f(x)/dx]=0 at x0');
end
if nargin<3;
    D=1e-6;
end
d=f0/df;
while abs(d)>D;
    x1=x0-d;
    x0=x1;
    [f0,df]=feval(fun,x0);
    if df==0;
        error('d[f(x)/dx]=0 at x0');
    end
    d=f0/df
end
xr=x1;