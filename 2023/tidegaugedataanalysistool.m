%This script runs a time series data analysis tool for tide gauge data

%Initialize arrays
waterlevel=zeros(8400,1);
anchors=zeros(2000,2);
mastersetA=zeros(2000,10);
mastersetAerror=zeros(2000,10);
mastersetAposerror=zeros(2000,1);
mastersetAnegerror=zeros(2000,1);
masterkeyA=zeros(1,10);
residualtrend1=zeros(2000,2);
residualtrend2=zeros(2000,3);
residualtrendR2=zeros(2000,3);
setwidth=zeros(2000,1);

anchor1level=zeros(2000,1);
anchor2level=zeros(2000,1);
anchortrend1=zeros(2000,2);
anchortrend2=zeros(2000,3);
anchortrendR2=zeros(2000,2);
sumanchor1=0;
sumanchor2=0;
anchormid=0.62;
anchors2=zeros(2000,2);
mastersetB=zeros(2000,10);
masterkeyB=zeros(1,10);

%Import data from csv file
waterlevel=csvread('CO-OPS__8594900__hr.csv',1,1,[1,1,8401,1]);

%Extract minimums and maximums
j=0;
j1=0;
j2=0;
for i = 1:8400
    %needs a continuity check
    %needs a normalization because observation will likely miss actual min/max
        
    %min/max check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if i >= 3
        if waterlevel(i, 1) - waterlevel(i - 1, 1) > 0
            if waterlevel(i - 1, 1) - waterlevel(i - 2, 1) < 0
                %minimum located
                j = j + 1;
                j1=j1+1;
                anchors(j, 1) = i - 1;
                anchors(j, 2) = 1;
                anchor1level(j1,1)=waterlevel(i-1,1);
                if anchor1level(j1,1)<anchormid
                    sumanchor1=sumanchor1+anchor1level(j1,1)-anchormid;
                end
            elseif waterlevel(i - 1, 1) - waterlevel(i - 2, 1) == 0
                %zero slope located
                if i >= 4
                    if waterlevel(i - 2, 1) - waterlevel(i - 3, 1) < 0
                        %minimum located
                        j = j + 1;
                        j1=j1+1;
                        anchors(j, 1) = i - 1;
                        anchors(j, 2) = 1;
                        anchor1level(j1,1)=waterlevel(i-1,1);
                        if anchor1level(j1,1)<anchormid
                            sumanchor1=sumanchor1+anchor1level(j1,1)-anchormid;
                        end
                    end
                end
            end
        elseif waterlevel(i, 1) - waterlevel(i - 1, 1) < 0
            if waterlevel(i - 1, 1) - waterlevel(i - 2, 1) > 0
                %maximum located
                j = j + 1;
                j2=j2+1;
                anchors(j, 1) = i - 1;
                anchors(j, 2) = 2;
                anchor2level(j2,1)=waterlevel(i-1,1);
                if anchor2level(j2,1)>anchormid
                    sumanchor2=sumanchor2+anchor2level(j2,1)-anchormid;
                end
            elseif waterlevel(i - 1, 1) - waterlevel(i - 2, 1) == 0
                %zero slope located
                if i >= 4
                    if waterlevel(i - 2, 1) - waterlevel(i - 3, 1) > 0
                        %maximum located
                        j = j + 1;
                        j2=j2+1;
                        anchors(j, 1) = i - 1;
                        anchors(j, 2) = 2;
                        anchor2level(j2,1)=waterlevel(i-1,1);
                        if anchor2level(j2,1)>anchormid
                            sumanchor2=sumanchor2+anchor2level(j2,1)-anchormid;
                        end
                    end
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%min to max master keys identification///////////////////////////////////////////////////////////////////
%gather min to max master set
k = 0;
for i = 1:j
    if anchors(i, 2) == 1
        if i < j
            setwidth(i,1) = anchors(i + 1, 1) - anchors(i, 1) + 1;
            if setwidth(i,1)==6
                k = k + 1;
%                  if k==29
%                      anchors(i,1)
%                  elseif k==201
%                      anchors(i,1)
%                  elseif k==315
%                      anchors(i,1)
%                  end
                for m = 1:setwidth(i,1)
                    if m == 1
                        mastersetA(k, m) = 0;
                    else
                        %compare each data point to the start of the set
                        mastersetA(k, m) = waterlevel(anchors(i, 1) + m - 1, 1) - waterlevel(anchors(i, 1), 1);
                    end
                    masterkeyA(1, m) = masterkeyA(1, m) + mastersetA(k, m);
                end
            end
        end
    end
end

