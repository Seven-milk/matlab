day=[1:365];
p=zeros(365,1);
p(:)=10;
EP_1=zeros(365,1);
EP_2=zeros(365,1);
for i=1:365
    EP_1(i)=p(i)^(-(366-i)/365);
    EP_2(i)=mean(p(1:(366-i)));
end
hold on
plot(day,EP_1);
plot(day,EP_2);