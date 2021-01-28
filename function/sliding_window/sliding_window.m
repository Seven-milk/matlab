%�̶��龰��̬�����ڼ���,��������
function [tx_,lh_,flag]=sliding_window(date,h,h0,x,H0,D_,S_)
%% ����˵��
%��������date����������ţ�+����h+ÿ�λ�����Сh0
%����xΪMSDIָ��,H0Ϊ��ֵD_S_Ϊ�̶��龰����Ϊ�����϶���һ���������и�������ӳ��������״̬�����̶��龰������
%�����Ӧ�̶��龰�Ļ�������,��Ӧ��ʱ��flag
%ע��ʱ���Ӧ��ϵ��x��Ϊ�£���hҲӦת��Ϊ��
%% 
%����flag,��Ӧ������еĴ��ڿ�ʼʱ�䣬����ʱ����м����ʱ��
flag_start=(1:h0:length(x)-h+1);%�������ʽ���ڣ��������
flag_end=(h:h0:length(x));
flag=date(ceil(h/2):h0:length(x)-ceil(h/2)+1);%���м�λΪ����ʱ��,��h��������ȡ�м�λ����hΪż����ȡ�м������Ŀ���һλ����h0Ϊ��������ʱ���һ��flag�������һ��ɾ��
% flag=date(ceil(h/2):1:ceil(h/2)+length(flag_start)-1);%���м�λΪ����ʱ��
%% 
%���y������y���㷽�����Թ̶��龰������Ϊ��,x(1)����ʱ��x(2)���Ҷ�,(flag_start(i):flag_end(i))Ϊһ������
tx_=zeros(length(flag_start),1);
lh_=zeros(length(flag_start),1);
for i=1:length(flag_start)
    x_=x(flag_start(i):flag_end(i));%����������
    [D,S]=run_theory(x_,H0);%�����ڸɺ�ʶ��
    T=length(x_)/12/length(S);%������ƽ��T,������ֵ��T�����Ƕ�����һ�Σ�����ǳ�12
    [tx_(i),lh_(i)]=return_period(D,S,T,D_,S_);%�̶��龰������
    clear D;
    clear S;
end
end
