%单累积曲线Single cumulative curve
function []=cum_curve(date,x)
%计算累积序列
x_cum=zeros(length(x),1);
x_cum(1)=x(1);
for i=2:length(x)
    x_cum(i)=x_cum(i-1)+x(i);
end
%plot
figure
date1=datenum(date);
plot(date1,x_cum);
xlabel('年份');
ylabel('累积值');
title('单累积曲线');
datetick('x','yyyy');
end