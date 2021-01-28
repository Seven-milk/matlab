%�������Ӽ���,��������
function [R,V,E,flag]=sliding_window_rrv(date,h,h0,x,H0)
%% ����˵��
%��������date����������ţ�+����h+ÿ�λ�h0��������£�����һ�λ�һ���£�Ҳ����3��3�»���������������Ϊ������λ
%����xΪָ��,H0Ϊ��ֵ
%�����Ӧ�̶��龰�Ļ�������,��Ӧ��ʱ��flag
%ע��ʱ���Ӧ��ϵ��x��Ϊ�£���hҲӦת��Ϊ��
%%
%����flag,��Ӧ������еĴ��ڿ�ʼʱ�䣬����ʱ����м����ʱ��
flag_start=(1:h0:length(x)-h+1);%�������ʽ���ڣ��������
flag_end=(h:h0:length(x));
% flag=date(ceil(h/2):h0:ceil(h/2)+length(flag_start)-1);%���м�λΪ����ʱ��
flag=date(ceil(h/2):h0:length(x)-ceil(h/2)+1);%���м�λΪ����ʱ��
%%
%���y������y���㷽�����Թ̶��龰������Ϊ��,x(1)����ʱ,(flag_start(i):flag_end(i))Ϊһ������
% cxq_D=zeros(length(flag_start),1);
% cxq_S=zeros(length(flag_start),1);
R=zeros(length(flag_start),1);
V=zeros(length(flag_start),1);
E=zeros(length(flag_start),1);
for i=1:length(flag_start)
    x_=x(flag_start(i):flag_end(i));%����������
    [D,S]=run_theory(x_,H0);%�����ڸɺ�ʶ��
%     cxq_D(i)=return_period_1(D,T,D_);%�̶��龰������
%     cxq_S(i)=return_period_1(S,T,S_);
    R(i)=length(D)/sum(D);%�����ڼ���RRV
%     V(i)=sum(S)/length(D);
    V(i)=(sum(S)-H0*sum(D))/length(D);%���SPI����������Ҷȣ�һ���ɺ�i��sum(SPIi)=S(i)-H0*D(i),ȫ���ɺ�:sum(SPI)=sum(S)-H0*sum(D)
    E(i)=sum(D)/length(x_);
    clear D;
    clear S;
end
end
