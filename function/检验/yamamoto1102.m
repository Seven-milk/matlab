clc;
clear;
x=xlsread('shuju2008.xlsx','A1:A55'); 
y=xlsread('shuju2008.xlsx','B1:B55'); 
n=length(y);
for i=2:n-2
    y1(i,1)=mean(y(1:i));
    Std1(i,1)=std(y(1:i));
    y2(i,1)=mean(y(i+1:n));
    Std2(i,1)=std(y(i+1:n));
    
    Y(i,1)=abs(y1(i)-y2(i));
    Rsn(i,1)=Y(i)./(Std1(i)+Std2(i));
end
% Rsn>1,发生突变；Rsn>1,有强突变发生
plot(Rsn);