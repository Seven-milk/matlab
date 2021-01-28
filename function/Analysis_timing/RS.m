%�����Է�����R/S��
function [H,V,C]=RS(x)
%% ����˵��
% x �����������,����������
% H Hָ��
% V Vͳ����
% C �����߶�
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
H_=polyfit(log(t),log(RS),1);%��ϳ�ϵ��
H=H_(1);%б�ʼ�ΪHָ��
%% ����Vͳ������C
V=RS./sqrt(t);
C=2^(2*H-1)-1;
%% ��ͼ
figure
hold on
h=scatter(log(t),log(RS));
h=[h,scatter(log(t),V)];
h=[h,plot(log(t),H_(1)*log(t)+H_(2),'--')];
h=[h,plot(log(t),V)];
xlabel('LOG(n)');
ylabel('LOG(RS)');
title('RS�����Է���');
legend(h([1,3,4]),'ɢ��ͼ','��С�������','Vͳ����');
hold off
%[t',log(RS)',(H_(1)*t+H_(2))',V']
end
    
   

    
    
    
    
    
    
    

