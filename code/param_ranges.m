clear all;
N=25;       % Number of Banks
p=0.2;     % probability of any two Banks being connected (unidirectional)
gamma=0.05;  % net worth as a percentage of total assets
theta=0.5;  % percentage of interbank assets in total assets
E=1000;     % total external assets of banking system (do we need that?)
S=200;      % Shock size
s=1;        % Initialy shocked bank


TRIALS=200; %independent runs with same parameters
PARAMVALS=30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta0=theta;
if(true)
    arr_theta_ = linspace(0.01,0.5,PARAMVALS);
    TESTS=length(arr_theta_); %different parameter configurations

    results=zeros(1,PARAMVALS);
    tic;
    for param_idx=1:PARAMVALS
        theta=arr_theta_(param_idx);
        sumF=0;
        for trial=1:TRIALS
            [B, a, e, i, c, d, b, w] = generate_banks(N, p, gamma, theta, E);
            F = simulate(B, a, e, i, c, d, b, w, S, s);
            sumF=sumF+F;
        end
        results(param_idx)=sumF/TRIALS;
    end
    toc
    plot(arr_theta_,results-1);
    title(strcat('Expected number of defaulting banks(apart from the inital one); ',sprintf('N=%d,p=%.2f,gamma=%.2f,theta=..',N,p,gamma)));
    xlabel('theta');ylabel('Number of defaults')
    results_theta=results;
end
theta=theta0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gamma0=gamma;
if(false)
    theta=theta0;
    results=zeros(1,PARAMVALS);
    arr_gamma_ = linspace(0.01,0.2,PARAMVALS);
    TESTS=length(arr_gamma_); %different parameter configurations
    tic;
    for param_idx=1:PARAMVALS
        gamma=arr_gamma_(param_idx);
        sumF=0;
        for trial=1:TRIALS
            [B, a, e, i, c, d, b, w] = generate_banks(N, p, gamma, theta, E);
            F = simulate(B, a, e, i, c, d, b, w, S, s);
            sumF=sumF+F;
        end
        results(param_idx)=sumF/TRIALS;
    end
    toc
    plot(arr_gamma_,results-1);
    title(strcat('Expected number of defaulting banks(apart from the inital one); ',sprintf('N=%d,p=%.2f,gamma=..,theta=%.2f',N,p,theta)));
    xlabel('gamma');ylabel('Number of defaults')
    results_gamma=results;
end
gamma=gamma0;