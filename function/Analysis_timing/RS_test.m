%RS�ı������
function [deta_H,flag]=RS_test(x,d)%,���flag_max,deta_H_max
%% ����˵��
% x �����������,����������
% d ��������С�γ��ȣ�ͨ��ȡ10
% deta_H ����ľ���ֵH��Ǵ�d~n-d��ô�������ĵط�Ϊ�����
% flag ��Ӧ��deta_H�����
% % flag_max ���deta_H�����
% % deta_H_max ���deta_H
%% ����Ԥ��
n1=length(x);
%% ���и�����˼���ָ����
for i1=d:n1-d
    x_left=x(1:d);
    x_right=x(d+1:end);
    deta_H(i1-d+1)=abs(RS_(x_left)-RS_(x_right));
end
flag=[d:n1-d];
% flag_max=flag(find(deta_H==max(deta_H))-d+1);
% deta_H_max=max(deta_H);
%% ��ͼ
figure 
plot(flag-d+1,deta_H);
xlabel('���');
ylabel('deta_H');
title('R/S�������');
%-----------------------------------------------------------------------�Ӻ�����Ϊ�����ָ�ΪRS_
function [H]=RS_(x)
%% Ԥ�����
n=length(x);
n_max=floor(n/2);%������䳤��Ϊfloor(n/2),��Ϊ������ĿҪ����1
%% ����RSͳ����R_S
%����������������ڵ�RS
for i=2:n_max%�Գ���i����������,��СΪ2����Ϊ���㼫����СҪ������
    m=floor(n/i);%������Ŀ
%     while m>1%������Ŀ��Ҫ����1��ǰ�涨���ˣ��϶�����1 
    x_=x(1:m*i);%ȡ��Ϊx_
    x_1=reshape(x_,i,m);%������
      for j=1:m%ÿ�������ڼ���
    mu(j)=mean(x_1(:,j));%�����ֵ����
    s(j)=std(x_1(:,j));%�����׼��
        for j1=1:length(x_1(:,j))
            b(j1,j)=sum(x_1(1:j1,j)-mu(j));%�����ۻ����
        end
    b1(j)=max(b(:,j))-min(b(:,j));%���伫��
      end
    RS(i-1)=mean(b1./s);%����RS
%     clear mu s b b1
end
%% ��С���ˣ�����Hrustָ��
%log(RS)~log([2:n_max])
t=log([2:n_max]);%���䳤�ȶ���������
H_=polyfit(t,log(RS),1);%��ϳ�ϵ��
H=H_(1);%б�ʼ�ΪHָ��
end
end
    
   

    
    
    
    
    
    
    

