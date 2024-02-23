%This script runs a time series data analysis tool for tide gauge data

%Import data from csv file
% waterlevel=csvread('CO-OPS__8594900__hr.csv',1,1,[1,1,8401,1]);
% 
% sizedata=size(waterlevel);
% lengthdata=sizedata(1);
% 
% data=zeros(lengthdata,4);
% data(:,1)=waterlevel(:,1);

waterlevel1=csvread('CO-OPS__8594900__hr1980.csv',1,1,[1,1,8401,1]);
waterlevel2=csvread('CO-OPS__8594900__hr2000.csv',1,1,[1,1,8401,1]);
waterlevel3=csvread('CO-OPS__8594900__hr.csv',1,1,[1,1,8401,1]);

waterlevel=zeros(8400*3,1);
waterlevel(1:8400,1)=waterlevel1;
waterlevel(8401:16800,1)=waterlevel2;
waterlevel(16801:25200,1)=waterlevel3;

sizedata=size(waterlevel);
lengthdata=sizedata(1);

data=zeros(lengthdata,4);
data(:,1)=waterlevel(:,1);

[anchors,anchor1data,anchor2data,data]=minmaxanchors(data);
%[anchors,anchor1data,anchor2data]=minmaxanchors2(waterlevel);
[mastersetA,mastersetB,setwidth]=mastersetgeneration(data,anchors,anchor1data,anchor2data);
[masterkeyA,masterkeyB]=masterkeygeneration(data,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth);
[mastersetAerror,residualtrends1A,residualtrend2A,residualtrendR2A,mastersetBerror,residualtrends1B,residualtrend2B,residualtrendR2B]=mastersettrend(data,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth,masterkeyA,masterkeyB);

% %Linear Trend Analysis
% [anchors2,anchor1data2,anchor2data2]=minmaxanchors(residualtrends1A(:,1));
% [mastersetA2,mastersetB2,setwidth2]=mastersetgeneration(residualtrends1A(:,1),anchors2,anchor1data2,anchor2data2);
% [masterkeyA2,masterkeyB2]=masterkeygeneration(residualtrends1A(:,1),anchors2,anchor2data2,anchor2data2,mastersetA2,mastersetB2,setwidth2);
% [mastersetAerror2,residualtrends1A2,residualtrend2A2,residualtrendR2A2,mastersetBerror2,residualtrends1B2,residualtrend2B2,residualtrendR2B2]=mastersettrend(residualtrends1A(:,1),anchors2,anchor1data2,anchor2data2,mastersetA2,mastersetB2,setwidth2,masterkeyA2,masterkeyB2);

%anchorpoint analysis

%  [anchors2,anchor1data2,anchor2data2]=minmaxanchors(anchor2data);
% [mastersetA2,mastersetB2,setwidth2]=mastersetgeneration(anchor2data,anchors2,anchor1data2,anchor2data2);
% [masterkeyA2,masterkeyB2]=masterkeygeneration(anchor2data,anchors2,anchor2data2,anchor2data2,mastersetA2,mastersetB2,setwidth2);
% [mastersetAerror2,residualtrends1A2,residualtrend2A2,residualtrendR2A2,mastersetBerror2,residualtrends1B2,residualtrend2B2,residualtrendR2B2]=mastersettrend(anchor2data,anchors2,anchor1data2,anchor2data2,mastersetA2,mastersetB2,setwidth2,masterkeyA2,masterkeyB2);

% %anchorpoint analysis 2
%  [anchors3,anchor1data3,anchor2data3]=minmaxanchors(anchor2data2);
% [mastersetA3,mastersetB3,setwidth3]=mastersetgeneration(anchor2data2,anchors3,anchor1data3,anchor2data3);
% [masterkeyA3,masterkeyB3]=masterkeygeneration(anchor2data2,anchors3,anchor1data3,anchor2data3,mastersetA3,mastersetB3,setwidth3);
% [mastersetAerror3,residualtrends1A3,residualtrend2A3,residualtrendR2A3,mastersetBerror3,residualtrends1B3,residualtrend2B3,residualtrendR2B3]=mastersettrend(anchor2data2,anchors3,anchor1data3,anchor2data3,mastersetA3,mastersetB3,setwidth3,masterkeyA3,masterkeyB3);
% 
% %anchorpoint analysis 3
% [anchors4,anchor1data4,anchor2data4]=minmaxanchors(anchor2data3);
% [mastersetA4,mastersetB4,setwidth4]=mastersetgeneration(anchor2data3,anchors4,anchor1data4,anchor2data4);
% [masterkeyA4,masterkeyB4]=masterkeygeneration(anchor2data3,anchors4,anchor1data4,anchor2data4,mastersetA4,mastersetB4,setwidth4);
% [mastersetAerror4,residualtrends1A4,residualtrend2A4,residualtrendR2A4,mastersetBerror4,residualtrends1B4,residualtrend2B4,residualtrendR2B4]=mastersettrend(anchor2data3,anchors4,anchor1data4,anchor2data4,mastersetA4,mastersetB4,setwidth4,masterkeyA4,masterkeyB4);