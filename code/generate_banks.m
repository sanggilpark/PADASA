function [B, a, e, i, c, d, b, w] = generate_banks(N, p, gamma, theta, E)
% Function to generate values of the banking system

B = random_graph(N,p); % B = the unidirectional banking system Graph
                             % as N*N Array of 0 and 1

beta = 1-theta; % = percentage of external assets in total assets
A = E / beta;   % = total Assets
I = theta * A;  % = aggregate size of interbank exposures

Z = sum(sum(B));% = number of links
w = I / Z;      % = weight of any link, to define the interbank assets of a bank

i = sum(B,2)'* w; % = interbank assets per bank as number of outgoing links times the weight
b = sum(B,1) * w; % = interbank borrowing per bank as number of incoming links times the weight

% two steps to calculate e = external assets per bank
e = b - i;              % to fulfil e >= b - i
e = e + (E - sum(e))/N; % distribute the rest of E evenly among all banks

a = e + i;     % = Total assets per bank
c = gamma * a; % = Net worth per bank
d = a - c - b; % = consumer deposits per Bank
end
