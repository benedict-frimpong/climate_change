%This script runs a time series data analysis tool for tide gauge data

%Import data from csv file
waterlevel=csvread('CO-OPS__8594900__hr.csv',1,1,[1,1,8401,1]);

[anchors,anchor1data,anchor2data]=minmaxanchors(waterlevel);
[mastersetA,mastersetB,setwidth]=mastersetgeneration(waterlevel,anchors,anchor1data,anchor2data);
[masterkeyA,masterkeyB]=masterkeygeneration(waterlevel,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth);
[mastersetAerror,residualtrends1A,residualtrend2A,residualtrendR2A,mastersetBerror,residualtrends1B,residualtrend2B,residualtrendR2B]=mastersettrend(waterlevel,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth,masterkeyA,masterkeyB);

%anchorpoint analysis

[anchors2,anchor1data2,anchor2data2]=minmaxanchors(anchor2data);
[mastersetA2,mastersetB2,setwidth2]=mastersetgeneration(anchor2data,anchors2,anchor1data2,anchor2data2);
[masterkeyA2,masterkeyB2]=masterkeygeneration(anchor1data,anchors2,anchor2data2,anchor2data2,mastersetA2,mastersetB2,setwidth2);
[mastersetAerror2,residualtrends1A2,residualtrend2A2,residualtrendR2A2,mastersetBerror2,residualtrends1B2,residualtrend2B2,residualtrendR2B2]=mastersettrend(anchor2data,anchors2,anchor1data2,anchor2data2,mastersetA2,mastersetB2,setwidth2,masterkeyA2,masterkeyB2);

%anchorpoint analysis 2
[anchors3,anchor1data3,anchor2data3]=minmaxanchors(anchor2data2);
[mastersetA3,mastersetB3,setwidth3]=mastersetgeneration(anchor2data2,anchors3,anchor1data3,anchor2data3);
[masterkeyA3,masterkeyB3]=masterkeygeneration(anchor2data2,anchors3,anchor1data3,anchor2data3,mastersetA3,mastersetB3,setwidth3);
[mastersetAerror3,residualtrends1A3,residualtrend2A3,residualtrendR2A3,mastersetBerror3,residualtrends1B3,residualtrend2B3,residualtrendR2B3]=mastersettrend(anchor2data2,anchors3,anchor1data3,anchor2data3,mastersetA3,mastersetB3,setwidth3,masterkeyA3,masterkeyB3);