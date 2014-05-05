% Test Setups
%% Example

N=25;       % Number of Banks
p=0.25;     % probability of any two Banks being connected (unidirectional)
gamma=0.5;  % net worth as a percentage of total assets
theta=0.5;  % percentage of interbank assets in total assets
E=1000;     % total external assets of banking system (do we need that?)
S=200;      % Shock size
s=1;        % Initialy shocked bank

   % Perhabs any loop around it
[B, e, i, c, d, b] = generate_banks(N, p, gamma, theta, E);
  % B = N*N Array Bij = 1 -> connection from Bank i to j / 0 -> no connection 
  % e = N*1 List of external assets per bank
  % i = N*1 List of interbank assets per bank
  % c = N*1 List of net worth per bank
  % d = N*1 List of customer deposits per bank
  % b = N*1 List of interbank borrowing per bank
  
F = simulate(B, e, i, c, d, b, S, s);
  % F = number of failed banks
  
  
   %Summary/Calculations/Graph generation...


%% .....