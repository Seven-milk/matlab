%——————————————————————————————————————————
function [P_,C,p,p_emp,RMSE]=Peason_Type_III(data,varargin)
% p=mean;Cv=C(1);Cs=C(2);P_theory=分布值;p_emp为经验频率
% This Program was used to plot the Peason Type III (P-III) distrigution of

% the annnal max and min streamflows from 1979-2009

% Created by Ling Zhang, zhanglingky@lzb.ac.cn, CAREERI, 2015/4/16

%——————————————————————————————————————————

% We have tried three methods, namely lsqcurvefit, fmincon and Multistart, to fit the P-III

% curve. The results are same for both methods.

%——————————————————————————

 

% Annal max and min streamflow data extraction from 1979-2009





% Inital parameters calculation

n=length(data);

p=mean(data);

m=std(data); %s^2=[(x1-x)^2+(x2-x)^2+……(xn-x)^2]/（n-1）

Cv0=m/p;

Cs0=sum((data-p).^3)/((n-3)*m^3); %Cs, Coefficient of Skewness

A=4/Cs0^2;

% 计算不同频率的设计值

x=[0.01 0.05 0.5 1 2 5 10 20 30 40 50 60 70 80 90 95 98 99.5 99.9 99.99]; %units: %

for i=1:length(x)

tp1=gaminv(1-x(i)/100,A,1);

Z0(i)=((Cs0*tp1/2-2/Cs0)*Cv0+1)*p; % Resuls not optimizated

end

%计算经验频率

real_data=sort(data,'descend');%降序data

for i=1:n

p_emp(i)=length(find(real_data>=real_data(i)))/(n+1); % units: 1

end

 

% Prameters (Cv and Cs) Optimization适线

% fmincon
% tp_real=2*(real_data-p)/(p*Cv*Cs)+4/Cs^2;

% P_theory=1-gamcdf(tp,4/Cs^2,1);

% Object=sqrt(sum((P_theory’-p_real_data).^2)/n); % error evaluation

objectFun=@(C) sum(((1-gamcdf((2*(real_data-p)/(p*C(1)*C(2))+4/C(2)^2),4/C(2)^2,1))'-p_emp).^2); % Cv=C(1);Cs=C(2)

x0=[Cv0,Cs0];

A_ineq=[2 -1;0 2]; % refered to Jiyang Liang, 1986 水文评论曲线线型研究

b=[0;2];

C=fmincon(objectFun,x0,A_ineq,b);

 

% lsqcurvefit

objectFun=@(C,real_data) 1-gamcdf((2*(real_data-p)/(p*C(1)*C(2))+4/C(2)^2),4/C(2)^2,1); % Cv=C(1);Cs=C(2)

x0=[Cv0,Cs0];

xdata=real_data;

ydata=p_emp';

problem = createOptimProblem('lsqcurvefit','objective',objectFun,'xdata', xdata, 'ydata', ydata,'x0',x0,'lb', [0 0],'ub', [inf inf]);

% local optimization

C=lsqcurvefit(problem) ;

 

% Global optimization

ms = MultiStart;

C = run(ms, problem, 100);

 

% 计算不同频率的设计值 (Opitimizated results)

for i=1:length(x)

tp2=gaminv(1-x(i)/100,4/C(2)^2,1);

Z1(i)=((C(2)*tp2/2-2/C(2))*C(1)+1)*p; % Resuls optimizated

end

 

tp_real=2*(real_data-p)/(p*C(1)*C(2))+4/C(2)^2;

P_theory=1-gamcdf(tp_real,4/C(2)^2,1);

RMSE=sqrt(sum((P_theory'-p_emp).^2)/(n-1)); % error evaluation,均方根误差



% Another way to set normal frequency grids
% 
% y=norminv(x./100,0,1); %数据y所对应的正态分布的 X 值
% 
% % x./100 ia the requency
% 
% y=y-norminv(0.0001,0,1); % axis conversions (Theoritical frequency)
% 
% set(gca,'xtick',[],'xlim',[0 y(end)],'ylim',[0 ,1900]);%1900, max y axis which should chagne according to the observed data
% 
% set(gca,'xtick',y);
% 
% set(gca,'xticklabel',x);
% 
% grid on;
% 
% hold on;

 

% Plot results
% 
% yy=norminv(p_real_data,0,1); %数据p_real_data所对应的正态分布的 X 值
% 
% yy=yy-norminv(0.0001,0,1); % axis conversions (Emperical frequency)
% 
% plot(yy,real_data,'r*');
% 
% hold on;
% 
% plot(y,Z0,'g'); % Resuls not optimizated
% 
% hold on;
% 
% plot(y,Z1,'r'); % Resuls optimizated
% legend('原始数据','未优化的结果','优化的结果');
% 
% hold off;用spline
p_1=1-P_theory;
%删重复值
j=1;
num=[];
for i=1:(length(real_data)-1)
        if real_data(i)==real_data(i+1)||p_1(i)==p_1(i+1)
         num(j)=i;%需要找到重复值去掉（不论是x_还是pc_best_中的重复都需要找到）
         j=j+1;
        end
end
if isempty(num)==0
    real_data(num)=[];
    p_1(num)=[];
end
%插值求
P_=interp1(real_data,p_1,data);
  if nargin==2
       P_=interp1(real_data,p_1,varargin{1});
  end
end