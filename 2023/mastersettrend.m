function [mastersetAerror,residualtrend1A,residualtrend2A,residualtrendR2A,mastersetBerror,residualtrend1B,residualtrend2B,residualtrendR2B]=mastersettrend(data,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth,masterkeyA,masterkeyB)
    
    %find length of anchors
    anchorsize=size(anchors);
    anchorlength=anchorsize(1);
    
    %Initialize arrays
    mastersetAerror=zeros(2000,12);
    residualtrend1A=zeros(2000,2);
    residualtrend2A=zeros(2000,3);
    residualtrendR2A=zeros(2000,3);

    mastersetBerror=zeros(2000,12);
    residualtrend1B=zeros(2000,2);
    residualtrend2B=zeros(2000,3);
    residualtrendR2B=zeros(2000,3);
    
    
    %Calculation of error and linear trend of residuals
    %calculate masterset error
    k1=0;
    k2=0;
    for i = 1:anchorlength
        for j=1:12
            if setwidth(i,1)==j
                if anchors(i,2)==1
                    k1=k1+1;
                    for m=1:j
                        if mastersetA(k1, m) == 0
                            %starting point will have no error
                            mastersetAerror(k1, m) = 0;
                        else
                            %compare each data point to the corresponding point in the master set
                            mastersetAerror(k1, m) = mastersetA(k1, m) - masterkeyA(j, m);
                        end
                    end
                    
                    %check for masterkey match
                    sstot=sum((masterkeyA(j,1:j)-mean(masterkeyA(j,1:j))).^2);
                    ssres=sum((masterkeyA(j,1:j)-mastersetA(k1,1:j)).^2);
                    residualtrendR2A(k1,1)=1-(ssres/sstot);
    
                    %check for linear trend in residuals
                    residualtrend1A(k1,:)=polyfit(1:j,mastersetAerror(k1,1:j),1);
    
                    %calculate R squared value
                    polydata=polyval(residualtrend1A(k1,:),1:j);
                    sstot=sum((masterkeyA(j,1:j)-mean(masterkeyA(j,1:j))).^2);
                    ssres=sum((masterkeyA(j,1:j)-(mastersetA(k1,1:j)-polydata)).^2);
                    residualtrendR2A(k1,2)=1-(ssres/sstot);
    
                    %check for quadratic trend in residuals
                    %residualtrend2A(k1,:)=polyfit(1:j,mastersetAerror(k1,1:j),2);
    
                    %calculate R squared value
                    %polydata=polyval(residualtrend2A(k1,:),1:j);
                    %sstot=sum((masterkeyA(j,1:j)-mean(masterkeyA(j,1:j))).^2);
                    %ssres=sum((masterkeyA(j,1:j)-(mastersetA(k1,1:j)-polydata)).^2);
                    %residualtrendR2A(k1,3)=1-(ssres/sstot);
                    
                elseif anchors(i,2)==2
                    k2=k2+1;
                    for m=1:j
                        if mastersetB(k2, m) == 0
                            %starting point will have no error
                            mastersetBerror(k2, m) = 0;
                        else
                            %compare each data point to the corresponding point in the master set
                            mastersetBerror(k2, m) = mastersetB(k2, m) - masterkeyB(j, m);
                        end
                    end
                    %check for masterkey match
                    sstot=sum((masterkeyB(j,1:j)-mean(masterkeyB(j,1:j))).^2);
                    ssres=sum((masterkeyB(j,1:j)-mastersetB(k2,1:j)).^2);
                    residualtrendR2B(k2,1)=1-(ssres/sstot);
    
                    %check for linear trend in residuals
                    residualtrend1B(k2,:)=polyfit(1:j,mastersetBerror(k2,1:j),1);
    
                    %calculate R squared value
                    polydata=polyval(residualtrend1B(k2,:),1:j);
                    sstot=sum((masterkeyB(j,1:j)-mean(masterkeyB(j,1:j))).^2);
                    ssres=sum((masterkeyB(j,1:j)-(mastersetB(k2,1:j)-polydata)).^2);
                    residualtrendR2B(k2,2)=1-(ssres/sstot);
    
                    %check for quadratic trend in residuals
                    %residualtrend2B(k2,:)=polyfit(1:j,mastersetBerror(k2,1:j),2);
    
                    %calculate R squared value
                    %polydata=polyval(residualtrend2B(k2,:),1:j);
                    %sstot=sum((masterkeyB(j,1:j)-mean(masterkeyB(j,1:j))).^2);
                    %ssres=sum((masterkeyB(j,1:j)-(mastersetB(k2,1:j)-polydata)).^2);
                    %residualtrendR2B(k2,3)=1-(ssres/sstot);  
                end
            end
        end
    end
    mastersetAerror(k1+1:2000,:)=[];
    residualtrend1A(k1+1:2000,:)=[];
    residualtrend2A(k1+1:2000,:)=[];
    residualtrendR2A(k1+1:2000,:)=[];

    mastersetBerror(k2+1:2000,:)=[];
    residualtrend1B(k2+1:2000,:)=[];
    residualtrend2B(k2+1:2000,:)=[];
    residualtrendR2B(k2+1:2000,:)=[];
end