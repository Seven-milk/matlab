clc;
clear;
x=xlsread('shuju2008.xlsx','A1:A55'); 
y=xlsread('shuju2008.xlsx','L1:L55'); 
D=Cramert(y,x);