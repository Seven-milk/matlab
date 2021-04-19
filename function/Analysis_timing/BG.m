%启发式分割，寻变异点
function [FLAG,AllT_,AllTmax,AllPTmax,x_avg]=BG(date,X,P0,L0)
%自己编的程序
%% 输入参数列表
% date         x对应的时间序列，用于画图，取消画图功能就不需要这个了
% X            待分析的序列，列存储
% p0           显著性水平门限值，ptmax低于此值的不再分割.一般取0.95
% L0           最小分割尺度，子段长度小于此值的不再分割，一般取25
%% 输出参数列表
% FLAG         分割点标记，列向量存储，长度与X相同
% AllT         与分割点对应的全部t检验序列，其首位数字为起点坐标
% AllTmax      与分割点对应的全部t检验序列的最大值
% AllPTmax     与分割点对应的全部t检验序列对应的统计显著性
% x_avg        将X按分割点进行分割的段及各段对应的均值
% AllT_        按分段顺序分割的对应的T值，其中计算每次去掉头尾两个点
% flag1/2      1为按时间顺序存放的分割点，2为按分段顺序存放的分割点  
% date_AllT    为AllT对应的起始点和终止点
%% 定义子函数，找分割点，判断显著性
function [T,Tmax,p,PTmax]=partition(x)
%% 参数列表
% x         待分割的序列，列存储
% T         T序列
% Tmax      最大T值
% p         最大T值对应序号
% PTmax     最大T值对应的p_value,PTmax<P0时，说明变异不显著，终止分割
%% 参数预设
n=length(x);%序列长度
N1=(2:1:n-1)';%左侧序列长度序列，对应第i个点的
N2=(n-1:-1:2)';%右侧序列长度序列，对应第i个点的
mu1=zeros(n-2,1);%左侧均值序列
mu2=zeros(n-2,1);%右侧均值序列
sd1=zeros(n-2,1);%左侧标准差序列
sd2=zeros(n-2,1);%右侧标准差序列
% SD=zeros(n-1,1);%合并偏差序列
% T=zeros(n-2,1);%统计量T序列
%% 循环计算统计量T序列,先计算均值序列和标准差序列(这样用矩阵算速度快)
for i=2:n-1
    mu1(i-1)=mean(x(1:i));
    mu2(i-1)=mean(x(i:end));
    sd1(i-1)=std(x(1:i));
    sd2(i-1)=std(x(i:end));
end
SD=sqrt(((N1-1).*(sd1.^2)+(N2-1).*(sd2.^2))./(N1+N2-2)).*sqrt(1./N1+1./N2);
T=abs((mu1-mu2)./SD);
Tmax=max(T);%最大值T
p=find(T==Tmax)+1;%最大T对应的在x中的位置，所以加1（因为p在T中去头去尾）
%% 显著性水平判断，计算最大T值对应的p值
v=n-2;%参数
Eta=4.19*log(n)-11.54;
Delta=0.40;
c=v/(v+Tmax^2);%不完全Beta函数的下标
PTmax=(1-betainc(c,Delta*v,Delta))^Eta;%调用不完全beta函数,得到对应最大T值的p_value
end
%% 循环执行子函数，直到两个阈值
%% 参数预设
n=length(X);%序列总长
FLAG=zeros(n,1);%分割点序列,与x等长
FLAG(1)=1;%因为第一个点和最后一个点不参与运算，而FLAG又与x等长，所以给第一个和最后一个赋值
FLAG(n)=1;%
AllT=cell(0,0);%定义空cell，用于存储与分割点对应的全部T序列
AllTmax=cell(0,0);%定义空cell，用于存储与分割点对应的T极值
AllPTmax=cell(0,0);%定义空cell，用于存储与分割点对应的p值（同时与T极值对应）
x=cell(0,0);%用以存储分段数据
%% 第一个点分割
x(1)={X};
[T,Tmax,p,PTmax]=partition(x{1});
    if PTmax>=P0 
    FLAG(find(X==x{1}(p(1))))=1;
    AllT=[AllT;T];
    AllTmax=[AllTmax;Tmax];
    AllPTmax=[AllPTmax;PTmax];
    else 
        disp('无变异点');
    end
i1=1;
date_AllT_start(1)=2;
date_AllT_end(1)=length(X)-1;
i19=2;
%% 继续分割,思路是将x其变成依次往下增的矩阵，（通过储存割点）储存每次割后的序列1——2——4...（没通过阈值就不储存割点）
while 1
flag1=find(FLAG>0);
j1=1;
for i2=1:length(flag1)-1
    x(i1+1,j1)={X(flag1(i2):flag1(i2+1))};
    j1=j1+1;
    date_AllT_start(i19)=flag1(i2);
    date_AllT_end(i19)=flag1(i2+1);
    i19=i19+1;
