%计算有效干旱指数EDI
function [date_EP,EDI,EP,MEP,DEP,SEP,PRN,CNS,ANES,DS,date_p_sum,p_sum,AVG,APD]=EDI_ORIGINAL(date,x)
%% 参数说明
%date               对应于x的日期，年月日的date序列；
%x                  日降水序列，列向量,需要至少大于30年，30*365=10950个，
                    %最好是长度修正后的，即开始为某年1月1日，结束为某年12月最后1日；
                
%EP_365             基于365周期的有效降水量；去了头尾
%date_365           对应于EP_365，DEP_365,SEP_365,PRN_365,EDI_365,APD_365,p_sum_365的时间向量，是去了头（364）和尾（非整数年的尾值）的
%MEP_365            每日EP多年均值；
%DEP_365            EP与多年差值；
%SEP_365            标准化DEP指数，表征干燥程度；
%PRN_365            DEP_365/wight_365得到的恢复正常需水量
%EDI_365            EDI指数，为DEP_365或PRN_365标准化值
%CNS                基于SEP持续历时；
%ANES               基于SEP持续烈度；
%DR                 基于SEP的每个点的干燥期；（0~CNS-1）
%DS                 基于DR重新计算的每点干燥期对应的修正计算期DS，将计算期从365变为365+DR=DS
%AVG_365            多年平均日降水
%APD_365            累积降水亏缺（365为计算周期）,date_APD_365为对应时间
%p_sum_365          累积降水，对应时间为date_p_sum_365
%上述指标无365       为经过DS修正的参数值,对应日期为date_EP
%% 其他说明
%计算EDI，去头（前364计算不了），去尾（修正到整数年）
%% 时间赋权，基于赋权函数和x计算有效降水量EP_365及其统计参数,以365为假定DS计算周期
[EP_365,date_365]=time_weight(date,x);%已经去掉了开头的365个值（因为要累积）
n=floor(length(EP_365)/365);%年数
EP_365(n*365+1:end)=[];%去尾
date_365(n*365+1:end)=[];%时间去尾
EP_365=reshape(EP_365,365,n);EP_365=EP_365';%对EP_365进行reshape,构造成n年*365日的矩阵(reshape是以列为单位储存，注意)
MEP_365=mean(EP_365);
%对MEP进行五日的滑动平均
for i_MEP=1:361
MEP_365(i_MEP+2)=mean(MEP_365(i_MEP:i_MEP+4));
end
%
DEP_365=EP_365-MEP_365;
SEP_365=DEP_365./std(EP_365);
SEP_365=SEP_365';SEP_365=reshape(SEP_365,365*n,1);%重新变为列向量n*365
DEP_365=DEP_365';DEP_365=reshape(DEP_365,365*n,1);%重新变为列向量n*365
EP_365=EP_365';EP_365=reshape(EP_365,365*n,1);%重新变为列向量n*365   
%对应时间均为date_365
%% 计算累积降水p_sum，累积降水亏缺APD,多年平均AVG,以365为计算周期，1月1日的累积降水亏缺表示一年前总共的降水亏缺到今天（未加权）
[APD_365,AVG_365,date_APD_365,p_sum_365,date_p_sum_365]=APD_AVG(date,x);
APD_365=APD_365';APD_365=reshape(APD_365,365*n,1);
%对应时间分别为date_APD,date_p_sum
%% 计算PRN，基于DEP和时间赋权公式
%计算权值，每个点的权值=sum_i(1/n)(i=1:DS)
wight_365=zeros(length(x)-365+1,1);
wight_365(n*365+1:end)=[];%去尾，为了与DEP对应，才能相除
s_wight=0;
for i9=1:365
    s_wight=s_wight+1/i9;