%create masterkey
for i = 1:10
    masterkeyA(1, i) = masterkeyA(1, i) / k;
end

%Calculation of error and linear trend of residuals
%calculate masterset error
for i = 1:k
   %cycle through each set in the masterset
    for m = 1:6
        %cycle through each data point in the set
        if m > 1
            if mastersetA(i, m) == 0
                %starting point will have no error
                mastersetAerror(i, m) = 0;
            else
                %compare each data point to the corresponding point in the master set
                mastersetAerror(i, m) = mastersetA(i, m) - masterkeyA(1, m);
            end
        else
            mastersetAerror(i, m) = mastersetA(i, m) - masterkeyA(1, m);
        end
        if mastersetAerror(i, m) > 0
            mastersetAposerror(i, 1) = mastersetAposerror(i, 1) + mastersetAerror(i, m);
        else
            mastersetAnegerror(i, 1) = mastersetAnegerror(i, 1) + mastersetAerror(i, m);
        end
    end

    %check for masterkey match
    sstot=sum((masterkeyA(1,1:6)-mean(masterkeyA(1,1:6))).^2);
    ssres=sum((masterkeyA(1,1:6)-mastersetA(i,1:6)).^2);
    residualtrendR2(i,1)=1-(ssres/sstot);
    
    %check for linear trend in residuals
    residualtrend1(i,:)=polyfit(1:6,mastersetAerror(i,1:6),1);
    
    %calculate R squared value
    polydata=polyval(residualtrend1(i,:),1:6);
    %sstot=sum((mastersetAerror(i,1:6)-mean(mastersetAerror(i,1:6))).^2);
    %ssres=sum((mastersetAerror(i,1:6)-polydata).^2);
    sstot=sum((masterkeyA(1,1:6)-mean(masterkeyA(1,1:6))).^2);
    ssres=sum((masterkeyA(1,1:6)-(mastersetA(i,1:6)-polydata)).^2);
    residualtrendR2(i,2)=1-(ssres/sstot);
    
    %check for quadratic trend in residuals
    residualtrend2(i,:)=polyfit(1:6,mastersetAerror(i,1:6),2);
    
    %calculate R squared value
    polydata=polyval(residualtrend2(i,:),1:6);
    %sstot=sum((mastersetAerror(i,1:6)-mean(mastersetAerror(i,1:6))).^2);
    %ssres=sum((mastersetAerror(i,1:6)-polydata).^2);
    sstot=sum((masterkeyA(1,1:6)-mean(masterkeyA(1,1:6))).^2);
    ssres=sum((masterkeyA(1,1:6)-(mastersetA(i,1:6)-polydata)).^2);
    residualtrendR2(i,3)=1-(ssres/sstot);
end

%Analysis of trend in anchorpoints%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=5:j1
%     anchortrend1(i,:)=polyfit(1:5,anchor1level(i-4:i,1),1);
%     
%     %calculate R squared value
%     polydata=polyval(anchortrend1(i,:),1:5);
%     sstot=sum((anchor1level(i-4:i,1)-mean(anchor1level(i-4:i,1))).^2);
%     ssres=sum((anchor1level(i-4:i,1)-polydata').^2);
%     anchortrendR2(i,1)=1-(ssres/sstot);
%     
%     anchortrend2(i,:)=polyfit(1:5,anchor1level(i-4:i,1),2);
%     
%     %calculate R squared value
%     polydata=polyval(anchortrend2(i,:),1:5);
%     sstot=sum((anchor1level(i-4:i,1)-mean(anchor1level(i-4:i,1))).^2);
%     ssres=sum((anchor1level(i-4:i,1)-polydata').^2);
%     anchortrendR2(i,2)=1-(ssres/sstot);
% end

anchortrend=polyfit(1:j1,anchor2level(1:j1,1),1);
polydata=polyval(anchortrend,1:j1);
sstot=sum((anchor2level(1:j1,1)-mean(anchor2level(1:j1))).^2);
ssres=sum((anchor2level(1:j1,1)-polydata').^2);
trendR2=1-(ssres/sstot);

[anchors,anchor1data,anchor2data]=minmaxanchors(waterlevel);
[mastersetA,mastersetB,setwidth]=mastersetgeneration(waterlevel,anchors,anchor1data,anchor2data);
[masterkeyA,masterkeyB]=masterkeygeneration(waterlevel,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth);
[mastersetAerror,residualtrends1A,residualtrend2A,residualtrendR2A,mastersetBerror,residualtrends1B,residualtrend2B,residualtrendR2B]=mastersettrend(waterlevel,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth,masterkeyA,masterkeyB);