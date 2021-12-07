function [CL,SN]= clusterhead_election(n,SN,SINK,t,tleft,CLheads,p)
    sinkx = SINK.x;
    sinky = SINK.y;
    for i=1:n
        SN(i).cluster=0;    % reseting cluster in which the node belongs to
        SN(i).role=0;       % reseting node role
        SN(i).chid=0;       % reseting cluster head id
        if SN(i).rleft>0
           SN(i).rleft=SN(i).rleft-1;
        end
        if (SN(i).E>0) && (SN(i).rleft==0)
            generate=rand;	
            if generate< t
                SN(i).role=1;	% assigns the node role of acluster head
                SN(i).rn=rand;	% Assigns the round that the cluster head was elected to the data table
                SN(i).tel=SN(i).tel + 1;   
                SN(i).rleft=1/p-tleft;    % rounds for which the node will be unable to become a CH
                SN(i).dts=sqrt((sinkx-SN(i).x)^2 + (sinky-SN(i).y)^2); % calculates the distance between the sink and the cluster hea
                CLheads=CLheads+1;	% sum of cluster heads that have been elected 
                SN(i).cluster=CLheads; % cluster of which the node got elected to be cluster head
                CL(CLheads).x=SN(i).x; % X-axis coordinates of elected cluster head
                CL(CLheads).y=SN(i).y; % Y-axis coordinates of elected cluster head
                CL(CLheads).id=i; % Assigns the node ID of the newly elected cluster head to an array
            end
        end
    end
end