function  [X]=chidu_(x,q)
%�߶ȼ��㣬����һ���³߶ȵ�����ֵx��������߶Ⱦ���X��[�߶�1���� �߶�2���� �߶�3���� �߶�4����]
%% ����˵��
% x һ���³߶�����
% q ��Ҫ����ĳ߶�
% X ���߶���������
%% ��������
n=length(x);
X=zeros(n,q);
for i=1:q
%     x_=zeros(n-i+1,1);
%     for j=1:length(x_)
%     x_(j)=sum(x(j:j+i-1));
    for j=1:(n-i+1)
    X(j+i-1,i)=sum(x(j:j+i-1));
    end
%     X(:,i)=x_;
end
end