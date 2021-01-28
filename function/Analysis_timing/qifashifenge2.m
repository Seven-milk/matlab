%江建华的程序
mu1=zeros(length(date),1);mu2=zeros(length(date),1);S1=zeros(length(date),1);S2=zeros(length(date),1);SD=zeros(length(date),1);T=zeros(length(date),1);
for i=2:50
    ZF_1=MSDI(1:i-1,1);ZF_2=MSDI(i+1:51,1);
    mu1(i)=mean(ZF_1);mu2(i)=mean(ZF_2);
    S1(i)=std(ZF_1); S2(i)=std(ZF_2);
    SD(i)=(sqrt(((i-2)*S1(i)^2+(50-i)*S2(i)^2)/(51-3)))*sqrt((1/(i-1)+1/(51-i)));
    T(i)=abs((mu1(i)-mu2(i))/SD(i));
end 
    PTmax=(1-betainc(49/(49+max(T)^2),0.4*49,0.4))^(4.19*log(51)-11.54);

plot(SJ,T)