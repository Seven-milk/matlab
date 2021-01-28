%������Ч�ɺ�ָ��EDI
function [date_365,date_APD,EDI,EP_DS,PRN,APD,CNS,ANES,DR]=EDI_ORIGINAL(date,x)
%% ����˵��
%date           ��Ӧ��x�����ڣ������յ�date���У�
%x              �ս�ˮ���У�������,��Ҫ���ٴ���30�꣬30*365=10950����
                %����ǳ���������ģ�����ʼΪĳ��1��1�գ�����Ϊĳ��12�����1�գ�
%EP_365         ����365���ڵ���Ч��ˮ��������DS�������EP_DS(��ȥ��ͷ��β)
%date_365       ��Ӧ��EP_365��ʱ����������ȥ��ͷ��364����β�����������βֵ����
%EP_DR/EP_DS    DR���ڵ�EPֵ������EP_365�еõ�EP_DS
%MEP            ÿ��EP�����ֵ��
%DEP=PRN./Ȩֵ  EP������ֵ��=PRN����PRN���ý�ˮ��ʾ��������DEP��ԭȨ�غ��ֵ������Ҫ����DS����
%SEP=EDI        ��׼��DEPָ������������̶ȣ�=EDI,����Ҫ����DS������
%CNS            ����SEP������ʱ��
%ANES           ����SEP�����Ҷȣ�
%DR             ����SEP�ĸ����ڣ�
%DS             ���ڸ�����DR���¼���ÿ�������ڶ�Ӧ�ļ�����DS���������ڴ�365��Ϊ365+DR=DS
%AVG            ����ƽ���ս�ˮ
%APD            �ۻ���ˮ��ȱ��365Ϊ�������ڣ���������DS������
%% ����˵��
%����EDI��ȥͷ��ǰ365���㲻�ˣ���ȥβ�������������꣩
%% ʱ�丳Ȩ�����ڸ�Ȩ������x������Ч��ˮ��EP_365����ͳ�Ʋ���,��365Ϊ�ٶ�DS��������
[EP_365,date_365]=time_weight(date,x);
n=floor(length(EP_365)/365);%����
EP_365(n*365+1:end)=[];%ȥβ
date_365(n*365+1:end)=[];%ȥβ
EP_365=reshape(EP_365,n,365);%��EP_365����reshape,�����30��*365�յľ���
MEP=mean(EP_365);
DEP=EP_365-MEP;
SEP=DEP./std(EP_365);
SEP=reshape(SEP,365*n,1);
DEP=reshape(DEP,365*n,1);
EP_365=reshape(EP_365,n*365,1);
%��Ӧʱ���Ϊdate_365
%% �����ۻ���ˮ��ȱ,��365Ϊ�������ڣ�1��1�յ��ۻ���ˮ��ȱ��ʾһ��ǰ�ܹ��Ľ�ˮ��ȱ�����죨δ��Ȩ��
[APD,DEP_APD,date_APD]=APD_365(date,x);
%APD��Ӧʱ���Ϊdate_365,DEP_APD��Ӧʱ��date
%% ����SEP��һ��ȷ��DS���γ����ۣ���ֵΪ0,ʶ��ĸ���Ϊ�����ڳ���,
%  ����ÿ��������DR(i)���õ�ÿ�������ڵ���DS(i)=DR(i)-364
[CNS,ANES,flag_start,flag_end]=run_theory(SEP,0);
DR=[date_365(flag_start),date_365(flag_end)];%������
[m,~]=size(DR);
for i1=1:m
    DS(i1,2)=DR(i1,2);
    DS(i1,1)=date(find(date==DR(i1,1))-364);
end
%% DS���������¼���ÿ����DS�ڵ�APD,AVG,PRN,EDI
%Ԥ����EDI,PRN,EP_DS,�ٽ���DS����
a=0;
for i_a=1:365
    a=1/i_a+a;%���㻹ԭȨ��
