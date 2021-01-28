%������Ч�ɺ�ָ��EDI����EDI_ORGINAL�Ļ��������ӱ�߶�DS�Ĺ��ܣ���365����>n�ɱ�
function [date_EP,EDI,EP,MEP,DEP,SEP,PRN,CNS,ANES,DS,date_p_sum,p_sum,AVG,APD]=EDI_change(date,x,varargin)
%% ����˵��
%varargin           �߶ȣ���ʼDS��Ĭ��Ϊ365���ɱ䣨�̳߶Ȳ���ڸɺ���,��ΪL
%date               ��Ӧ��x�����ڣ������յ�date���У�
%x                  �ս�ˮ���У�������,��Ҫ���ٴ���30�꣬30*365=10950����
                    %����ǳ���������ģ�����ʼΪĳ��1��1�գ�����Ϊĳ��12�����1�գ�
             
%EP_DS1             ����L���ڵ���Ч��ˮ����ȥ��ͷβ
%date_DS1           ��Ӧ��EP_DS1��DEP_DS1,SEP_DS1,PRN_DS1,EDI_DS1,APD_DS1,p_sum_DS1��ʱ����������ȥ��ͷ��L-1����β�����������βֵ����
%MEP_DS1            ÿ��EP�����ֵ��
%DEP_DS1            EP������ֵ��
%SEP_DS1            ��׼��DEPָ������������̶ȣ�
%PRN_DS1            DEP_DS1/wight_DS1�õ��Ļָ�������ˮ��
%EDI_DS1            EDIָ����ΪDEP_DS1��PRN_DS1��׼��ֵ
%CNS                ����SEP������ʱ��
%ANES               ����SEP�����Ҷȣ�
%DR                 ����SEP��ÿ����ĸ����ڣ���0~CNS-1��
%DS                 ����DR���¼����ÿ������ڶ�Ӧ������������DS���������ڴ�L��ΪL+DR(0~CNS)=DS
%AVG_DS1            ����ƽ���ս�ˮ
%APD_DS1            �ۻ���ˮ��ȱ��LΪ�������ڣ�,date_APD_DS1Ϊ��Ӧʱ��
%p_sum_DS1          �ۻ���ˮ����Ӧʱ��Ϊdate_p_sum_DS1
%����ָ����DS1       Ϊ����DS�����Ĳ���ֵ,��Ӧ����Ϊdate_EP
%% ��DS1��ʼֵ��ֵ(ǰL-1����û����)
if nargin==2
    DS1=zeros(length(x)-365+1,1);
    DS1(:)=365;
    L=365;
else 
    DS1=zeros(length(x)-varargin{1}+1,1);
    DS1(:)=varargin{1};
    L=varargin{1};
end
%% ����˵��
%����EDI��ȥͷ��ǰL-1���㲻�ˣ���ȥβ�������������꣩
%% ʱ�丳Ȩ�����ڸ�Ȩ������x������Ч��ˮ��EP_DS1����ͳ�Ʋ���,��LΪ�ٶ�DS��������
[EP_DS1,date_DS1]=time_weight(date,x,L,DS1);%�Ѿ�ȥ���˿�ͷ��L-1��ֵ����ΪҪ�ۻ���
n=floor(length(EP_DS1)/365);%����
EP_DS1(n*365+1:end)=[];%ȥβ
date_DS1(n*365+1:end)=[];%ʱ��ȥβ
EP_DS1=reshape(EP_DS1,365,n);EP_DS1=EP_DS1';%��EP_365����reshape,�����n��*365�յľ���(reshape������Ϊ��λ���棬ע��)
MEP_DS1=mean(EP_DS1);
%��MEP�������յĻ���ƽ��
for i_MEP=1:361%������361
MEP_DS1(i_MEP+2)=mean(MEP_DS1(i_MEP:i_MEP+4));
end
%
DEP_DS1=EP_DS1-MEP_DS1;
SEP_DS1=DEP_DS1./std(EP_DS1);
SEP_DS1=SEP_DS1';SEP_DS1=reshape(SEP_DS1,365*n,1);%���±�Ϊ������n*365
DEP_DS1=DEP_DS1';DEP_DS1=reshape(DEP_DS1,365*n,1);%���±�Ϊ������n*365
EP_DS1=EP_DS1';EP_DS1=reshape(EP_DS1,365*n,1);%���±�Ϊ������n*365   
%��Ӧʱ���Ϊdate_365
%% �����ۻ���ˮp_sum���ۻ���ˮ��ȱAPD,����ƽ��AVG,��LΪ�������ڣ�1��1�յ��ۻ���ˮ��ȱ��ʾһ��ǰ�ܹ��Ľ�ˮ��ȱ�����죨δ��Ȩ��
[APD_DS1,AVG_DS1,date_APD_DS1,p_sum_DS1,date_p_sum_DS1]=APD_AVG(date,x,L,DS1);
APD_DS1=APD_DS1';APD_DS1=reshape(APD_DS1,365*n,1);
%��Ӧʱ��ֱ�Ϊdate_APD,date_p_sum
%% ����PRN������DEP��ʱ�丳Ȩ��ʽ
%����Ȩֵ��ÿ�����Ȩֵ=sum_i(1/n)(i=1:DS)
wight_DS1=zeros(length(x)-L+1,1);
wight_DS1(n*365+1:end)=[];%ȥβ��Ϊ����DEP��Ӧ���������
s_wight=0;
for i9=1:L
    s_wight=s_wight+1/i9;
