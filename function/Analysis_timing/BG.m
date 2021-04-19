%����ʽ�ָѰ�����
function [FLAG,AllT_,AllTmax,AllPTmax,x_avg]=BG(date,X,P0,L0)
%�Լ���ĳ���
%% ��������б�
% date         x��Ӧ��ʱ�����У����ڻ�ͼ��ȡ����ͼ���ܾͲ���Ҫ�����
% X            �����������У��д洢
% p0           ������ˮƽ����ֵ��ptmax���ڴ�ֵ�Ĳ��ٷָ�.һ��ȡ0.95
% L0           ��С�ָ�߶ȣ��Ӷγ���С�ڴ�ֵ�Ĳ��ٷָһ��ȡ25
%% ��������б�
% FLAG         �ָ���ǣ��������洢��������X��ͬ
% AllT         ��ָ���Ӧ��ȫ��t�������У�����λ����Ϊ�������
% AllTmax      ��ָ���Ӧ��ȫ��t�������е����ֵ
% AllPTmax     ��ָ���Ӧ��ȫ��t�������ж�Ӧ��ͳ��������
% x_avg        ��X���ָ����зָ�Ķμ����ζ�Ӧ�ľ�ֵ
% AllT_        ���ֶ�˳��ָ�Ķ�Ӧ��Tֵ�����м���ÿ��ȥ��ͷβ������
% flag1/2      1Ϊ��ʱ��˳���ŵķָ�㣬2Ϊ���ֶ�˳���ŵķָ��  
% date_AllT    ΪAllT��Ӧ����ʼ�����ֹ��
%% �����Ӻ������ҷָ�㣬�ж�������
function [T,Tmax,p,PTmax]=partition(x)
%% �����б�
% x         ���ָ�����У��д洢
% T         T����
% Tmax      ���Tֵ
% p         ���Tֵ��Ӧ���
% PTmax     ���Tֵ��Ӧ��p_value,PTmax<P0ʱ��˵�����첻��������ֹ�ָ�
%% ����Ԥ��
n=length(x);%���г���
N1=(2:1:n-1)';%������г������У���Ӧ��i�����
N2=(n-1:-1:2)';%�Ҳ����г������У���Ӧ��i�����
mu1=zeros(n-2,1);%����ֵ����
mu2=zeros(n-2,1);%�Ҳ��ֵ����
sd1=zeros(n-2,1);%����׼������
sd2=zeros(n-2,1);%�Ҳ��׼������
% SD=zeros(n-1,1);%�ϲ�ƫ������
% T=zeros(n-2,1);%ͳ����T����
%% ѭ������ͳ����T����,�ȼ����ֵ���кͱ�׼������(�����þ������ٶȿ�)
for i=2:n-1
    mu1(i-1)=mean(x(1:i));
    mu2(i-1)=mean(x(i:end));
    sd1(i-1)=std(x(1:i));
    sd2(i-1)=std(x(i:end));
end
SD=sqrt(((N1-1).*(sd1.^2)+(N2-1).*(sd2.^2))./(N1+N2-2)).*sqrt(1./N1+1./N2);
T=abs((mu1-mu2)./SD);
Tmax=max(T);%���ֵT
p=find(T==Tmax)+1;%���T��Ӧ����x�е�λ�ã����Լ�1����Ϊp��T��ȥͷȥβ��
%% ������ˮƽ�жϣ��������Tֵ��Ӧ��pֵ
v=n-2;%����
Eta=4.19*log(n)-11.54;
Delta=0.40;
c=v/(v+Tmax^2);%����ȫBeta�������±�
PTmax=(1-betainc(c,Delta*v,Delta))^Eta;%���ò���ȫbeta����,�õ���Ӧ���Tֵ��p_value
end
%% ѭ��ִ���Ӻ�����ֱ��������ֵ
%% ����Ԥ��
n=length(X);%�����ܳ�
FLAG=zeros(n,1);%�ָ������,��x�ȳ�
FLAG(1)=1;%��Ϊ��һ��������һ���㲻�������㣬��FLAG����x�ȳ������Ը���һ�������һ����ֵ
FLAG(n)=1;%
AllT=cell(0,0);%�����cell�����ڴ洢��ָ���Ӧ��ȫ��T����
AllTmax=cell(0,0);%�����cell�����ڴ洢��ָ���Ӧ��T��ֵ
AllPTmax=cell(0,0);%�����cell�����ڴ洢��ָ���Ӧ��pֵ��ͬʱ��T��ֵ��Ӧ��
x=cell(0,0);%���Դ洢�ֶ�����
%% ��һ����ָ�
x(1)={X};
[T,Tmax,p,PTmax]=partition(x{1});
    if PTmax>=P0 
    FLAG(find(X==x{1}(p(1))))=1;
    AllT=[AllT;T];
    AllTmax=[AllTmax;Tmax];
    AllPTmax=[AllPTmax;PTmax];
    else 
        disp('�ޱ����');
    end
i1=1;
date_AllT_start(1)=2;
date_AllT_end(1)=length(X)-1;
i19=2;
%% �����ָ�,˼·�ǽ�x���������������ľ��󣬣�ͨ�������㣩����ÿ�θ�������1����2����4...��ûͨ����ֵ�Ͳ������㣩
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
if sum(FLAG1~=FLAG)==0%��FLAG���ٱ仯��˵����㲻���ˣ������ˣ��˳�ѭ��
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
%% ��ͼ
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
datetick('x','yyyy','keeplimits');%�������ڣ��꣬�£���ʾ
xlabel('���');
ylabel('����ֵ');
title('����ʽ�ָ�������');
%% ��ͼ׼��,x_avg�ֶ�
x_avg=zeros(length(X),length(x(end,:))*2);
i6=1;%������
%i7=1;%�����е���㣬length(x{end,i5})+i7-1Ϊ�е��յ�
for i5=1:length(x(end,:))%���ָ���Ϊx(end,:)�����и��ο�ʼ��ͽ��������غ�
    avg1(i5)=mean(x{end,i5});
    x_avg(flag1(i5):flag1(i5+1),i6)=x{end,i5};%flag1��ʱ���Ⱥ�˳�����򡣷����x���зָ�
    x_avg(flag1(i5):flag1(i5+1),i6+1)=avg1(i5);
    i6=i6+2;
end
%% ��ͼ׼����ALLT_����,��Ҫ�ҳ�ALLT��Ӧ��ʱ��
%% ��flag1���и��ģ���ɰ��ָ��Ⱥ�˳������flag2
%x���Ⱦ���
x_length=zeros(size(x));%x����Ԫ���Ⱦ���
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
%����flag2
flag2=zeros(length(flag1)-1,1);
flag2(1)=length(X);
i15=2;
for i16=2:a
      b=cellfun('isempty',x(i16,:));
      d=e-sum(b);%��ÿ��x�еķǿվ�����Ŀ����������
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
%     d=e-sum(b);%��ÿ��x�еķǿվ�����Ŀ����������
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
flag2(1)=[];%�õ���˳��������и��flag2
%% ��AllT���������Է���oringal�У�AllT�ǰ��и�˳��������flag2��Ӧ
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
%x�м��У���˵�����˼��Σ�ÿ��һ�Σ���һ���ϵ��һ��T������֮��Ӧ��x-ALLT-ALLTMAX-ALLPTMAX-FLAG-flag1��Ӧ
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

    
    