end
PRN=DEP./a;%��ԭ���õ�PRN��ʼ
EP_DS=EP_365;
%����DS����
for i2=1:m    
    start_1=find(date_365==DR(i2,1));%��Ӧdate_365
    end_1=find(date_365==DR(i2,2));
    start_2=find(date==DR(i2,1));%��Ӧdate
    end_2=find(date==DR(i2,2));
    %��DS=DR+365���ڵĽ�ˮ��ȱ�����ۼӣ������ǵ�������365����
    for i3=1:(end_1-start_1+1)
    APD_(i3)=sum(DEP_APD(start_2-364:start_2+i3-1));
    end
    APD(start_1:end_1)=APD_';
    clear APD_
    %���¼���DR���ڵ�EP
        %DRʱ���Ӧdate_365��date
%     start_1=find(date_365==DR(i2,1));%��ӦEP_365
%     end_1=find(date_365==DR(i2,2));
%     start_2=find(date==DR(i2,1));%��Ӧx
%     end_2=find(date==DR(i2,2));
        %���¼���DR�ڵ�EP_DR������EP�й���EP_DS
    for i5=1:(end_1-start_1+1)
        s=0;
        ckmn=0;
        for i6=1:365+i5-1
            s=s+mean(x(start_2+i5-i6:start_2+i5-1));
            ckmn=1/i6+ckmn;%1/n�����
        end
        EP_DR(i5)=s;
        b=mod(start_1+i5-1,365);
        if b==0
            b=365;
        end
        DEP_DR(i5)=EP_DR(i5)-MEP(b);
        PRN_DR(i5)=DEP_DR(i5)./ckmn;
    end
    EP_DS(start_1:end_1)=EP_DR';
    PRN(start_1:end_1)=PRN_DR';
    clear EP_DR PRN_DR DEP_DR
end
PRN=reshape(PRN,n,365);
EDI=PRN./std(PRN);
PRN=reshape(PRN,n*365,1);
EDI=reshape(EDI,n*365,1);
%% ʱ�丳Ȩ����������365�ĸ�Ȩ���EPֵ
function [EP_365_,date_365]=time_weight(date,x)
%����EP_365�����ڣ�2��ʽ��ǰm��Ľ�ˮ����m��ƽ����ˮ������ʽ������ˮ��Դ
EP_365_=zeros(length(x)-365+1,365);%�ӵ�365�쿪ʼ�����ۻ�������length(x)-364;365����Ϊ���������ʵ�ֹ�ʽ��2��
[p,~]=size(EP_365_);
date_365=date(365:end);
for i=1:p
    for j=1:365
    EP_365_(i,j)=mean(x(i+j-1:365+i-1));
    end
end
EP_365_=sum(EP_365_')';
end
%% ����365���ۻ���ˮ��ȱAPD
function [APD,DEP_APD,date_APD]=APD_365(date,x)
date_APD=date(365:end);
%�����ֵ
n1=floor(length(x)/365);
x1=x;
x1(n1*365+1:end)=[];
x1=reshape(x1,n1,365);
MEP_x1=mean(x1);
%�������DEP_x1
for i=1:length(x)
    b1=mod(i,365);
    if b1==0
        b1=365;
    end
    DEP_x1(i)=x(i)-MEP_x1(b1);
end
%����APD
for i=1:length(x)-364
    APD(i)=sum(DEP_x1(i:365+i-1));
end
APD=APD';
DEP_APD=DEP_x1';
end
%% ��ͼ
figure
subplot(2,1,1);
bar(date,x);
hold on 
plot(date_APD,APD);
plot(date_365,EP_DS);
hold off
set(gca,'XLim',[date(1),date(end)]);
ylabel('��ˮ/mm');
subplot(2,1,2);

hold on 
plot(date_365,EDI*100);
plot(date_365,PRN);
xlabel('����');
ylabel('ָ��');
set(gca,'XLim',[date(1),date(end)]);
legend('EDI*100','PRN');%,'APD'
hold off
end