%������Ч�ɺ�ָ��EDI
function [date_EP,EDI,EP,MEP,DEP,SEP,PRN,CNS,ANES,DS,date_p_sum,p_sum,AVG,APD]=EDI_ORIGINAL(date,x)
%% ����˵��
%date               ��Ӧ��x�����ڣ������յ�date���У�
%x                  �ս�ˮ���У�������,��Ҫ���ٴ���30�꣬30*365=10950����
                    %����ǳ���������ģ�����ʼΪĳ��1��1�գ�����Ϊĳ��12�����1�գ�
                
%EP_365             ����365���ڵ���Ч��ˮ����ȥ��ͷβ
%date_365           ��Ӧ��EP_365��DEP_365,SEP_365,PRN_365,EDI_365,APD_365,p_sum_365��ʱ����������ȥ��ͷ��364����β�����������βֵ����
%MEP_365            ÿ��EP�����ֵ��
%DEP_365            EP������ֵ��
%SEP_365            ��׼��DEPָ������������̶ȣ�
%PRN_365            DEP_365/wight_365�õ��Ļָ�������ˮ��
%EDI_365            EDIָ����ΪDEP_365��PRN_365��׼��ֵ
%CNS                ����SEP������ʱ��
%ANES               ����SEP�����Ҷȣ�
%DR                 ����SEP��ÿ����ĸ����ڣ���0~CNS-1��
%DS                 ����DR���¼����ÿ������ڶ�Ӧ������������DS���������ڴ�365��Ϊ365+DR=DS
%AVG_365            ����ƽ���ս�ˮ
%APD_365            �ۻ���ˮ��ȱ��365Ϊ�������ڣ�,date_APD_365Ϊ��Ӧʱ��
%p_sum_365          �ۻ���ˮ����Ӧʱ��Ϊdate_p_sum_365
%����ָ����365       Ϊ����DS�����Ĳ���ֵ,��Ӧ����Ϊdate_EP
%% ����˵��
%����EDI��ȥͷ��ǰ364���㲻�ˣ���ȥβ�������������꣩
%% ʱ�丳Ȩ�����ڸ�Ȩ������x������Ч��ˮ��EP_365����ͳ�Ʋ���,��365Ϊ�ٶ�DS��������
[EP_365,date_365]=time_weight(date,x);%�Ѿ�ȥ���˿�ͷ��365��ֵ����ΪҪ�ۻ���
n=floor(length(EP_365)/365);%����
EP_365(n*365+1:end)=[];%ȥβ
date_365(n*365+1:end)=[];%ʱ��ȥβ
EP_365=reshape(EP_365,365,n);EP_365=EP_365';%��EP_365����reshape,�����n��*365�յľ���(reshape������Ϊ��λ���棬ע��)
MEP_365=mean(EP_365);
%��MEP�������յĻ���ƽ��
for i_MEP=1:361
MEP_365(i_MEP+2)=mean(MEP_365(i_MEP:i_MEP+4));
end
%
DEP_365=EP_365-MEP_365;
SEP_365=DEP_365./std(EP_365);
SEP_365=SEP_365';SEP_365=reshape(SEP_365,365*n,1);%���±�Ϊ������n*365
DEP_365=DEP_365';DEP_365=reshape(DEP_365,365*n,1);%���±�Ϊ������n*365
EP_365=EP_365';EP_365=reshape(EP_365,365*n,1);%���±�Ϊ������n*365   
%��Ӧʱ���Ϊdate_365
%% �����ۻ���ˮp_sum���ۻ���ˮ��ȱAPD,����ƽ��AVG,��365Ϊ�������ڣ�1��1�յ��ۻ���ˮ��ȱ��ʾһ��ǰ�ܹ��Ľ�ˮ��ȱ�����죨δ��Ȩ��
[APD_365,AVG_365,date_APD_365,p_sum_365,date_p_sum_365]=APD_AVG(date,x);
APD_365=APD_365';APD_365=reshape(APD_365,365*n,1);
%��Ӧʱ��ֱ�Ϊdate_APD,date_p_sum
%% ����PRN������DEP��ʱ�丳Ȩ��ʽ
%����Ȩֵ��ÿ�����Ȩֵ=sum_i(1/n)(i=1:DS)
wight_365=zeros(length(x)-365+1,1);
wight_365(n*365+1:end)=[];%ȥβ��Ϊ����DEP��Ӧ���������
s_wight=0;
for i9=1:365
    s_wight=s_wight+1/i9;
