function [FLAGS]=BGSA(x,y,P0,L0)
%���ĳ���
% [ FLAGS ] = BGSA( x,y,P0,L0 )
%  x: ���е�x���꣨�����ڻ�ͼ�������ʹ��������Ϊ[]��
%  y: ����������
%  P0: ������ˮƽ����ֵ�����ڴ�ֵ�Ĳ��ٷָ�
%  L0: ��С�ָ�߶ȣ��Ӷγ���С�ڴ�ֵ�Ĳ��ٷָ�
%  FLAGS: ���ص��߼�������y��С��ͬ��ֵΪ1��ʾ��Ӧ��λ�ö�λ�ָ��
% ͨ��Bernaola-Galvan�ָ��㷨��BGSA���ҳ�������ͻ��㼰������ܶȼ����
%   ��ν���������֣�
%   ��ɫϸ������ԭʼ����; ����һ����ʾÿ������ԭʼ���еļ��ƽ��ֵt; ��ɫ��ֱ�߱�ʾ�ָ�����ڵ�λ��;��Ӱָʾ���ͻ���ܶȼ����\
n=length(y);
if isempty(x)
    x=1:n;
end
FLAGS=zeros(1,n);
FLAGS(n)=1;

% ͨ�����1��FLAGS���ҵ��ָ���λ�á�
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

% ����ÿ���ָ��ƽ�����С�
for k = 1:num_sp
    if k==1
        my(1:I(k)) = mean(y(1:I(k)));
    else
        my(I(k-1)+1:I(k)) = mean(y(I(k-1)+1:I(k)));
    end
end

% ����һЩ�������ͻ��㡣
FLAGS(n) = 0;
for j = 2:n
    if FLAGS(j)==1 && FLAGS(j-1)==1%����ͻ���
        FLAGS(j) = 0;
    end
end

%return
figure

% ���㲢�ҳ����ͻ���ܶȵļ����
NDT = L0;
for j = 1:n-NDT
    n = sum(FLAGS(j:j+NDT));
    eta(j) = n/NDT;
end
Ieta = find((eta==max(eta))+(eta~=0)==2);

% Ӱ����
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

% �ڷָ��������ߺʹ�ֱ�ߡ�
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
% �Ӻ�������ͳ����T�����ҳ���Xϵ�ж�Ӧ��λ�ã�Xpos����Tmax��Ȼ����������Լ����ͳ��PTmax��
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