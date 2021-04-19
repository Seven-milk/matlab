clc;
clear;
T=xlsread('shuju2008.xlsx','A1:A55');
X=xlsread('shuju2008.xlsx','L1:L55');
q=OptimalSegmentation( T,X );