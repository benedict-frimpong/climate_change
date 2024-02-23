%This script runs a time series data analysis tool for tide gauge data

%Import data from csv file
waterlevel=csvread('CO-OPS__8594900__hr.csv',1,1,[1,1,8401,1]);

base=mean(waterlevel); %set baseline for comparison
massbalance=sum(waterlevel-base); %sum of all data compared to baseline should be close to zero

sizedata=size(waterlevel);
lengthdata=sizedata(1); %determine number of datapoints

anchors=zeros(lengthdata,1);

for i=2:1:lengthdata
    if waterlevel(i-1,1)<=base %if previous datapoint is below base
        if waterlevel(i,1)>base %if current datapoint is above base
            %negative to positive shift
            anchors(i,1)=1; %record type 1 anchor
        end
    else
        if waterlevel(i,1)<base %if current datapoint is below base
            %positive to negative shift
            anchors(i,1)=2; %record type 2 anchor
        end
    end
end

list=find(anchors(:,1)==1); %create a list of all type 1 anchors
sizelist=size(list);
massbalance=zeros(sizelist(1),1);
totalmass=zeros(sizelist(1),4);
for i=2:1:sizelist(1) %cycle through list
    mass=waterlevel(list(i-1,1):list(i,1),1); %pull datapoints between type 1 anchors
    massbalance(i,1)=mean(mass-base); %calculate mass balance
    totalmass(i,1)=sum(abs(mass-base).^2); %calculate total mass
    totalmass(i,2)=list(i-1,1);
    totalmass(i,3)=list(i,1);
    totalmass(i,4)=sum(mass-base);
end
% wateraverage=zeros(lengthdata,1);
% for i=337:1:lengthdata-336
%     wateraverage(i,1)=mean(waterlevel(i-336:i+336,1));
% end