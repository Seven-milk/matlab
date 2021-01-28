%计算逐年历时、烈度的run_theory
function [D,S]=run_theory_year(date,x,H0)
%% 参数输入
% date  指标序列的date
% x     指标序列，要求是完整序列，即年初(首项)~年末（尾项）
% H0    阈值
                                        % unit  指标序列的时间单位,1对应于月尺度，2对应于日尺度（说明，年尺度直接用run_theory即可，其DS=年）
%% 参数输出
% D,S    对应于每年的历时烈度，单位为1*指标尺度（因为基于指标识别的）
%% 预处理
a=year(date);%对应于date的年、月、日序列，为了进行转换
%b=month(date);
%r=day(date);
n=a(end)-a(1)+1;%一共多少年，等于输出的DS序列长
D=zeros(n,1);
S=zeros(n,1);
%% 识别——到年序列DS
j=zeros(1,2);j(1,1)=1;%用于控制每年开头和结束
k=1;%控制DS
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