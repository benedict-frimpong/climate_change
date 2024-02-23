function [mastersetA,mastersetB,setwidth]=mastersetgeneration(data,anchors,anchor1data,anchor2data)
    %min to max master keys identification///////////////////////////////////////////////////////////////////
    
    %find length of anchors
    anchorsize=size(anchors);
    anchorlength=anchorsize(1);
    
    %Initialize arrays
    mastersetA=zeros(2000,12);%min to max trends
    mastersetB=zeros(2000,12);%max to min trends
    setwidth=zeros(anchorlength,1);%number of data points in each trend
    
    %gather min to max master A set
    k1 = 0;
    k2 = 0;
    
    for i = 1:anchorlength
        if anchors(i, 2) == 1
            if i < anchorlength
                setwidth(i,1) = anchors(i + 1, 1) - anchors(i, 1) + 1;
                k1 = k1 + 1;
                for m = 1:setwidth(i,1)
                    if m == 1
                        mastersetA(k1, m) = 0;
                    else
                        %compare each data point to the start of the set
                        mastersetA(k1, m) = data(anchors(i, 1) + m - 1, 1) - data(anchors(i, 1), 1);
                    end
                end
            end
        elseif anchors(i,2) == 2
            if i < anchorlength
                setwidth(i,1) = anchors(i + 1, 1) - anchors(i, 1) + 1;
                k2 = k2 + 1;
                for m = 1:setwidth(i,1)
                    if m == 1
                        mastersetB(k2, m) = 0;
                    else
                        %compare each data point to the start of the set
                        mastersetB(k2, m) = data(anchors(i, 1) + m - 1, 1) - data(anchors(i, 1), 1);
                    end
                end
            end
        end
    end
    
    %reduce arrays to actual length
    mastersetA(k1+1:2000,:)=[];
    mastersetB(k2+1:2000,:)=[];
end