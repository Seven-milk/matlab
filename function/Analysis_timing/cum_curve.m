%���ۻ�����Single cumulative curve
function []=cum_curve(date,x)
%�����ۻ�����
x_cum=zeros(length(x),1);
x_cum(1)=x(1);
for i=2:length(x)
    x_cum(i)=x_cum(i-1)+x(i);
end
%plot
figure
date1=datenum(date);
plot(date1,x_cum);
xlabel('���');
ylabel('�ۻ�ֵ');
title('���ۻ�����');
datetick('x','yyyy');
end