end
wight_365(:)=s_wight;
%PRN=DEP/wight
PRN_365=DEP_365./wight_365;
%% EDI计算，是PRN或者DEP的标准化
%PRN_,DEP_是其转成矩阵形状n*365
DEP_=reshape(DEP_365,365,n)';
%PRN_=reshape(PRN,365,n)';
EDI_365=DEP_./std(DEP_);
EDI_365=EDI_365';EDI_365=reshape(EDI_365,365*n,1);
%EDI_PRN=PRN_./std(PRN_);%是否值都一样？yes,所以删一个
%% 基于SEP进一步确定DS，游程理论，阈值为0,识别的个数为干燥期CNS场次
[CNS,ANES,flag_start,flag_end]=run_theory(SEP_365,0);%干燥期长度CNS（历时）,flag_start和flag_end和SEP时间对应（序号）
m=length(CNS);%干燥期数目
%（对应开始/结束序号为flag，这个序号对应于SEP,即对应于date_365）
% 对应累积烈度ANES

%  计算DR,DS，DS(i)=DR(i)-364
DS=zeros(length(x)-365+1,1);%去头后，所有点均有DS（计算周期），默认为365
DS(:)=365;
date_DR=[date_365(flag_start),date_365(flag_end)];%对应于日期的DR
DR=zeros(length(x)-365+1,1);%length(x)-365+1个点，干燥期外DS=365，共有m场干燥期，干燥期内DS=365+DS（i）（DS=0:CNS-1）（1：CNS就要减1）
for i8=1:m%每个干燥期内计算
    DR(flag_start(i8):flag_end(i8))=(0:CNS(i8)-1);%flag和DS是对应的吗？yes，DS是去头的，flag和SEP一致，也是去头的，对应
end
DS=DS+DR;
%% DS修正：基于修正后DS重新计算EP,MEP,DEP,SEP,APD,AVG,p_sum，PRN,EDI，将其从DS=365——>DS=365+DR能更好地监测更长期干旱（时间尺度特性）
%EP计算,MEP,DEP,SEP
[EP,date_EP]=time_weight(date,x,DS);
EP(n*365+1:end)=[];%去尾
date_EP(n*365+1:end)=[];%时间去尾
EP=reshape(EP,365,n);EP=EP';%对EP_365进行reshape,构造成n年*365日的矩阵(reshape是以列为单位储存，注意)
MEP=mean(EP);
%对MEP进行五日的滑动平均
for i_MEP=1:361%必须是361
MEP(i_MEP+2)=mean(MEP(i_MEP:i_MEP+4));
end
%
DEP=EP-MEP;
SEP=DEP./std(EP);
SEP=SEP';SEP=reshape(SEP,365*n,1);%重新变为列向量n*365
DEP=DEP';DEP=reshape(DEP,365*n,1);%重新变为列向量n*365
EP=EP';EP=reshape(EP,365*n,1);%重新变为列向量n*365   

%APD,AVG,p_sum计算
[APD,AVG,date_APD,p_sum,date_p_sum]=APD_AVG(date,x,DS);
APD=APD';APD=reshape(APD,365*n,1);

%PRN,EDI
%计算权值，每个点的权值=sum_i(1/n)(i=1:DS)
wight=zeros(length(x)-365+1,1);
for i10=1:length(x)-365+1
    s_wight=0;
    for j10=1:DS(i10)
        s_wight=s_wight+1/j10;
    end
    wight(i10)=s_wight;
end
wight(n*365+1:end)=[];%去尾，为了与DEP对应，才能相除
%PRN=DEP/wight
PRN=DEP./wight;
%EDI
%PRN_,DEP_是其转成矩阵形状n*365
DEP_=reshape(DEP,365,n)';
%PRN_=reshape(PRN,365,n)';
EDI=DEP_./std(DEP_);
EDI=EDI';EDI=reshape(EDI,365*n,1);

%% 时间赋权函数，计算365、修正DS的赋权求和EP值
function [EP,date_EP]=time_weight(date,x,varargin)
%计算EP，基于（某）式，以（2）为例，前m天的降水量以m天平均降水量的形式加入总水资源
date_EP=date(365:end);
%定义DS,DS应该是每个点的计算周期，长度为length(x)-365+1
if nargin==2%不管DS是多少，需要计算的点的数目不变length(x)-365+1个点，只是其求和的子项变多了
    DS_1=zeros(length(x)-365+1,1);%定义每个点(共length(x)-365+1个点，前面的365个点肯定不计算)的计算周期
    DS_1(:)=365;%若没给，则应该是计算固定周期的EP_365，每个点的DS=365
