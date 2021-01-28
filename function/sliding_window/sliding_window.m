%固定情景动态重现期计算,滑动窗口
function [tx_,lh_,flag]=sliding_window(date,h,h0,x,H0,D_,S_)
%% 参数说明
%输入日期date（可以是序号）+窗口h+每次滑动大小h0
%输入x为MSDI指数,H0为阈值D_S_为固定情景，因为滑动肯定是一个窗口内有个东西反映窗口整体状态，即固定情景重现期
%输出对应固定情景的滑动序列,对应的时间flag
%注意时间对应关系，x若为月，则h也应转化为月
%% 
%定义flag,对应输出序列的窗口开始时间，结束时间和中间代表时间
flag_start=(1:h0:length(x)-h+1);%以序号形式存在，方便计算
flag_end=(h:h0:length(x));
flag=date(ceil(h/2):h0:length(x)-ceil(h/2)+1);%以中间位为代表时间,当h是奇数，取中间位，当h为偶数，取中间两个的靠左一位，且h0为奇数，此时会多一个flag，把最后一个删掉
% flag=date(ceil(h/2):1:ceil(h/2)+length(flag_start)-1);%以中间位为代表时间
%% 
%输出y，定义y计算方法，以固定情景重现期为例,x(1)是历时，x(2)是烈度,(flag_start(i):flag_end(i))为一个窗口
tx_=zeros(length(flag_start),1);
lh_=zeros(length(flag_start),1);
for i=1:length(flag_start)
    x_=x(flag_start(i):flag_end(i));%窗口内序列
    [D,S]=run_theory(x_,H0);%窗口内干旱识别
    T=length(x_)/12/length(S);%窗口内平均T,输入月值，T计算是多少年一次，因此是除12
    [tx_(i),lh_(i)]=return_period(D,S,T,D_,S_);%固定情景重现期
    clear D;
    clear S;
end
end
