function [FLAGS]=BGSA(x,y,P0,L0)
%抄的程序
% [ FLAGS ] = BGSA( x,y,P0,L0 )
%  x: 序列的x坐标（仅用于绘图，如果不使用则设置为[]）
%  y: 降雨量序列
%  P0: 显著性水平门限值，低于此值的不再分割
%  L0: 最小分割尺度，子段长度小于此值的不再分割
%  FLAGS: 返回的逻辑向量与y大小相同，值为1表示相应的位置定位分割点
% 通过Bernaola-Galvan分割算法（BGSA）找出并绘制突变点及其最大密度间隔。
%   如何解释这个数字？
%   蓝色细曲线是原始序列; 而粗一个表示每个段中原始序列的间隔平均值t; 红色垂直线表示分割点所在的位置;阴影指示最大突变密度间隔。\
n=length(y);
if isempty(x)
    x=1:n;
end
FLAGS=zeros(1,n);
FLAGS(n)=1;

% 通过标记1在FLAGS中找到分割点的位置。
num_sp = sum(FLAGS);
while 1
    I = find(FLAGS==1);
    numsp_bf = num_sp;
    for k = 1:num_sp
        if k==1
            subx = x(1:I(k));
            suby = y(1:I(k));
        else
            subx = x(I(k-1)+1:I(k));
            suby = y(I(k-1)+1:I(k));
        end
        if length(subx)>L0
            [Xpos,PTmax]=calc_TP(subx,suby);
            if PTmax>=P0
                FLAGS(x==min(Xpos))=1;
                num_sp=num_sp+1;
            end
        end
    end
    if num_sp==numsp_bf
        break
    end
end

% 计算每个分割的平均序列。
for k = 1:num_sp
    if k==1
        my(1:I(k)) = mean(y(1:I(k)));
    else
        my(I(k-1)+1:I(k)) = mean(y(I(k-1)+1:I(k)));
    end
end

% 调整一些不合理的突变点。
FLAGS(n) = 0;
for j = 2:n
    if FLAGS(j)==1 && FLAGS(j-1)==1%连续突变点
        FLAGS(j) = 0;
    end
end

%return
figure

% 计算并找出最大突变密度的间隔。
NDT = L0;
for j = 1:n-NDT
    n = sum(FLAGS(j:j+NDT));
    eta(j) = n/NDT;
end
Ieta = find((eta==max(eta))+(eta~=0)==2);

% 影响间隔
ya = [(max(y)+1)*1.1 (max(y)+1)*1.1];
bv = (min(y)-1)*1.1;
xamin = x(Ieta);
xamax = x(Ieta+NDT);
if ~isempty(Ieta)
xa(1,:) = [xamin(1) xamax(1)];
kk = 1;
for l = 2:length(Ieta)
    if xamax(l-1)>=xamin(l)
        xa(kk,:) = [min(xa(kk,:)) xamax(l)];
    else
        kk = kk+1;
        xa(kk,:) = [xamin(l) xamax(l)];
    end
end
for l = 1:kk
    area(xa(l,:),ya,bv,'LineStyle','none','FaceColor',[.6 .6 .6],'FaceAlpha',.6,'ShowBaseLine','off');
    hold on
end
end

% 在分割点绘制曲线和垂直线。
plot(x,y,'color',[0 .447 .741]);
hold on
plot(x,my,'color',[0 .447 .741],'linewidth',2);
hold on
I = find(FLAGS==1);
for k = 1:sum(FLAGS)
    plot([x(I(k)) x(I(k))],[bv max(ya)],'r-');
    hold on
end
axis([min(x) max(x) (min(y)-1)*1.05 (max(y)+1)*1.05]);
title('Bernaola-Galvan Segmentation Algorithm')
end

function [Xpos,PTmax] = calc_TP(X,Y)
% 子函数计算统计量T，并找出与X系列对应的位置（Xpos）的Tmax，然后计算显着性检验的统计PTmax。
N = length(Y);
T = zeros(1,N);
for i=2:N-1
    nl = length(Y(1:i));
    nr = length(Y(i:N));
    ml = mean(Y(1:i));
    mr = mean(Y(i:N));
    vl = var(Y(1:i));
    vr = var(Y(i:N));
    T(i) = abs((ml-mr)/sqrt(1/nl+1/nr)/sqrt(((nl-1)*vl+(nr-1)*vr)/...
        (nl+nr-2)));
end
Tmax = max(T);
Xpos = X(T==Tmax);
gamma = 4.19*log(N)-11.54;
delta = .4;
v = N-2;
PTmax = (1-betainc(v/(v+Tmax^2),delta*v,delta))^gamma;
end