function d=p_standard(c)
%�������ݴ���,���ڹ淶��ԭ�򣬲������������⺬�壬��Ҫ����Ϊmm
%input:c is a series of Hydrometeorological Elements like P
n=length(c);
d=zeros(n,1);
for i=1:n
    if c(i)>=30000
         if c(i)<31000
            d(i)=c(i)-30000;
        elseif c(i)<32000
            d(i)=c(i)-31000;
         elseif (c(i)==32700)|(c(i)==32744)|(c(i)==32766)
            d(i)=0;
        else
            d(i)=c(i)-32000;
         end
    else
        d(i)=c(i);
    end
end
end