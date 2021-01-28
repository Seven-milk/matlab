function [f,a1,b1,r1,yue,e]=day_to_month(d,a,b,r)
%日数据处理为月数据,一般是日求和为月，也可以日均值为月；修改27行即可
%input:d,a,b,r,分别是日序列变量值，年份序列，月份序列，日份序列
%output:f,a1,b1,r1，分别是月序列变量值，月序列对应的年份序列，月份序列，日份序列
%yue 是总月数，e是日序列矩阵：由d的向量变为：31*年份的矩阵
%计算总月数,输出yue为总月数
% yue=1;
% for i=1:(length(b)-1)
%     if b(i)~=b(i+1)
%          yue=yue+1; 
%     end
% end
% %e为月份数据矩阵，f为月均值矩阵
% e=zeros(31,yue);
% f=zeros(yue,1);
% a1=zeros(yue,1);
% b1=zeros(yue,1);
% r1=zeros(yue,1);
% j=1;
% k=0;
% for i=1:(length(b)-1)
%     if b(i)==b(i+1)
%         k=k+1;       
%         e(k,j)=d(i);
%         a1(j)=a(i);
%         b1(j)=b(i);
%         r1(j)=r(i+1);
%     else 
%         e(k+1,j)=d(i);
%         f(j)=sum(e(1:k+1,j));%月均值或月求和
%         j=j+1;
%         k=0;
%     end
% end
yue=1;
for i=1:(length(b)-1)
    if b(i)~=b(i+1)
         yue=yue+1; 
    end
end
%e为月份数据矩阵，f为月均值、求和矩阵
e=zeros(31,yue);
f=zeros(yue,1);
j=1;
% k=1;
e(1,1)=d(1);
for i=2:length(b) 
    if a(i)~=a(i-1)
        j=j+1;
    end
    e(r(i),b(i)+(j-1)*12)=d(i);
end
for i=1:yue
    f(i)=sum(e(:,i));%求和或求均值
end
%计算对应月序列的年月日矩阵
a1=zeros(yue,1);
b1=zeros(yue,1);
r1=zeros(yue,1);
j=1;
for i=1:length(b)-1
    if b(i)~=b(i+1)
        a1(j)=a(i);
        b1(j)=b(i);
        r1(j)=r(i);
        j=j+1;
    end
end
a1(end)=a(end);
b1(end)=b(end);
r1(end)=r(end);
end