end
FLAG1=FLAG;
for i3=1:length(x(i1+1,:))
    if length(x{i1+1,i3})>=L0
    [T,Tmax,p,PTmax]=partition(x{i1+1,i3});
    AllT=[AllT;T];
        if PTmax>=P0
    FLAG(find(X==x{i1+1,i3}(p(1))))=1;
    AllTmax=[AllTmax;Tmax];
    AllPTmax=[AllPTmax;PTmax];
        end
    end
end
i1=i1+1;
if sum(FLAG1~=FLAG)==0%当FLAG不再变化，说明割点不变了，割完了，退出循环
    break
end
% if sum(length(x{i1+1,:})>=L0)==0
%     return
% end
end
FLAG(1)=[];
FLAG(end)=[];
FLAG=date(find(FLAG~=0));
FLAG1=datenum(FLAG);
%% 绘图
figure
hold on
date1=datenum(date);
plot(date1,X);
% b=(min(X):0.1:max(X));
% b=(-10:0.1:10);
% a=zeros(length(b));
for i4=1:length(FLAG1)
    a=FLAG1(i4);
plot([a a],get(gca,'YLim'),'r-');
end
axis([min(date1),max(date1),min(X),max(X)]);
datetick('x','yyyy','keeplimits');%返回日期（年，月）显示
xlabel('年份');
ylabel('序列值');
title('启发式分割法变异诊断');
%% 绘图准备,x_avg分段
x_avg=zeros(length(X),length(x(end,:))*2);
i6=1;%控制列
%i7=1;%控制行的起点，length(x{end,i5})+i7-1为行的终点
for i5=1:length(x(end,:))%最后分割结果为x(end,:)但其中各段开始点和结束点有重合
    avg1(i5)=mean(x{end,i5});
    x_avg(flag1(i5):flag1(i5+1),i6)=x{end,i5};%flag1按时间先后顺序排序。方便对x进行分割
    x_avg(flag1(i5):flag1(i5+1),i6+1)=avg1(i5);
    i6=i6+2;
end
%% 绘图准备，ALLT_绘制,需要找出ALLT对应的时间
%% 对flag1进行更改，变成按分割先后顺序排列flag2
%x长度矩阵
x_length=zeros(size(x));%x个单元长度矩阵
for i11=1:numel(x)
    x_length(i11)=length(x{i11});
end
[a,e]=size(x);
for i12=1:a
    for i13=2:e
        x_length(i12,i13)=sum(x_length(i12,i13-1:i13))-1;
    end
end
for i14=1:numel(x)
    if isempty(x{i14})==1
        x_length(i14)=0;
    end
end
%计算flag2
flag2=zeros(length(flag1)-1,1);
flag2(1)=length(X);
i15=2;
for i16=2:a
      b=cellfun('isempty',x(i16,:));
      d=e-sum(b);%找每行x中的非空矩阵数目，以做索引
    for i17=1:d
        g=x_length(a,find(x_length(a,:)==x_length(i16,i17)));
    if isempty(g)==0&&sum((g~=flag2(:))==1)==(length(flag1)-1)
        flag2(i15)=x_length(i16,i17);
        i15=i15+1;
    end
    end
% i15=1;
% for i9=2:a
%     b=cellfun('isempty',x(i9,:));
%     d=e-sum(b);%找每行x中的非空矩阵数目，以做索引
%     for i10=1:d
%         flag2(i15)=
%         i15=i15+1;
%         if mod(i10,2)==0
%             continue
%         end
%         flag2(i15)=x_length(i9,i10);
%         i15=i15+1;
%     end
end
flag2(1)=[];%得到按顺序排序的切割点flag2
%% 对AllT构建矩阵，以放入oringal中，AllT是按切割顺序排序，与flag2对应
date_AllT_start=date_AllT_start';
date_AllT_end=date_AllT_end';
date_AllT=[date_AllT_start,date_AllT_end];
i22=1;
delate_point=[];
for i20=2:length(AllT)
    for i21=1:i20-1
        if date_AllT(i20,1)==date_AllT(i21,1)&&date_AllT(i20,2)==date_AllT(i21,2)
               delate_point(i22)=i20;
               i22=i22+1;
        end
    end
end
date_AllT(delate_point(:),:)=[];
AllT(delate_point(:),:)=[];
for i23=2:length(AllT)
    date_AllT(i23,1)=date_AllT(i23,1)+1;
    date_AllT(i23,2)=date_AllT(i23,2)-1;
end
%x有几行，就说明分了几次，每分一次，有一个断点和一段T序列与之对应，x-ALLT-ALLTMAX-ALLPTMAX-FLAG-flag1对应
AllT_=zeros(length(X),length(AllT));
for i22=1:length(AllT)
    AllT_(date_AllT(i22,1):date_AllT(i22,2),i22)=AllT{i22};
end
% AllT_(2:end-1,1)=AllT{1};
% i17=2;
% for i16=1:length(AllT)-1
%     AllT_(,i17)=AllT{i17};
% end
% for i8=1:length(AllT)
%     AllT_(,i8)=AllT{i8};
% end
end

    
    






