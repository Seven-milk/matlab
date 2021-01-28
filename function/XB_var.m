%1.xiaozao函数，是需要对标准化的序列进行消除数据噪音分析；
%2.Db3函数，是对数列进行Db3趋势分析；
%3.period函数，是求得时间序列的实部和模的平方。
%其中周期变化图是实部的等值线图
%而小波方差是模的平方的算数平均。

% 从文件中读取数据
[Data,Txt] = xlsread('\Data_input\年径流数据.xls');
% 提取矩阵Data中的数据，
D=Data(:,1);%时间序列，年
X=Data(:,7);%径流数据序列
Xt=Txt(7);


n=length(X);   %求出资料X序列的长度n
s=zscore(X);
scales=(1:n);
%进行连续小波变换得到小波系数矩阵,选择复morlet小波函数
wf=cwt(s,scales,'cmor1-1.5');
% 求得系数的实部
shibu=real(wf);
subplot(1,2,1);
%figure;
contourf(shibu,10);

colormap('cool');
colorbar;
xlabel('时间');
ylabel('时间尺度（年）');

Xt=strrep(Xt,'年径流量(亿m3)','');
%Xt1=strcat(Xt,'径流小波系数实部等值线图');
%title(Xt1)

set(gca,'XLim',[0 n+1])
time=min(D):fix((max(D)-min(D))/5):max(D);
%set(gca,'xTicklabel',time) %更新XTickLabel


% 小波方差是模的平方的算数平均
mo=abs(wf);
mofang=mo.^2;
fangcha=mean(mofang,2);
%subplot(1,2,2);
%figure;
plot(fangcha,'k-','linewidth',1.5);
xlabel('时间尺度（年）');
ylabel('小波方差');

Xt2=strcat(Xt,'径流小波方差图');
title(Xt2)




