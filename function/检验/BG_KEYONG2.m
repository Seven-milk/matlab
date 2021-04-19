clc;clear;close all
data=xlsread('testdata.xlsx');
Y=data(:,2); 
t=data(:,1); 
N=length(Y);
for i=2:N-1
    nl = length(Y(1:i));
    nr = length(Y(i:N));
    ml = mean(Y(1:i));
    mr = mean(Y(i:N));
    vl = var(Y(1:i));
    vr = var(Y(i:N));
    T(i,1) = abs((ml-mr)/sqrt(1/nl+1/nr)/sqrt(((nl-1)*vl+(nr-1)*vr)/...
        (nl+nr-2)));
    T(i+1,1) = 0;
end

Tmax = max(T);% 突变点
[m,index]=max(T);%求a数组的最大值以及它所在的位置
t0=t(1)+index-1;
gamma = 4.19*log(N)-11.54;
delta = .4;
v = N-2;
PTmax = (1-betainc(v/(v+Tmax^2),delta*v,delta))^gamma;
plot(t,T,'-k','linewidth',1.5)
hold on
%line([t0,t0],[0,Tmax],'linestyle','-');
plot([t0,t0],[0,Tmax],'-r','linewidth',1.5)
xlabel('年份');
ylabel('统计量T');
title('BG分割算法');
text(1968,3,{'P(T_{max})=PTmax,';'P(T_{max})>P_{0}'},'FontSize',12);
% axis([0 12,-inf,inf])
% axis([XMIN XMAX YMIN YMAX ZMIN ZMAX])
axis([min(t) max(t) -inf inf])