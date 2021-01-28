%风险因子计算,滑动窗口
function [R,V,E,flag]=sliding_window_rrv(date,h,h0,x,H0)
%% 参数说明
%输入日期date（可以是序号）+窗口h+每次滑h0（如果按月，可以一次滑一个月，也可以3月3月滑。。），均以月为基础单位
%输入x为指数,H0为阈值
%输出对应固定情景的滑动序列,对应的时间flag
%注意时间对应关系，x若为月，则h也应转化为月
%%
%定义flag,对应输出序列的窗口开始时间，结束时间和中间代表时间
flag_start=(1:h0:length(x)-h+1);%以序号形式存在，方便计算
flag_end=(h:h0:length(x));
% flag=date(ceil(h/2):h0:ceil(h/2)+length(flag_start)-1);%以中间位为代表时间
flag=date(ceil(h/2):h0:length(x)-ceil(h/2)+1);%以中间位为代表时间
%%
%输出y，定义y计算方法，以固定情景重现期为例,x(1)是历时,(flag_start(i):flag_end(i))为一个窗口
% cxq_D=zeros(length(flag_start),1);
% cxq_S=zeros(length(flag_start),1);
R=zeros(length(flag_start),1);
V=zeros(length(flag_start),1);
E=zeros(length(flag_start),1);
for i=1:length(flag_start)
    x_=x(flag_start(i):flag_end(i));%窗口内序列
    [D,S]=run_theory(x_,H0);%窗口内干旱识别
%     cxq_D(i)=return_period_1(D,T,D_);%固定情景重现期
%     cxq_S(i)=return_period_1(S,T,S_);
    R(i)=length(D)/sum(D);%窗口内计算RRV
%     V(i)=sum(S)/length(D);
    V(i)=(sum(S)-H0*sum(D))/length(D);%求和SPI，不是求和烈度，一场干旱i：sum(SPIi)=S(i)-H0*D(i),全部干旱:sum(SPI)=sum(S)-H0*sum(D)
    E(i)=sum(D)/length(x_);
    clear D;
    clear S;
end
end
