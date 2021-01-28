%持续性分析，R/S法
function [H,V,C]=RS(x)
%% 参数说明
% x 待检验的序列,输入列向量
% H H指数
% V V统计量
% C 关联尺度
%% 预设参数
n=length(x);
n_max=floor(n/2);%最大区间长度为floor(n/2),因为区间数目要大于1
%% 计算RS统计量R_S
%划分区间计算区间内的RS
for i=2:n_max%以长度i划分子区间,最小为2，因为计算极差最小要有两个
    m=floor(n/i);%区间数目
%     while m>1%区间数目需要大于1，前面定义了，肯定大于1 
    x_=x(1:m*i);%取整为x_
    x_1=reshape(x_,i,m);%分区间
      for j=1:m%每个区间内计算
    mu(j)=mean(x_1(:,j));%区间均值序列
    s(j)=std(x_1(:,j));%区间标准差
        for j1=1:length(x_1(:,j))
            b(j1,j)=sum(x_1(1:j1,j)-mu(j));%区间累积离差
        end
    b1(j)=max(b(:,j))-min(b(:,j));%区间极差
      end
    RS(i-1)=mean(b1./s);%计算RS
%     clear mu s b b1
end

%% 最小二乘，计算Hrust指数
%log(RS)~log([2:n_max])
t=log([2:n_max]);%区间长度对数化序列
H_=polyfit(log(t),log(RS),1);%拟合出系数
H=H_(1);%斜率即为H指数
%% 计算V统计量和C
V=RS./sqrt(t);
C=2^(2*H-1)-1;
%% 绘图
figure
hold on
h=scatter(log(t),log(RS));
h=[h,scatter(log(t),V)];
h=[h,plot(log(t),H_(1)*log(t)+H_(2),'--')];
h=[h,plot(log(t),V)];
xlabel('LOG(n)');
ylabel('LOG(RS)');
title('RS持续性分析');
legend(h([1,3,4]),'散点图','最小二乘拟合','V统计量');
hold off
%[t',log(RS)',(H_(1)*t+H_(2))',V']
end
    
   

    
    
    
    
    
    
    

