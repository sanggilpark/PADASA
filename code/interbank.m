clear all;
N=25;       % Number of Banks
p=0.2;     % probability of any two Banks being connected (unidirectional)
gamma=0.05;  % net worth as a percentage of total assets
theta=0.5;  % percentage of interbank assets in total assets
E=1000;     % total external assets of banking system (do we need that?)
S=200;      % Shock size
s=1;        % Initialy shocked bank


TRIALS=400; %independent runs with same parameters
THETAS = linspace(0.01,0.5,TRIALS);
TESTS=length(THETAS); %different parameter configurations

sumF=0;
results=zeros(1,TRIALS);
tic;
for test=1:TESTS
    theta=THETAS(test);
    sumF=0;
    for trial=1:TRIALS
        [B, a, e, i, c, d, b, w] = generate_banks(N, p, gamma, theta, E);
        F = simulate(B, a, e, i, c, d, b, w, S, s);
        sumF=sumF+F;
    end
    results(test)=sumF/TRIALS;
end
toc
plot(THETAS,results-1);
title('Expected number of defaulting banks(apart from the inital one)')
