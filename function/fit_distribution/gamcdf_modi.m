%����gamcdf������0ֵӰ��
function [Hx,c_1]=gamcdf_modi(x,varargin)
%������̶�����ֵ�ĸ��ʣ�����varargin������x��ϣ����y���ۻ����ʣ�yȡxʱ����������ۻ�����
n=length(x);
m=0;
for i=1:n%����0ֵ������
    if x(i)==0
        m=m+1;
    end
end
    q=m/n;%0ֵ����
    num=find(x==0);%ͳ��0ֵλ��
    x(num)=[];%0ֵȥ��
    c_1=gamfit(x);
    Gx=gamcdf(x,c_1(1),c_1(2));
    Hx=q+(1-q)*Gx;%���������,����0ֵ
    if q~=0   %ֻҪ��0����ڣ���Ҫ��ԭ0ֵ����
    for i=1:length(num)
    Hx=[Hx(1:num(i)-1);q;Hx(num(i):length(Hx))];%��0ֵ���ʲ������
    end
    end
    if nargin==2
        Hx=q+(1-q)*gamcdf(varargin{1},c_1(1),c_1(2));
    end
end