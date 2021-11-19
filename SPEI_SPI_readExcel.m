%%
% Programmed by Taesam Lee,  Dec.03,2009
% INRS-ETE, Quebec, Canada
function [Z]=SPEI_SPI(Path,scale,nseas)
%Standardized Precipitation Index 
% Input Data
% Data : Monthly Data vector not matrix (monthly or seasonal precipitation)
% scale : 1,3,12,48
% nseas : number of season (monthly=12)
% Example
% Z=SPI(gamrnd(1,1,1000,1),3,12); 3-monthly scale, 
% Notice that  the rest of the months of the fist year are removed.
% eg. if scale =3, fist year data 3-12 SPI values are not estimated.

%if row vector then make coloumn vector
%if (sz==1) Data(:,1)=Data;end
Data = xlsread(Path)
erase_yr=ceil(scale/12);  %1-12�ĳ߶Ⱦ�Ϊ1��13-24��ʱ��߶�Ϊ2��Ŀ�����ں���Ŀ����ã���1-12���ڵ�һ��Ϊ��ֵ��13-24����ǰ����Ϊ��ֵ

% Data setting to scaled dataset
A1=[];
for is=1:scale
   A1=[A1,Data(is:length(Data)-scale+is)]; %����߶�Ϊ2�Ļ������������ֵ����51�꼴612��ֵΪ������1��Ϊ1-611����2��Ϊ2-612
end
XS=sum(A1,2);  %��ÿ�еĺͣ����߶�Ϊ2�Ļ�����1��2�ۼӣ�2��3�ۼӣ�ֱ��611��612�ۼ�

% erase_year
if(scale>1)
    XS(1:nseas*erase_yr-scale+1)=[];   %�߶�Ϊ2ʱ����1-11��ֵ��Ϊ�գ������е�һ��ֵ��Ϊ��һ���12���2���1�µ��ۼ�ֵ��������Ϊ��2��1�·ݵ�ֵ
end

for is=1:nseas  %12���µ�ѭ����nseas=12
    tind=is:nseas:length(XS); %��ÿ���Ӧ�·ݵ�����ֵ������
    Xn=XS(tind);%��ÿ���Ӧ�·ݵ�ֵ������
    Xn_ = sort(Xn); %��Xn���д�С�����������Ϊ�����������ʱ��F�ı仯������Ӱ�죬w0,w1,w2Ϊ�����ĸ��ʼ�Ȩ�أ������Ҫ��С��������
    % �ع���
    N = length(Xn_);
    % w0
    w0 = mean(Xn_);
    w1 = 0;
    % w1
    for i = 1:N
        F = (i-0.35)/N;
        w1 = w1 + ((1-F)*Xn_(i));
    end
    w1 = w1 / N;
    % w2
    w2 = 0;
    for i = 1:N
        F = (i-0.35)/N;
        w2 = w2 + (((1-F)^2)*Xn_(i));
    end
    w2 = w2 / N;
    % aby
    b = (2*w1 - w0)/(6*w1 - w0 - 6*w2);
    a = (w0-2*w1)*b / gamma(1 + 1/b)/ gamma(1 - 1/b);
    y = w0 - a*gamma(1 + 1/b)*gamma(1 - 1/b);
    % ��������cdf
    log_cdf = @(x) 1/(1+(a/(x-y))^b);
    % ��cdf
    cdf = [];
    for i = 1:N
        cdf(i) = log_cdf(Xn(i));
    end
    min(cdf)
    max(cdf)
    Z(tind)=norminv(cdf);
end

%Gamma parameter estimation and tranform

