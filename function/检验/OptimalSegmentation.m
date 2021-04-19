function [B] = OptimalSegmentation( T,X )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%2014-2-6

n=length(X);         A=zeros(n);          M=zeros(n);
D=zeros(n);          B=zeros(n,1);
C=zeros(n,1);       Ix=zeros(n,1);
Ia=zeros(n,1);      Id=zeros(n,1);
SUM=0;
for i=1:n
    if  i<=n-1
        mean1=mean(X(1:i,1));
        mean2=mean(X(i+1:n,1));
        for j=1:i
            A(i,j)=(X(j)-mean1)^2;
        end
        for j=i+1:n
            A(i,j)=(X(j)-mean2)^2;
        end
    else
        mean3=mean(X);
        for j=1:n
            A(i,j)=(X(j)-mean3)^2;
        end
    end
end
for i=1:n
    for j=1:n
        M(i,j)=1/(1+(A(i,j)^2));
    end
end
sum1=sum(M,2);
for i=1:n
    for j=1:n
        D(i,j)=M(i,j)/sum1(i,1);
    end
end
for i=1:n
    for j=1:n
        SUM=SUM+D(i,j)*log(D(i,j));
    end
    Ix(i)=1/log(2)*SUM;
    SUM=0;
end
Im=1/log(2)*log(n);
for i=1:n
    Id(i)=Im+Ix(i);
end
max1=max(Id);
for i=1:n
    Ia(i)=Id(i)/max1*100;
end
for i=1:n
    C(i)=Ia(i)/Ia(n);
end
sum2=sum(C);
for i=1:n
    B(i)=C(i)/sum2-1;
end
width=385;height=370;left=200;bottem=100;
set(gcf,'position',[left,bottem,width,height]) ;
set(gca,'fontsize',7);
plot(T(1: n),B,'.-k','LineWidth',1)
legend('统计量过程线');
xlabel(['年份',sprintf('\n'),'Year'],'FontName','Times New Roman');ylabel(['统计量',sprintf('\n'),'Statistic'],'FontName','Times New Roman');
set(gca,'XLim',[min(T),max(T)]);
set(gca,'FontName','Times New Roman','FontSize',8);
set(legend,'EdgeColor',[1 1 1],'FontSize',7);
end

