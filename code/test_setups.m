% Test Setups
%% Example
clear all;
N=25;       % Number of Banks
p=0.25;     % probability of any two Banks being connected (unidirectional)
gamma=0.1;  % net worth as a percentage of total assets
theta=0.5;  % percentage of interbank assets in total assets
E=1000;     % total external assets of banking system (do we need that?)
S=200;      % Shock size
s=1;        % Initialy shocked bank

   % Perhabs any loop around it
[B, a, e, i, c, d, b,w] = generate_banks(N, p, gamma, theta, E);
  % B = N*N Array Bij = 1 -> connection from Bank i to j / 0 -> no connection 
  % a = 1*N List of total assets per bank
  % e = 1*N List of external assets per bank
  % i = 1*N List of interbank assets per bank
  % c = 1*N List of net worth per bank
  % d = 1*N List of customer deposits per bank
  % b = 1*N List of interbank borrowing per bank
  F = simulate(B, a, e, i, c, d, b, w, S, s);
  % F = number of failed banks
  
  
   %Summary/Calculations/Graph generation...


%% .....