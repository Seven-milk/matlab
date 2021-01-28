R=dlmread('shuju3.txt');         %导入数据1并赋予R
P=dlmread('shuju4.txt');         %导入数据1并赋予P
r=length(R);                     %数据R的长度，即数据总个数
p=length(P);                     %数据P的长度，即数据总个数
D1=reshape(R,r,1); %重新调整矩阵R行数，列数，维数，即读取矩阵R转变成r*1矩阵并赋予D1
D2=reshape(P,p,1); %将矩阵P中元素返回到一个r*1的矩阵D2中
a=std2(D1)^2*(r-1);    %求方差    数据D1中所有元素均方差的平方乘以（r-1)
for i=1:r      %i从1到r循环，接着执行下面语句
    S1(i)=D1(i);    %D1矩阵中的第i行赋予S1
    o1(i)=std2(S1(1:i))^2*(i-1);    %滑动方差矩阵
end
for k=1:p      %k从1到P循环，接着执行下面语句
    S2(k)=D2(k);     %D2矩阵中的第K行赋予S2
    o2(k)=std2(S2(1:k))^2*(k-1);    %滑动方差矩阵
end
for m=1:(r-1)   %m从1到(r-1)循环，接着执行下面语句
    Rt(m)=(o1(m)+o2(r-m))/a;    %
end
for j=1:(r-1)     %j从1到(r-1)循环，接着执行下面语句
    f(j)=((r/(j*(r-j)))^0.5)*((Rt(j))^((2-r)/2));
    plot(f);%绘制f中变量的一维函数
    xlabel('年份');%图象上x写有年份
    ylabel('概率密度值');%图象上y写有概率密度值
end
[x y]=find(f==max(max(f)));%求出f中的最大值并
