% Programmed by Taesam Lee,  Dec.03,2009
% INRS-ETE, Quebec, Canada
function [Z]=SPI(Data,scale,nseas)
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
erase_yr=ceil(scale/12);
% Data setting to scaled dataset
A1=[];
for is=1:scale, A1=[A1,Data(is:length(Data)-scale+is)];end
XS=sum(A1,2);

if(scale>1), XS(1:nseas*erase_yr-scale+1)=[];   end

for is=1:nseas
    tind=is:nseas:length(XS);
    Xn=XS(tind);
    [zeroa]=find(Xn==0);
    Xn_nozero=Xn;Xn_nozero(zeroa)=[];
    q=length(zeroa)/length(Xn);
    parm=gamfit(Xn_nozero);
    Gam_xs=q+(1-q)*gamcdf(Xn,parm(1),parm(2));
    Z(tind)=norminv(Gam_xs);
end

%Gamma parameter estimation and tranform