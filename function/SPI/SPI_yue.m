function [SPI]=SPI_yue(x)
%基于月拟合的SPI
%需要先对降水进行尺度计算，变成各尺度矩阵
%输入全序列（月为单位），或全矩阵（各尺度）x
[~,q]=size(x);
Hx=zeros(size(x));
for i=1:q%q列，即第q个尺度的全序列
    x_q=x(:,i);
    Hx_q=Hx(:,i);
   for i1=1:12%提取1-12月序列
           num=(i1:12:length(x_q));
           x_q_month=x_q(num);
           Hx_q_month=gamcdf_modi(x_q_month);%每个月序列拟合出累积概率
           for i2=1:length(num)
           Hx_q(num(i2))=Hx_q_month(i2);%放回矩阵中
           end
   end%输出Hx_q为全序列的累积概率  
   Hx(:,i)=Hx_q;
end%输出Hx为各尺度全序列的累积概率
%计算SPI
SPI=norminv(Hx,0,1);
end

