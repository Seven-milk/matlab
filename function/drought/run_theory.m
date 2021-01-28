%run_theory，游程理论
function [D,S,flag_start,flag_end]=run_theory(x,H0)
%% 参数输入
%x     指标序列
%H0    阈值
%% 参数输出
%D,S                     历时烈度，烈度单位为1*时间单位（月，日），历时单位=指数的单位
%flag_start,flag_end     开始结束时间，结束时间，对应于序列的序号
%% 识别
date=(1:1:length(x));%不用时间，用序号
%寻找干旱开始和结束的时间
flag_start=[];
i1=1;
flag_end=[];
i2=1;
if x(1)<=H0
    flag_start(i1)=date(1);%判断第一个是否是开始
    i1=i1+1;
    if x(2)>H0%当第一个为开始时，要判断第一个是否是结束
        flag_end(i2)=date(1);
        i2=i2+1;
    end
end
for i=2:length(x)-1
    if x(i)<=H0&&x(i-1)>H0%判断开始条件，此时刻小于H0，上时刻大于H0
        flag_start(i1)=date(i);
        i1=i1+1;
    end
    if x(i)<=H0&&x(i+1)>H0%判断结束条件，此时刻小于H0，下时刻大于H0
        flag_end(i2)=date(i);
        i2=i2+1;
    end
end
if x(end)<=H0
    flag_end(i2)=date(end);%判断最后一个是否为结束
    if x(end-1)>H0%当最后一个是结束时，判断最后一个是否为开始
        flag_start(i1)=date(end);
    end
end
%flag_start和flag_end要同维，有开始必须有结束
%计算历时
D=[];
D=flag_end-flag_start+1;
%计算烈度
S=[];
x_=abs(x-H0);%烈度是正值，且减去H0的那一部分
for i=1:length(flag_start)
    S(i)=sum(x_(flag_start(i):flag_end(i)));
end
D=D';
S=S';
flag_start=flag_start';
flag_end=flag_end';
end