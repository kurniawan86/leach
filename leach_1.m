%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

%%%%%%%%%%%%%%%%%%%% Network Establishment Parameters %%%%%%%%%%%%%%%%%%%%
initial % call initial.m
%%%%%%%%%%%%%%%%%%%%%%%%%%% End of Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Creation of the Wireless Sensor Network %%%
            
%% create Node
SN = create_node(n, border, Eo);

%% Plotting the WSN %
plot_WSN(n, border, SN, SINK)

%% set-up
                      %%%%%% Set-Up Phase %%%%%% 
sinkx = SINK.x;
sinky = SINK.y;
while operating_nodes>0
        
    % Displays Current Round %     
    rnd ;    
	% Threshold Value %
	t=(p/(1-p*(mod(rnd,1/p))));
    
    % Re-election Value %
    tleft=mod(rnd,1/p);
 
	% Reseting Previous Amount Of Cluster Heads In the Network %
	CLheads=0;
    
    % Reseting Previous Amount Of Energy Consumed In the Network on the Previous Round %
    energy=0;
        
    % Cluster Heads Election %
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
                CL(CLheads).id=i; % Assi gns the node ID of the newly elected cluster head to an array
            end
        end
    end
        
	% Fixing the size of "CL" array %
	CL=CL(1:CLheads);
   
% Grouping the Nodes into Clusters & caclulating the distance between node and cluster head %
     
       for i=1:n
        if  (SN(i).role==0) && (SN(i).E>0) && (CLheads>0) % if node is normal
            for m=1:CLheads
            d(m)=sqrt((CL(m).x-SN(i).x)^2 + (CL(m).y-SN(i).y)^2);
            % we calculate the distance 'd' between the sensor node that is
            % transmitting and the cluster head that is receiving with the following equation+ 
            % d=sqrt((x2-x1)^2 + (y2-y1)^2) where x2 and y2 the coordinates of
            % the cluster head and x1 and y1 the coordinates of the transmitting node
            end
        d=d(1:CLheads); % fixing the size of "d" array
        [M,I]=min(d(:)); % finds the minimum distance of node to CH
        [Row, Col] = ind2sub(size(d),I); % displays the Cluster Number in which this node belongs too
        SN(i).cluster=Col; % assigns node to the cluster
        SN(i).dtch= d(Col); % assigns the distance of node to CH
        SN(i).chid=CL(Col).id;
        end
       end
       
        
       
                           %%%%%% Steady-State Phase %%%%%%
                      
  
% Energy Dissipation for normal nodes %
    
    for i=1:n
       if (SN(i).cond==1) && (SN(i).role==0) && (CLheads>0)
       	if SN(i).E>0
            ETx= Eelec*k + Eamp * k * SN(i).dtch^2;
            SN(i).E=SN(i).E - ETx;
            energy=energy+ETx;
            
        % Dissipation for cluster head during reception
        if SN(SN(i).chid).E>0 && SN(SN(i).chid).cond==1 && SN(SN(i).chid).role==1
            ERx=(Eelec+EDA)*k;
            energy=energy+ERx;
            SN(SN(i).chid).E=SN(SN(i).chid).E - ERx;
             if SN(SN(i).chid).E<=0  % if cluster heads energy depletes with reception
                SN(SN(i).chid).cond=0;
                SN(SN(i).chid).rop=rnd;
                dead_nodes=dead_nodes +1;
                operating_nodes= operating_nodes - 1
             end
        end
        end
        
        
        if SN(i).E<=0       % if nodes energy depletes with transmission
        dead_nodes=dead_nodes +1;
        operating_nodes= operating_nodes - 1
        SN(i).cond=0;
        SN(i).chid=0;
        SN(i).rop=rnd;
        end
        
      end
    end            
    
    
    
% Energy Dissipation for cluster head nodes %
   
   for i=1:n
     if (SN(i).cond==1)  && (SN(i).role==1)
         if SN(i).E>0
            ETx= (Eelec+EDA)*k + Eamp * k * SN(i).dts^2;
            SN(i).E=SN(i).E - ETx;
            energy=energy+ETx;
         end
         if  SN(i).E<=0     % if cluster heads energy depletes with transmission
         dead_nodes=dead_nodes +1;
         operating_nodes= operating_nodes - 1
         SN(i).cond=0;
         SN(i).rop=rnd;
         end
     end
   end
   
  
    if operating_nodes<n && temp_val==0
        temp_val=1;
        flag1stdead=rnd
    end
    % Display Number of Cluster Heads of this round %
    %CLheads;
   
    
    transmissions=transmissions+1;
    if CLheads==0
    transmissions=transmissions-1;
    end
    
 
    % Next Round %
    rnd= rnd +1;
    
    tr(transmissions)=operating_nodes;
    op(rnd)=operating_nodes;
    
    if energy>0
    nrg(transmissions)=energy;
    end
    
end
sum=0;
for i=1:flag1stdead
    sum=nrg(i) + sum;
end
temp1=sum/flag1stdead;
temp2=temp1/n;
for i=1:flag1stdead
avg_node(i)=temp2;
end
    
    % Plotting Simulation Results "Operating Nodes per Round" %
    figure(2)
    plot(1:rnd,op(1:rnd),'-r','Linewidth',2);
    title ({'LEACH'; 'Operating Nodes per Round';})
    xlabel 'Rounds';
    ylabel 'Operational Nodes';
    hold on;
    
    % Plotting Simulation Results  %
    figure(3)
    plot(1:transmissions,tr(1:transmissions),'-r','Linewidth',2);
    title ({'LEACH'; 'Operational Nodes per Transmission';})
    xlabel 'Transmissions';
    ylabel 'Operational Nodes';
    hold on;
    
    % Plotting Simulation Results  %
    figure(4)
    plot(1:flag1stdead,nrg(1:flag1stdead),'-r','Linewidth',2);
    title ({'LEACH'; 'Energy consumed per Transmission';})
    xlabel 'Transmission';
    ylabel 'Energy ( J )';
    hold on;
    
    % Plotting Simulation Results  %
    figure(5)
    plot(1:flag1stdead,avg_node(1:flag1stdead),'-r','Linewidth',2);
    title ({'LEACH'; 'Average Energy consumed by a Node per Transmission';})
    xlabel 'Transmissions';
    ylabel 'Energy ( J )';
    hold on;