end
wight_365(:)=s_wight;
%PRN=DEP/wight
PRN_365=DEP_365./wight_365;
%% EDI���㣬��PRN����DEP�ı�׼��
%PRN_,DEP_����ת�ɾ�����״n*365
DEP_=reshape(DEP_365,365,n)';
%PRN_=reshape(PRN,365,n)';
EDI_365=DEP_./std(DEP_);
EDI_365=EDI_365';EDI_365=reshape(EDI_365,365*n,1);
%EDI_PRN=PRN_./std(PRN_);%�Ƿ�ֵ��һ����yes,����ɾһ��
%% ����SEP��һ��ȷ��DS���γ����ۣ���ֵΪ0,ʶ��ĸ���Ϊ������CNS����
[CNS,ANES,flag_start,flag_end]=run_theory(SEP_365,0);%�����ڳ���CNS����ʱ��,flag_start��flag_end��SEPʱ���Ӧ����ţ�
m=length(CNS);%��������Ŀ
%����Ӧ��ʼ/�������Ϊflag�������Ŷ�Ӧ��SEP,����Ӧ��date_365��
% ��Ӧ�ۻ��Ҷ�ANES

%  ����DR,DS��DS(i)=DR(i)-364
DS=zeros(length(x)-365+1,1);%ȥͷ�����е����DS���������ڣ���Ĭ��Ϊ365
DS(:)=365;
date_DR=[date_365(flag_start),date_365(flag_end)];%��Ӧ�����ڵ�DR
DR=zeros(length(x)-365+1,1);%length(x)-365+1���㣬��������DS=365������m�������ڣ���������DS=365+DS��i����DS=0:CNS-1����1��CNS��Ҫ��1��
for i8=1:m%ÿ���������ڼ���
    DR(flag_start(i8):flag_end(i8))=(0:CNS(i8)-1);%flag��DS�Ƕ�Ӧ����yes��DS��ȥͷ�ģ�flag��SEPһ�£�Ҳ��ȥͷ�ģ���Ӧ
end
DS=DS+DR;
%% DS����������������DS���¼���EP,MEP,DEP,SEP,APD,AVG,p_sum��PRN,EDI�������DS=365����>DS=365+DR�ܸ��õؼ������ڸɺ���ʱ��߶����ԣ�
%EP����,MEP,DEP,SEP
[EP,date_EP]=time_weight(date,x,DS);
EP(n*365+1:end)=[];%ȥβ
date_EP(n*365+1:end)=[];%ʱ��ȥβ
EP=reshape(EP,365,n);EP=EP';%��EP_365����reshape,�����n��*365�յľ���(reshape������Ϊ��λ���棬ע��)
MEP=mean(EP);
%��MEP�������յĻ���ƽ��
for i_MEP=1:361%������361
MEP(i_MEP+2)=mean(MEP(i_MEP:i_MEP+4));
end
%
DEP=EP-MEP;
SEP=DEP./std(EP);
SEP=SEP';SEP=reshape(SEP,365*n,1);%���±�Ϊ������n*365
DEP=DEP';DEP=reshape(DEP,365*n,1);%���±�Ϊ������n*365
EP=EP';EP=reshape(EP,365*n,1);%���±�Ϊ������n*365   

%APD,AVG,p_sum����
[APD,AVG,date_APD,p_sum,date_p_sum]=APD_AVG(date,x,DS);
APD=APD';APD=reshape(APD,365*n,1);

%PRN,EDI
%����Ȩֵ��ÿ�����Ȩֵ=sum_i(1/n)(i=1:DS)
wight=zeros(length(x)-365+1,1);
for i10=1:length(x)-365+1
    s_wight=0;
    for j10=1:DS(i10)
        s_wight=s_wight+1/j10;
    end
    wight(i10)=s_wight;
end
wight(n*365+1:end)=[];%ȥβ��Ϊ����DEP��Ӧ���������
%PRN=DEP/wight
PRN=DEP./wight;
%EDI
%PRN_,DEP_����ת�ɾ�����״n*365
DEP_=reshape(DEP,365,n)';
%PRN_=reshape(PRN,365,n)';
EDI=DEP_./std(DEP_);
EDI=EDI';EDI=reshape(EDI,365*n,1);

