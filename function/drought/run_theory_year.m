%����������ʱ���Ҷȵ�run_theory
function [D,S]=run_theory_year(date,x,H0)
%% ��������
% date  ָ�����е�date
% x     ָ�����У�Ҫ�����������У������(����)~��ĩ��β�
% H0    ��ֵ
                                        % unit  ָ�����е�ʱ�䵥λ,1��Ӧ���³߶ȣ�2��Ӧ���ճ߶ȣ�˵������߶�ֱ����run_theory���ɣ���DS=�꣩
%% �������
% D,S    ��Ӧ��ÿ�����ʱ�Ҷȣ���λΪ1*ָ��߶ȣ���Ϊ����ָ��ʶ��ģ�
%% Ԥ����
a=year(date);%��Ӧ��date���ꡢ�¡������У�Ϊ�˽���ת��
%b=month(date);
%r=day(date);
n=a(end)-a(1)+1;%һ�������꣬���������DS���г�
D=zeros(n,1);
S=zeros(n,1);
%% ʶ�𡪡���������DS
j=zeros(1,2);j(1,1)=1;%���ڿ���ÿ�꿪ͷ�ͽ���
k=1;%����DS
for i=1:length(x)-1
        if a(i)~=a(i+1)
            j(1,2)=i;
            x_=[];
            x_=-x(j(1,1):j(1,2));
            x_=x_+H0;
            x_(find(x_<0))=0;
            S(k)=sum(x_);
            D(k)=sum(x_>0);
            k=k+1;
            j(1,1)=i+1;
        end
        if i==length(x)-1
            j(1,2)=i+1;
            x_=[];
            x_=-x(j(1,1):j(1,2));
            x_=x_+H0;
            x_(find(x_<0))=0;
            S(k)=sum(x_);
            D(k)=sum(x_>0);
            k=k+1;
        end
end
end