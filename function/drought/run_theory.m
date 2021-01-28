%run_theory���γ�����
function [D,S,flag_start,flag_end]=run_theory(x,H0)
%% ��������
%x     ָ������
%H0    ��ֵ
%% �������
%D,S                     ��ʱ�Ҷȣ��Ҷȵ�λΪ1*ʱ�䵥λ���£��գ�����ʱ��λ=ָ���ĵ�λ
%flag_start,flag_end     ��ʼ����ʱ�䣬����ʱ�䣬��Ӧ�����е����
%% ʶ��
date=(1:1:length(x));%����ʱ�䣬�����
%Ѱ�Ҹɺ���ʼ�ͽ�����ʱ��
flag_start=[];
i1=1;
flag_end=[];
i2=1;
if x(1)<=H0
    flag_start(i1)=date(1);%�жϵ�һ���Ƿ��ǿ�ʼ
    i1=i1+1;
    if x(2)>H0%����һ��Ϊ��ʼʱ��Ҫ�жϵ�һ���Ƿ��ǽ���
        flag_end(i2)=date(1);
        i2=i2+1;
    end
end
for i=2:length(x)-1
    if x(i)<=H0&&x(i-1)>H0%�жϿ�ʼ��������ʱ��С��H0����ʱ�̴���H0
        flag_start(i1)=date(i);
        i1=i1+1;
    end
    if x(i)<=H0&&x(i+1)>H0%�жϽ�����������ʱ��С��H0����ʱ�̴���H0
        flag_end(i2)=date(i);
        i2=i2+1;
    end
end
if x(end)<=H0
    flag_end(i2)=date(end);%�ж����һ���Ƿ�Ϊ����
    if x(end-1)>H0%�����һ���ǽ���ʱ���ж����һ���Ƿ�Ϊ��ʼ
        flag_start(i1)=date(end);
    end
end
%flag_start��flag_endҪͬά���п�ʼ�����н���
%������ʱ
D=[];
D=flag_end-flag_start+1;
%�����Ҷ�
S=[];
x_=abs(x-H0);%�Ҷ�����ֵ���Ҽ�ȥH0����һ����
for i=1:length(flag_start)
    S(i)=sum(x_(flag_start(i):flag_end(i)));
end
D=D';
S=S';
flag_start=flag_start';
flag_end=flag_end';
end