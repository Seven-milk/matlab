function [num,UF,UB]=MK_test_VD(date,x)
%MK变异诊断的程序,输入必须为列向量——用到flipud
%计算UFK-------------------------------------------------------
n=length(x);
function UF=UFK(x)
%计算a矩阵----------------------------------------
a=zeros(n,n);
for i=1:n
    for j=1:i
        a(i,j)=x(i)>x(j);%用逻辑形式2>1，返回1
    end
end
%计算sk序列,UFK----------------------------------------
S=zeros(n-1,1);
UF=zeros(n,1);
for k=1:n-1
    S(k)=sum(sum(a(1:(k+1),:)));%S是n-1个，从第二个求和到第n个
    E=(k+2)*(k+1)/4;%均值，注意这里k本应从2到n，但为序号方便，这里k=1:n-1，所以加1
    V=k*(k+1)*(2*(k+1)+5)/72;%方差
    UF(k+1)=(S(k)-E)/(V^0.5);%从2开始，默认UF1=0，UF(K+1)与S(k)对应，k=1，UF2,S(1)-S2   删%abs
end
end
%--------------------------------------------------
%计算UFK,UBK
UF=UFK(x);
UB=-flipud(UFK(flipud(x')'));%x翻转（得到逆序的UF-逆序时间轴）+UB翻转（保持时间轴一致）
%以0.5为置信水平，临界值为+-1.96
h1=zeros(n,1);
h2=zeros(n,1);
h3=zeros(n,1);
h1(:)=1.96;
h2(:)=-1.96;
h3(:)=0;
%绘图
figure
hold on 
date1=datenum(date);
% date1=date;
plot(date1,UF,'r');%UF序列
plot(date1,UB,'b');%UB序列
plot(date1,h1,'-.');%上临界
plot(date1,h2,'-.');%下临界
plot(date1,h3,'-.');%下临界
legend('UF','UB','1.96','-1.96','0');
xlabel('年份');
ylabel('序列值');
title('MK变异诊断');
datetick('x','yyyy');
hold off
%寻找变异点
U1=UF-UB;
log_=zeros(length(U1),1);
for i1=1:length(U1)-1
    log_(i1)=U1(i1)*U1(i1+1);
end
num1=[];
num1=find(log_<0);%若存在，则在i和i+1之间存在变异点,输出为列数据（存在多个变异点时）
if isempty(num1)==0%若非空，存在变异点
    num=date(num1);%输出为date数组，用cell存比较好
else
    num=datetime(0,0,0);
end
end