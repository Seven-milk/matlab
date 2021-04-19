function [ FLAGS ] = BGSA( x,y,P0,L0 )
% [ FLAGS ] = BGSA( x,y,P0,L0 )
%  x: the x-coordinate of sequence(just for plot, set as [] if not use)
%  y: the sequence
%  P0: a critical value to determine whether the segmentation point is 
%      significant 
%  L0: the minimum segmentation scale
%  FLAGS: a logic vector returned with the same size as y, and value of 1
%         denotes the corresponding position locates a segmentation point
% Find out and plot the mutation points and its maximum density interval by
%   Bernaola-Galvan Segmentation Algorithm(BGSA).
%   How to interpret the figure?
%   The blue thin curve is primitive sequence; and the thick one denotes 
%   the interval mean of primitive sequence in each segment; the red 
%   vertical lines indicate where the segmentation points locate; shadows
%   indicate the maximum mutation density intervals. 

n = length(y);
if isempty(x)
    x = 1:n;
end
FLAGS = zeros(1,n);
FLAGS(n) = 1;

% Locate the position of segmentation points by mark 1 in FLAGS. 
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
            [ Xpos,PTmax ] = calc_TP( subx,suby );
            if PTmax>=P0
                FLAGS(x==min(Xpos)) = 1;
                num_sp = num_sp+1;
            end
        end
    end
    if num_sp==numsp_bf
        break
    end
end

% Calculate the mean sequence of each segmentation.
for k = 1:num_sp
    if k==1
        my(1:I(k)) = mean(y(1:I(k)));
    else
        my(I(k-1)+1:I(k)) = mean(y(I(k-1)+1:I(k)));
    end
end

% Adjust some unreasonable mutation points.
FLAGS(n) = 0;
for j = 2:n
    if FLAGS(j)==1 && FLAGS(j-1)==1
        FLAGS(j) = 0;
    end
end

%return
figure

% Calculate and find out the interval of the max mutation density.
NDT = L0;
for j = 1:n-NDT
    n = sum(FLAGS(j:j+NDT));
    eta(j) = n/NDT;
end
Ieta = find((eta==max(eta))+(eta~=0)==2);

% Shadow the intervals
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

% Plot the curves and vertical lines at segmentation points.
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

function [ Xpos,PTmax ] = calc_TP( X,Y )
% Subfunction to calculate the statistic T and find out the Tmax with its
%   position(Xpos) corresponding to X-series, and then calculate statistic 
%   PTmax for significance test. 

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