end
wight_DS1(:)=s_wight;
%PRN=DEP/wight
PRN_DS1=DEP_DS1./wight_DS1;
%% EDI���㣬��PRN����DEP�ı�׼��
%PRN_,DEP_����ת�ɾ�����״n*365
DEP_=reshape(DEP_DS1,365,n)';
%PRN_=reshape(PRN,365,n)';
EDI_DS1=DEP_./std(DEP_);
EDI_DS1=EDI_DS1';EDI_DS1=reshape(EDI_DS1,365*n,1);
%EDI_PRN=PRN_./std(PRN_);%�Ƿ�ֵ��һ����yes,����ɾһ��
%% ����SEP��һ��ȷ��DS���γ����ۣ���ֵΪ0,ʶ��ĸ���Ϊ������CNS����
[CNS,ANES,flag_start,flag_end]=run_theory(SEP_DS1,0);%�����ڳ���CNS����ʱ��,flag_start��flag_end��SEPʱ���Ӧ����ţ�
m=length(CNS);%��������Ŀ
%����Ӧ��ʼ/�������Ϊflag�������Ŷ�Ӧ��SEP,����Ӧ��date_DS1��
% ��Ӧ�ۻ��Ҷ�ANES

%  ����DR,DS��DS(i)=DR(i)-L+1
DS=zeros(length(x)-L+1,1);%ȥͷ�����е����DS���������ڣ���Ĭ��ΪL
DS(:)=L;
date_DR=[date_DS1(flag_start),date_DS1(flag_end)];%��Ӧ�����ڵ�DR
DR=zeros(length(x)-L+1,1);%length(x)-L+1���㣬��������DS=L������m�������ڣ���������DS=L+DS��i����DS=0:CNS-1����1��CNS��Ҫ��1��
for i8=1:m%ÿ���������ڼ���
    DR(flag_start(i8):flag_end(i8))=(0:CNS(i8)-1);%flag��DS�Ƕ�Ӧ����yes��DS��ȥͷ�ģ�flag��SEPһ�£�Ҳ��ȥͷ�ģ���Ӧ
end
DS=DS+DR;
%% DS����������������DS���¼���EP,MEP,DEP,SEP,APD,AVG,p_sum��PRN,EDI�������DS=L����>DS=L+DR�ܸ��õؼ������ڸɺ���ʱ��߶����ԣ�
%EP����,MEP,DEP,SEP
[EP,date_EP]=time_weight(date,x,L,DS);
EP(n*365+1:end)=[];%ȥβ
date_EP(n*365+1:end)=[];%ʱ��ȥβ
EP=reshape(EP,365,n);EP=EP';%��EP_365����reshape,�����n��*365�յľ���(reshape������Ϊ��λ���棬ע��)
MEP=mean(EP);
%��MEP�������յĻ���ƽ��
for i_MEP=1:361
MEP(i_MEP+2)=mean(MEP(i_MEP:i_MEP+4));
end
%
DEP=EP-MEP;
SEP=DEP./std(EP);
SEP=SEP';SEP=reshape(SEP,365*n,1);%���±�Ϊ������n*365
DEP=DEP';DEP=reshape(DEP,365*n,1);%���±�Ϊ������n*365
EP=EP';EP=reshape(EP,365*n,1);%���±�Ϊ������n*365   

%APD,AVG,p_sum����
[APD,AVG,date_APD,p_sum,date_p_sum]=APD_AVG(date,x,L,DS);
APD=APD';APD=reshape(APD,365*n,1);

%PRN,EDI
%����Ȩֵ��ÿ�����Ȩֵ=sum_i(1/n)(i=1:DS)
wight=zeros(length(x)-L+1,1);
for i10=1:length(x)-L+1
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
function [EP,date_EP]=time_weight(date,x,L,DS_1)
%����EP�����ڣ�ĳ��ʽ���ԣ�2��Ϊ����ǰm��Ľ�ˮ����m��ƽ����ˮ������ʽ������ˮ��Դ
date_EP=date(L:end);
%�����Զ����ʱ�丳Ȩ�����������
for i=1:length(x)-L+1%�ӵ�L�쿪ʼ�����ۻ�����length(x)-L+1�����ֵ
    s_=0;
    for j=1:DS_1(i)%ÿ�������ͳ��ȣ���������Ŀ
        s_=s_+mean(x(i-j+1+L-1:i+L-1));
    end
    EP(i)=s_;
end
EP=EP';
end

%% �����ۻ�P���ۻ�����ΪDS��������365���ۻ���ˮ��ȱAPD,����ƽ���ս�ˮAVG,p_sumΪ����DS���ۻ���ˮ
function [APD,AVG,date_APD,p_sum,date_p_sum]=APD_AVG(date,x,L,DS_1)
%�����ۻ���ˮ��ȱAPD,����ƽ���ս�ˮAVG
date_p_sum=date(L:end);
date_APD=date(L:end);
%����DS��x�����ۻ���ˮp_sum��ȥͷ��δȥβ
p_sum=zeros(length(x)-L+1,1);
for i7=1:length(x)-L+1%�ӵ�L�쿪ʼ�����ۻ�����length(x)-L+1�����ֵ
    p_sum(i7)=sum(x(i7+L-1-DS_1(i7)+1:i7+L-1)); 
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
ANES_=zeros(length(x)+L-1,1);
for i11=1:length(ANES)
    for j11=1:CNS(i11)
    ANES_(flag_start(i11)+j11-1)=sum(SEP_DS1(flag_start(i11):flag_start(i11)+j11-1));%��Ҫ����sep_DS1����
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