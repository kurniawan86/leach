%% Area of Operation %%%
% Field Dimensions in meters %
border = 100;
x=0;        % added for better display results of the plot
y=0;        % added for better display results of the plot
n=100;      % Number of Nodes in the field %
dead_nodes=0;   % Number of Dead Nodes in the beggining %

%% Coordinates of the Sink (location is predetermined in this simulation) %
SINK.x=50;
SINK.y=200;

%% Energy Values %%%
Eo=2;   % Initial Energy of a Node (in Joules)

%% Energy required to run circuity (both for transmitter and receiver) %
Eelec=50*10^(-9); % units in Joules/bit
ETx=50*10^(-9); % units in Joules/bit
ERx=50*10^(-9); % units in Joules/bit

%% Transmit Amplifier Types %
Eamp=100*10^(-12); % units in Joules/bit/m^2 (amount of energy spent by the amplifier to transmit the bits)
% Data Aggregation Energy %
EDA=5*10^(-9); % units in Joules/bit
% Size of data package %
k=4000; % units in bits
% Suggested percentage of cluster head %
p=0.05; % a 5 percent of the total amount of nodes used in the network is proposed to give good results
% Number of Clusters %
No=p*n; 
% Round of Operation %
rnd=0;
% Current Number of operating Nodes %
operating_nodes=n;
transmissions=0;
temp_val=0;
flag1stdead=0;