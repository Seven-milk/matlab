%%
% Programmed by Taesam Lee,  Dec.03,2009
% INRS-ETE, Quebec, Canada
function [Z]=SPEI_SPI(pre,tem,year,start_year,scale,nseas)
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
%% ����PT
Heatindex=[];
a=[];
PT=[];
p=[];
Ta=tem;

for year_=year(1):year(end)
    
        l=(year_-start_year)*12+1;
        m=l+11;

        for i= l:m
                if Ta(i)<=0
                    p=[p,0];    
                elseif 0<Ta(i)
                     p=[p,(Ta(i)/5)^1.514]; 
%    else
%        p=[p,-415.85+32.24*T-0.43*T^2]; 
                end
        end
sp= sum(p);
Heatindex=[Heatindex;sp];
a1=(6.75*10.^-7)*(sp)^3-(7.71*10.^-5)*(sp)^2+(1.79*10.^-2)*(sp)+0.49;
a=[a;a1];
for i=l:m
    if Ta(i)<=0
         PT=[PT,0];    
    elseif 0<Ta(i)&&Ta(i)<=26.5
        PT=[PT,16*(Ta(i)*10/sp)^a1];
    else
        PT=[PT,-415.85+32.24*T-0.43*T^2];  
    end

end
p=[];
end

%%
Data = pre - PT';

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

    %note:!!! real or complex, modify b
    if ~(isreal(cdf))
        log_cdf = @(x) 1/(1+(a/(x-y))^floor(b));
        cdf = [];
        for i = 1:N
            cdf(i) = log_cdf(Xn(i));
        end
    end

    Z(tind)=norminv(cdf);
end
Z = Z';
%Gamma parameter estimation and tranform

