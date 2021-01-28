%固定情景单变量动态重现期计算,滑动窗口
function [cxq_D,cxq_S,flag]=sliding_window_1(date,h,x,H0,D_,S_)
%输入日期date（可以是序号）+窗口h
%输入x为MSDI指数,H0为阈值D_为固定情景
%输出对应固定情景的滑动序列,对应的时间flag
%注意时间对应关系，x若为月，则h也应转化为月
%定义flag,对应输出序列的窗口开始时间，结束时间和中间代表时间
flag_start=(1:1:length(x)-h+1);%以序号形式存在，方便计算
flag_end=(h:1:length(x));
flag=date(ceil(h/2):1:ceil(h/2)+length(flag_start)-1);%以中间位为代表时间
%输出y，定义y计算方法，以固定情景重现期为例,x(1)是历时,(flag_start(i):flag_end(i))为一个窗口
cxq_D=zeros(length(flag_start),1);
cxq_S=zeros(length(flag_start),1);
for i=1:length(flag_start)
    x_=x(flag_start(i):flag_end(i));%窗口内序列
    [D,S]=run_theory(x_,H0);%窗口内干旱识别
    T=length(x_)/12/length(S);%窗口内平均T
    cxq_D(i)=return_period_1(D,T,D_);%固定情景重现期
    cxq_S(i)=return_period_1(S,T,S_);
    clear D;
    clear S;
end
end
