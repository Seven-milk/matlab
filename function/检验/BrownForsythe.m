function [ F,Fa ] = BrownForsythe( T,X )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%2014-2-8
n=length(X);
mean1=mean(X);
F=zeros(n,1);
f=zeros(n,1);
for i=2:n-2
    mean2=mean(X(1:i));
    d2=(std(X(1:i),0))^2;
    mean3=mean(X(i+1:n));
    d3=(std(X(i+1:n),0))^2;
    F1=i*((mean2-mean1)^2)+(n-i)*((mean3-mean1)^2);
    F2=(1-i/n)*d2+(1-(n-i)/n)*d3;
    F(i)=F1/F2;
    a1=(1-i/n)*d2/F2;
    a2=(1-(n-i)/n)*d3/F2;
    f(i)=1/((a1^2)/(i-1)+(a2^2)/(n-i-1));  
end
Fa=finv(0.95,1,f);
width=385;height=370;left=200;bottem=100;
set(gcf,'position',[left,bottem,width,height]) ;
set(gca,'fontsize',7);
plot(T(2:n-2),F(2:n-2),'.-k','LineWidth',1);hold on
plot(T(2:n-2),Fa(2:n-2),':k','LineWidth',1);
legend('统计量过程线','临界值');
xlabel(['年份',sprintf('\n'),'Year'],'FontName','Times New Roman');ylabel(['统计量',sprintf('\n'),'Statistic'],'FontName','Times New Roman');
set(gca,'XLim',[min(T),max(T)]);
set(gca,'FontName','Times New Roman','FontSize',8);
set(legend,'EdgeColor',[1 1 1],'FontSize',7);
end

    