%% ʱ�丳Ȩ����������365������DS�ĸ�Ȩ���EPֵ
function [EP,date_EP]=time_weight(date,x,varargin)
%����EP�����ڣ�ĳ��ʽ���ԣ�2��Ϊ����ǰm��Ľ�ˮ����m��ƽ����ˮ������ʽ������ˮ��Դ
date_EP=date(365:end);
%����DS,DSӦ����ÿ����ļ������ڣ�����Ϊlength(x)-365+1
if nargin==2%����DS�Ƕ��٣���Ҫ����ĵ����Ŀ����length(x)-365+1���㣬ֻ������͵���������
    DS_1=zeros(length(x)-365+1,1);%����ÿ����(��length(x)-365+1���㣬ǰ���365����϶�������)�ļ�������
    DS_1(:)=365;%��û������Ӧ���Ǽ���̶����ڵ�EP_365��ÿ�����DS=365
else
    DS_1=varargin{1};
end
%�����Զ����ʱ�丳Ȩ�����������
for i=1:length(x)-365+1%�ӵ�365�쿪ʼ�����ۻ�����length(x)-365+1�����ֵ
    s_=0;
    for j=1:DS_1(i)%ÿ�������ͳ��ȣ���������Ŀ
        s_=s_+mean(x(i-j+1+365-1:i+365-1));
    end
    EP(i)=s_;
end
EP=EP';
end


%% �����ۻ�P���ۻ�����ΪDS��������365���ۻ���ˮ��ȱAPD,����ƽ���ս�ˮAVG,p_sumΪ����DS���ۻ���ˮ
function [APD,AVG,date_APD,p_sum,date_p_sum]=APD_AVG(date,x,varargin)
%�����ۻ���ˮ��ȱAPD,����ƽ���ս�ˮAVG
date_p_sum=date(365:end);
date_APD=date(365:end);
%����DS,DSӦ����ÿ����ļ������ڣ�����Ϊlength(x)-365+1
if nargin==2
    DS_1=zeros(length(x)-365+1,1);%ͬ��
    DS_1(:)=365;
else
    DS_1=varargin{1};
end
%
%����DS��x�����ۻ���ˮp_sum��ȥͷ��δȥβ
p_sum=zeros(length(x)-365+1,1);
for i7=1:length(x)-365+1%�ӵ�365�쿪ʼ�����ۻ�����length(x)-365+1�����ֵ
    p_sum(i7)=sum(x(i7+365-1-DS_1(i7)+1:i7+365-1));
end
%����AVG��APD��ȥβ
n1=floor(length(p_sum)/365);%ȥβ����׼Ϊn*365
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
%% ��ͼ
figure
subplot(3,1,1);
bar(date,x);
legend('��ˮ');
xlabel('����');
ylabel('��ˮ/mm');
set(gca,'XLim',[date(1),date(end)]);

subplot(3,1,2);
hold on 
plot(date_EP,EP,'--');
plot(date_EP,SEP*100,'-.');
plot(date_EP,zeros(length(EP),1));%0�߻���
plot(date_EP,repmat(MEP,1,n),'-');%MEP�ظ�����
hold off
xlabel('����');ylabel('ָ��');
legend('EP','SEP*100','0','MEP')
set(gca,'XLim',[date(1),date(end)]);

subplot(3,1,3);
hold on 
plot(date_EP,EDI*100,'-');
plot(date_EP,APD,'--');
plot(date_EP,PRN*10,'-.');
%ANES������ͼ
ANES_=zeros(length(x)+365-1,1);
for i11=1:length(ANES)
    for j11=1:CNS(i11)
    ANES_(flag_start(i11)+j11-1)=sum(SEP_365(flag_start(i11):flag_start(i11)+j11-1));%��Ҫ����sep_365����
    end
end
ANES_(n*365+1:end)=[];
plot(date_EP,ANES_,':');
xlabel('����');ylabel('ָ��');
hold off
legend('EDI*100','APD','PRN*10','ANES');
set(gca,'XLim',[date(1),date(end)]);
% subplot(5,4,1);
% plot(date_EP,repmat(MEP,1,n),'-');%MEP�ظ�����
% plot(date_EP,EP,'--');
% plot(date_EP,zeros(length(EP),1));%0�߻���
% plot(date_EP,SEP*100,'-.');


% hold on 
% plot(date_EP,EDI*100);
% plot(date_EP,PRN);
% xlabel('����');
% ylabel('ָ��');
% set(gca,'XLim',[date(1),date(end)]);
% legend('EDI*100','PRN');%,'APD'
% hold off
end