function [anchors,anchor1data,anchor2data]=minmaxanchors(data)
    %Initialize arrays
    anchors=zeros(2000,2);%index of anchor points in data
    anchor1data=zeros(2000,2);%minimums
    anchor2data=zeros(2000,2);%maximums
    
    %find length of data
    datasize=size(data);
    datalength=datasize(1);
    
    %Extract minimums and maximums
    j=0;
    j1=0;
    j2=0;
    for i = 1:datalength
        if i >= 3
            if data(i, 1) - data(i - 1, 1) > 0
                if data(i - 1, 1) - data(i - 2, 1) < 0
                    %minimum located
                    j = j + 1;
                    j1=j1+1;
                    anchors(j, 1) = i - 1;
                    anchors(j, 2) = 1;
                    anchor1data(j1,1)=data(i-1,1);
                    anchor1data(j1,2)=i-1;
                elseif data(i - 1, 1) - data(i - 2, 1) == 0
                    %zero slope located
                    if i >= 4
                        if data(i - 2, 1) - data(i - 3, 1) < 0
                            %minimum located
                            j = j + 1;
                            j1=j1+1;
                            anchors(j, 1) = i - 1;
                            anchors(j, 2) = 1;
                            anchor1data(j1,1)=data(i-1,1);
                            anchor1data(j1,2)=i-1;
                        end
                    end
                end
            elseif data(i, 1) - data(i - 1, 1) < 0
                if data(i - 1, 1) - data(i - 2, 1) > 0
                    %maximum located
                    j = j + 1;
                    j2=j2+1;
                    anchors(j, 1) = i - 1;
                    anchors(j, 2) = 2;
                    anchor2data(j2,1)=data(i-1,1);
                    anchor2data(j2,2)=i-1;
                elseif data(i - 1, 1) - data(i - 2, 1) == 0
                    %zero slope located
                    if i >= 4
                        if data(i - 2, 1) - data(i - 3, 1) > 0
                            %maximum located
                            j = j + 1;
                            j2=j2+1;
                            anchors(j, 1) = i - 1;
                            anchors(j, 2) = 2;
                            anchor2data(j2,1)=data(i-1,1);
                            anchor2data(j2,2)=i-1;
                        end
                    end
                end
            end
        end
    end

    %reduce arrays to actual length
    anchors(j+1:2000,:)=[];
    anchor1data(j1+1:2000,:)=[];
    anchor2data(j2+1:2000,:)=[];
end    