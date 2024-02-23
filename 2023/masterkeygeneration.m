function [masterkeyA,masterkeyB]=masterkeygeneration(data,anchors,anchor1data,anchor2data,mastersetA,mastersetB,setwidth)
    
    %find length of anchors
    anchorsize=size(anchors);
    anchorlength=anchorsize(1);
    
    %Initialize arrays
    masterkeyA=zeros(12,12);
    masterkeyB=zeros(12,12);
    k1=0;
    k2=0;
    countsA=zeros(12,1);
    countsB=zeros(12,1);
    for i = 1:anchorlength
        for j=1:12
            if setwidth(i,1)==j
                if anchors(i, 2) == 1
                    k1=k1+1;
                    countsA(j,1)=countsA(j,1)+1;
                    for m = 1:setwidth(i,1)
                        masterkeyA(j, m) = masterkeyA(j, m) + mastersetA(k1, m);
                    end
                elseif anchors(i,2) == 2
                    k2=k2+1;
                    countsB(j,1)=countsB(j,1)+1;
                    for m = 1:setwidth(i,1)
                        masterkeyB(j, m) = masterkeyB(j, m) + mastersetB(k2, m);
                    end
                end
            end
        end
    end
    
    %create masterkey
    for i = 1:12
        for j=1:12
            masterkeyA(i, j) = masterkeyA(i, j) / countsA(i,1);
            masterkeyB(i, j) = masterkeyB(i, j) / countsB(i,1);
        end
    end
end