else
    DS_1=varargin{1};
end
%定义自定义的时间赋权函数进行求和
for i=1:length(x)-365+1%从第365天开始进行累积，求length(x)-365+1个点的值
    s_=0;
    for j=1:DS_1(i)%每个点的求和长度，即子项数目
        s_=s_+mean(x(i-j+1+365-1:i+365-1));
    end
    EP(i)=s_;
end
EP=EP';
end


%% 基于累积P（累积周期为DS），计算365的累积降水亏缺APD,多年平均日降水AVG,p_sum为基于DS的累积降水
function [APD,AVG,date_APD,p_sum,date_p_sum]=APD_AVG(date,x,varargin)
%计算累积降水亏缺APD,多年平均日降水AVG
date_p_sum=date(365:end);
date_APD=date(365:end);
%定义DS,DS应该是每个点的计算周期，长度为length(x)-365+1
if nargin==2
    DS_1=zeros(length(x)-365+1,1);%同上
    DS_1(:)=365;
else
    DS_1=varargin{1};
end
%
%基于DS和x计算累积降水p_sum，去头，未去尾
p_sum=zeros(length(x)-365+1,1);
for i7=1:length(x)-365+1%从第365天开始进行累积，求length(x)-365+1个点的值
    p_sum(i7)=sum(x(i7+365-1-DS_1(i7)+1:i7+365-1));
end
%计算AVG和APD，去尾
n1=floor(length(p_sum)/365);%去尾，标准为n*365
p_sum_1=p_sum;
p_sum_1(n1*365+1:end)=[];
date_APD(n1*365+1:end)=[];
p_sum_1=reshape(p_sum_1,365,n1);
p_sum_1=p_sum_1';
%AVG
AVG=mean(p_sum_1);
%APD
APD=p_sum_1-AVG;
end
%% 绘图
figure
subplot(3,1,1);
bar(date,x);
legend('降水');
xlabel('日期');
ylabel('降水/mm');
set(gca,'XLim',[date(1),date(end)]);

subplot(3,1,2);
hold on 
plot(date_EP,EP,'--');
plot(date_EP,SEP*100,'-.');
plot(date_EP,zeros(length(EP),1));%0线画出
plot(date_EP,repmat(MEP,1,n),'-');%MEP重复绘制
hold off
xlabel('日期');ylabel('指数');
legend('EP','SEP*100','0','MEP')
set(gca,'XLim',[date(1),date(end)]);

subplot(3,1,3);
hold on 
plot(date_EP,EDI*100,'-');
plot(date_EP,APD,'--');
plot(date_EP,PRN*10,'-.');
%ANES构建绘图
ANES_=zeros(length(x)+365-1,1);
for i11=1:length(ANES)
    for j11=1:CNS(i11)
    ANES_(flag_start(i11)+j11-1)=sum(SEP_365(flag_start(i11):flag_start(i11)+j11-1));%需要基于sep_365构建
    end
end
ANES_(n*365+1:end)=[];
plot(date_EP,ANES_,':');
xlabel('日期');ylabel('指数');
hold off
legend('EDI*100','APD','PRN*10','ANES');
set(gca,'XLim',[date(1),date(end)]);
% subplot(5,4,1);
% plot(date_EP,repmat(MEP,1,n),'-');%MEP重复绘制
% plot(date_EP,EP,'--');
% plot(date_EP,zeros(length(EP),1));%0线画出
% plot(date_EP,SEP*100,'-.');


% hold on 
% plot(date_EP,EDI*100);
% plot(date_EP,PRN);
% xlabel('日期');
% ylabel('指数');
% set(gca,'XLim',[date(1),date(end)]);
% legend('EDI*100','PRN');%,'APD'
% hold off
end