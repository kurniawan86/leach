%this is main program for routing algorithm
clear;
clc;
close all;

%% set parameter 
N = 200;    % Number of nodes
W = 100;    % widht of the network
L = 100;    % lenght of the network
Ei = 2;     % initial Energy of each node (joules)
CHpl = 2000;% packet size for cluster head per round (bits)