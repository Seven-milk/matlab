function [f,a1,b1,r1,yue,e]=day_to_month(d,a,b,r)
%�����ݴ���Ϊ������,һ���������Ϊ�£�Ҳ�����վ�ֵΪ�£��޸�27�м���
%input:d,a,b,r,�ֱ��������б���ֵ��������У��·����У��շ�����
%output:f,a1,b1,r1���ֱ��������б���ֵ�������ж�Ӧ��������У��·����У��շ�����
%yue ����������e�������о�����d��������Ϊ��31*��ݵľ���
%����������,���yueΪ������
% yue=1;
% for i=1:(length(b)-1)
%     if b(i)~=b(i+1)
%          yue=yue+1; 
%     end
% end
% %eΪ�·����ݾ���fΪ�¾�ֵ����
% e=zeros(31,yue);
% f=zeros(yue,1);
% a1=zeros(yue,1);
% b1=zeros(yue,1);
% r1=zeros(yue,1);
% j=1;
% k=0;
% for i=1:(length(b)-1)
%     if b(i)==b(i+1)
%         k=k+1;       
%         e(k,j)=d(i);
%         a1(j)=a(i);
%         b1(j)=b(i);
%         r1(j)=r(i+1);
%     else 
%         e(k+1,j)=d(i);
%         f(j)=sum(e(1:k+1,j));%�¾�ֵ�������
%         j=j+1;
%         k=0;
%     end
% end
yue=1;
for i=1:(length(b)-1)
    if b(i)~=b(i+1)
         yue=yue+1; 
    end
end
%eΪ�·����ݾ���fΪ�¾�ֵ����;���
e=zeros(31,yue);
f=zeros(yue,1);
j=1;
% k=1;
e(1,1)=d(1);
for i=2:length(b) 
    if a(i)~=a(i-1)
        j=j+1;
    end
    e(r(i),b(i)+(j-1)*12)=d(i);
end
for i=1:yue
    f(i)=sum(e(:,i));%��ͻ����ֵ
end
%�����Ӧ�����е������վ���
a1=zeros(yue,1);
b1=zeros(yue,1);
r1=zeros(yue,1);
j=1;
for i=1:length(b)-1
    if b(i)~=b(i+1)
        a1(j)=a(i);
        b1(j)=b(i);
        r1(j)=r(i);
        j=j+1;
    end
end
a1(end)=a(end);
b1(end)=b(end);
r1(end)=r(end);
end
