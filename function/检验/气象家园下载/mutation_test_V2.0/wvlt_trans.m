function [ wvcoef ] = wvlt_trans( y,x,scale,p,isp )
%[ wvcoef ] = wvlt_trans( y,x,scale,p,isp )
%  y: the sequence
%  x: the x-coordinate of sequence(set as [] if not use, default=1:length(y))
%  scale: the scale of wavelet transformation(default=ceil(length(y)./[2 5 10]))
%  p: the level of significance for t-testing(default=0.05)
%  isp: whether plot a figure or not(1 for yes, 0 for no, default=1)
%  wvcoef: wavelet coefficient(the real part of wavelet tranformation result)
% Wavelet transformation mutation test is used for testing the mutation on 
%   multiple scales. The intersection points of curves and x-axis indicates
%   where mutation may happens on this scale, but then t-testing is also
%   necessary to distinguish whether these mutation is significant.
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

if nargin<5
    isp = 1;
end
if nargin<4
    p = [];
end
if nargin<3
    scale = [];
end
if nargin<2
    x = [];
end
if nargin<1
    error('not enought input');
end
if isempty(p)
    p = .05;
end
if isempty(scale)
    scale = ceil(length(y)./[2 5 10]);
end
if isempty(x)
    x = 1:length(y);
end

yd = y-mean(y);
dt = x(2)-x(1);

dj = 1;
j1 = 0;
mother = 'Morlet';
disp('  year   segment-mean   H     t-value');
for i = 1:length(scale)
    s0 = scale(i);
    lgd{i} = num2str(s0);
    disp(['scale=',num2str(s0)]);
    wave = wavelet(y,dt,1,dj,s0,j1,mother);
    wvcoef(i,:) = real(wave);
    wcsg = sign(wvcoef(i,:));
    wcsg(wcsg==0) = 1;
    sg = 0;
    s = 0;
    for j = 1:length(wcsg)
        if wcsg(j)~=sg
            s = s+1;
            isb(s) = j;
            ise(s) = j;
            xsb(s) = x(j);
            xse(s) = x(j);
            sg = wcsg(j);
        else
            ise(s) = j;
            xse(s) = x(j);
        end
    end
    ns = length(isb);
    for s = 1:ns
        msy = mean(yd(isb(s):ise(s)));
        c = num2str(roundn(msy,-4));
        c1(1:10) = ' ';
        c1(end-length(c)+1:end) = c;
        if s~=ns
            [h,~,~,stats] = ttest2(yd(isb(s):ise(s)),yd(isb(s+1):ise(s+1)),'alpha',p);
            c2 = num2str(h);
            c = num2str(roundn(stats.tstat,-4));
            c3(1:10) = ' ';
            c3(end-length(c)+1:end) = c;
            disp([num2str(xsb(s)),'-',num2str(xse(s)),' ',c1,'    ',c2,' ',c3]);
        else
            disp([num2str(xsb(s)),'-',num2str(xse(s)),' ',c1]);
        end
        clear c1 c2 c3
    end
    clear isb ise xsb xse
end

if ~isp
    return
end

xl = [min(x)-(max(x)-min(x))*.01 max(x)+(max(x)-min(x))*.01];
plot(x,wvcoef,'linewidth',.8)
hold on
legend(lgd);
plot(xl,[0 0],'color','k');

yl0 = get(gca,'ylim');
yl = [min(yl0)-(max(yl0)-min(yl0))*.02 max(yl0)+(max(yl0)-min(yl0))*.05];
set(gca,'xlim',xl,'ylim',yl,'Fontname','Times New Roman','FontSize',10);

title('Wavelet transformation method')
end

