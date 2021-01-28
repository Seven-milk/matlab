%计算有效干旱指数EDI
function [date_365,date_APD,EDI,EP_DS,PRN,APD,CNS,ANES,DR]=EDI_ORIGINAL(date,x)
%% 参数说明
%date           对应于x的日期，年月日的date序列；
%x              日降水序列，列向量,需要至少大于30年，30*365=10950个，
                %最好是长度修正后的，即开始为某年1月1日，结束为某年12月最后1日；
%EP_365         基于365周期的有效降水量；经过DS修正变成EP_DS(均去了头和尾)
%date_365       对应于EP_365的时间向量，是去了头（364）和尾（非整数年的尾值）的
%EP_DR/EP_DS    DR期内的EP值，代回EP_365中得到EP_DS
%MEP            每日EP多年均值；
%DEP=PRN./权值  EP与多年差值；=PRN，但PRN是用降水表示，所以是DEP还原权重后的值；再者要进行DS修正
%SEP=EDI        标准化DEP指数，表征干燥程度；=EDI,但需要进行DS修正；
%CNS            基于SEP持续历时；
%ANES           基于SEP持续烈度；
%DR             基于SEP的干燥期；
%DS             基于干燥期DR重新计算每场干燥期对应的计算期DS，将计算期从365变为365+DR=DS
%AVG            多年平均日降水
%APD            累积降水亏缺（365为计算周期），但经过DS修正了
%% 其他说明
%计算EDI，去头（前365计算不了），去尾（修正到整数年）
%% 时间赋权，基于赋权函数和x计算有效降水量EP_365及其统计参数,以365为假定DS计算周期
[EP_365,date_365]=time_weight(date,x);
n=floor(length(EP_365)/365);%年数
EP_365(n*365+1:end)=[];%去尾
date_365(n*365+1:end)=[];%去尾
EP_365=reshape(EP_365,n,365);%对EP_365进行reshape,构造成30年*365日的矩阵
MEP=mean(EP_365);
DEP=EP_365-MEP;
SEP=DEP./std(EP_365);
SEP=reshape(SEP,365*n,1);
DEP=reshape(DEP,365*n,1);
EP_365=reshape(EP_365,n*365,1);
%对应时间均为date_365
%% 计算累积降水亏缺,以365为计算周期，1月1日的累积降水亏缺表示一年前总共的降水亏缺到今天（未加权）
[APD,DEP_APD,date_APD]=APD_365(date,x);
%APD对应时间均为date_365,DEP_APD对应时间date
%% 基于SEP进一步确定DS，游程理论，阈值为0,识别的个数为干燥期场次,
%  基于每场干燥期DR(i)，得到每场干燥期的新DS(i)=DR(i)-364
[CNS,ANES,flag_start,flag_end]=run_theory(SEP,0);
DR=[date_365(flag_start),date_365(flag_end)];%干燥期
[m,~]=size(DR);
for i1=1:m
    DS(i1,2)=DR(i1,2);
    DS(i1,1)=date(find(date==DR(i1,1))-364);
end
%% DS修正：重新计算每场的DS内的APD,AVG,PRN,EDI
%预定义EDI,PRN,EP_DS,再进行DS修正
a=0;
for i_a=1:365
    a=1/i_a+a;%计算还原权重
end
PRN=DEP./a;%还原，得到PRN初始
EP_DS=EP_365;
%进行DS修正
for i2=1:m    
    start_1=find(date_365==DR(i2,1));%对应date_365
    end_1=find(date_365==DR(i2,2));
    start_2=find(date==DR(i2,1));%对应date
    end_2=find(date==DR(i2,2));
    %对DS=DR+365期内的降水亏缺进行累加，而不是单单基于365周期
    for i3=1:(end_1-start_1+1)
    APD_(i3)=sum(DEP_APD(start_2-364:start_2+i3-1));
    end
    APD(start_1:end_1)=APD_';
    clear APD_
    %重新计算DR期内的EP
        %DR时间对应date_365和date
%     start_1=find(date_365==DR(i2,1));%对应EP_365
%     end_1=find(date_365==DR(i2,2));
%     start_2=find(date==DR(i2,1));%对应x
%     end_2=find(date==DR(i2,2));
        %重新计算DR内的EP_DR，代回EP中构造EP_DS
    for i5=1:(end_1-start_1+1)
        s=0;
        ckmn=0;
        for i6=1:365+i5-1
            s=s+mean(x(start_2+i5-i6:start_2+i5-1));
            ckmn=1/i6+ckmn;%1/n的求和
        end
        EP_DR(i5)=s;
        b=mod(start_1+i5-1,365);
        if b==0
            b=365;
        end
        DEP_DR(i5)=EP_DR(i5)-MEP(b);
        PRN_DR(i5)=DEP_DR(i5)./ckmn;
    end
    EP_DS(start_1:end_1)=EP_DR';
    PRN(start_1:end_1)=PRN_DR';
    clear EP_DR PRN_DR DEP_DR
end
PRN=reshape(PRN,n,365);
EDI=PRN./std(PRN);
PRN=reshape(PRN,n*365,1);
EDI=reshape(EDI,n*365,1);
%% 时间赋权函数，计算365的赋权求和EP值
function [EP_365_,date_365]=time_weight(date,x)
%计算EP_365，基于（2）式，前m天的降水量以m天平均降水量的形式加入总水资源
EP_365_=zeros(length(x)-365+1,365);%从第365天开始进行累积，所以length(x)-364;365列是为了配合下面实现公式（2）
[p,~]=size(EP_365_);
date_365=date(365:end);
for i=1:p
    for j=1:365
    EP_365_(i,j)=mean(x(i+j-1:365+i-1));
    end
end
EP_365_=sum(EP_365_')';
end
%% 计算365的累积降水亏缺APD
function [APD,DEP_APD,date_APD]=APD_365(date,x)
date_APD=date(365:end);
%计算均值
n1=floor(length(x)/365);
x1=x;
x1(n1*365+1:end)=[];
x1=reshape(x1,n1,365);
MEP_x1=mean(x1);
%计算差异DEP_x1
for i=1:length(x)
    b1=mod(i,365);
    if b1==0
        b1=365;
    end
    DEP_x1(i)=x(i)-MEP_x1(b1);
end
%计算APD
for i=1:length(x)-364
    APD(i)=sum(DEP_x1(i:365+i-1));
end
APD=APD';
DEP_APD=DEP_x1';
end
%% 绘图
figure
subplot(2,1,1);
bar(date,x);
hold on 
plot(date_APD,APD);
plot(date_365,EP_DS);
hold off
set(gca,'XLim',[date(1),date(end)]);
ylabel('降水/mm');
subplot(2,1,2);

hold on 
plot(date_365,EDI*100);
plot(date_365,PRN);
xlabel('日期');
ylabel('指数');
set(gca,'XLim',[date(1),date(end)]);
legend('EDI*100','PRN');%,'APD'
hold off
end