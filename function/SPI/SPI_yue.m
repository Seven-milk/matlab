function [SPI]=SPI_yue(x)
%��������ϵ�SPI
%��Ҫ�ȶԽ�ˮ���г߶ȼ��㣬��ɸ��߶Ⱦ���
%����ȫ���У���Ϊ��λ������ȫ���󣨸��߶ȣ�x
[~,q]=size(x);
Hx=zeros(size(x));
for i=1:q%q�У�����q���߶ȵ�ȫ����
    x_q=x(:,i);
    Hx_q=Hx(:,i);
   for i1=1:12%��ȡ1-12������
           num=(i1:12:length(x_q));
           x_q_month=x_q(num);
           Hx_q_month=gamcdf_modi(x_q_month);%ÿ����������ϳ��ۻ�����
           for i2=1:length(num)
           Hx_q(num(i2))=Hx_q_month(i2);%�Żؾ�����
           end
   end%���Hx_qΪȫ���е��ۻ�����  
   Hx(:,i)=Hx_q;
end%���HxΪ���߶�ȫ���е��ۻ�����
%����SPI
SPI=norminv(Hx,0,1);
end

