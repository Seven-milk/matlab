%1.xiaozao����������Ҫ�Ա�׼�������н���������������������
%2.Db3�������Ƕ����н���Db3���Ʒ�����
%3.period�����������ʱ�����е�ʵ����ģ��ƽ����
%�������ڱ仯ͼ��ʵ���ĵ�ֵ��ͼ
%��С��������ģ��ƽ��������ƽ����

% ���ļ��ж�ȡ����
[Data,Txt] = xlsread('\Data_input\�꾶������.xls');
% ��ȡ����Data�е����ݣ�
D=Data(:,1);%ʱ�����У���
X=Data(:,7);%������������
Xt=Txt(7);


n=length(X);   %�������X���еĳ���n
s=zscore(X);
scales=(1:n);
%��������С���任�õ�С��ϵ������,ѡ��morletС������
wf=cwt(s,scales,'cmor1-1.5');
% ���ϵ����ʵ��
shibu=real(wf);
subplot(1,2,1);
%figure;
contourf(shibu,10);

colormap('cool');
colorbar;
xlabel('ʱ��');
ylabel('ʱ��߶ȣ��꣩');

Xt=strrep(Xt,'�꾶����(��m3)','');
%Xt1=strcat(Xt,'����С��ϵ��ʵ����ֵ��ͼ');
%title(Xt1)

set(gca,'XLim',[0 n+1])
time=min(D):fix((max(D)-min(D))/5):max(D);
%set(gca,'xTicklabel',time) %����XTickLabel


% С��������ģ��ƽ��������ƽ��
mo=abs(wf);
mofang=mo.^2;
fangcha=mean(mofang,2);
%subplot(1,2,2);
%figure;
plot(fangcha,'k-','linewidth',1.5);
xlabel('ʱ��߶ȣ��꣩');
ylabel('С������');

Xt2=strcat(Xt,'����С������ͼ');
title(Xt2)




