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
[B, a, e, i, c, d, b, w] = generate_banks(N, p, gamma, theta, E);
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


%% Faults vs net worth
matlabpool('open',2);
clear all;
E=100000;
S=100000;
N=25;
p=0.2;
theta=0.2;
Gamma=0:0.001:0.1;
nGamma=length(Gamma);
Runs=50;
nFaults=zeros(Runs,nGamma);
h=waitbar(0,'0%');
for gamma=1:nGamma
    for r=1:Runs
        [B,a,e,i,c,d,b,w]=generate_banks(N,p,Gamma(gamma),theta,E);
        faults=zeros(1,N);
        parfor s=1:N
            faults(s)=simulate(B,a,e,i,c,d,b,w,S,s);
        end
        nFaults(r,gamma)=sum(faults)/N;
        waitbar(((gamma-1)*Runs+r)/nGamma/Runs,h,sprintf('%g%%',round(((gamma-1)*Runs+r)/nGamma/Runs*1000)/10));
    end
end
X=[Gamma,fliplr(Gamma)];
Y=[max(nFaults),fliplr(min(nFaults))];
fill(X,Y,[0.5 0.5 1]);
hold on;
plot(Gamma,sum(nFaults)/Runs);
hold off;
close(h);
matlabpool close;

%% Faults vs interbank assets
matlabpool('open',2);
clear all;
E=100000;
S=100000;
N=25;
p=0.2;
Theta=0:0.005:0.5;
gamma=0.05;
nTheta=length(Theta);
Runs=50;
nFaults=zeros(Runs,nTheta);
h=waitbar(0,'0%');
for theta=1:nTheta
    for r=1:Runs
        [B,a,e,i,c,d,b,w]=generate_banks(N,p,gamma,Theta(theta),E);
        faults=zeros(1,N);
        parfor s=1:N
            faults(s)=simulate(B,a,e,i,c,d,b,w,S,s);
        end
        nFaults(r,theta)=sum(faults)/N;
        waitbar(((theta-1)*Runs+r)/nTheta/Runs,h,sprintf('%g%%',round(((theta-1)*Runs+r)/nTheta/Runs*1000)/10));
    end
end
X=[Theta,fliplr(Theta)];
Y=[max(nFaults),fliplr(min(nFaults))];
fill(X,Y,[0.5 0.5 1]);
hold on;
plot(Theta,sum(nFaults)/Runs);
hold off;
close(h);
matlabpool close;

%% Faults vs p
matlabpool('open',2);
clear all;
E=100000;
S=100000;
N=25;
P=0:0.025:1;
theta=0.2;
Gamma=[0.01 0.03 0.07];
nP=length(P);
nGamma=length(Gamma);
Runs=50;
nFaults=zeros(Runs,nP*nGamma);
h=waitbar(0,'0%');
for gamma=1:nGamma
    for p=1:nP
        for r=1:Runs
            [B,a,e,i,c,d,b,w]=generate_banks(N,P(p),Gamma(gamma),theta,E);
            faults=zeros(1,N);
            parfor s=1:N
                faults(s)=simulate(B,a,e,i,c,d,b,w,S,s);
            end
            nFaults(r,(gamma-1)*nP+p)=sum(faults)/N;
            waitbar(((gamma-1)*nP*Runs+(p-1)*Runs+r)/nGamma/nP/Runs,h,sprintf('%g%%',round(((gamma-1)*nP*Runs+(p-1)*Runs+r)/nGamma/nP/Runs*1000)/10));
        end
    end
end
X=[P,fliplr(P)];
Y1=[max(nFaults(:,1:nP)),fliplr(min(nFaults(:,1:nP)))];
Y2=[max(nFaults(:,nP+(1:nP))),fliplr(min(nFaults(:,nP+(1:nP))))];
Y3=[max(nFaults(:,2*nP+(1:nP))),fliplr(min(nFaults(:,2*nP+(1:nP))))];
fill(X,Y1,[0.5 0.5 1]);
hold on;
fill(X,Y2,[0.5 1 0.5]);
fill(X,Y3,[1 0.5 0.5]);
plot(P,sum(nFaults(:,1:nP))/Runs,P,sum(nFaults(:,nP+(1:nP)))/Runs,P,sum(nFaults(:,2*nP+(1:nP)))/Runs);
hold off;
close(h);
matlabpool close;

%% Faults vs banksize
matlabpool('open',2);
clear all;
E=100000;
S=100000;
N=25;
p=0.2;
theta=0.2;
gamma=0.02;
Runs=10000;
Step=100;
Faults=zeros(1,Runs*N);
Size=Faults;
Outgoing=Faults;
Incoming=Faults;
h=waitbar(0,'0%');
for r=1:Runs
    [B,a,e,i,c,d,b,w]=generate_banks(N,p,gamma,theta,E);
    faults=zeros(1,N);
    parfor s=1:N
        faults(s)=simulate(B,a,e,i,c,d,b,w,S,s);
    end
    a=round(a/Step)*Step;
    Faults(((r-1)*N+1):r*N)=faults;
    Size(((r-1)*N+1):r*N)=a;
    Outgoing(((r-1)*N+1):r*N)=round(i/w);
    Incoming(((r-1)*N+1):r*N)=round(b/w);
    waitbar(r/Runs,h,sprintf('%g%%',round(r/Runs*1000)/10));
end

boxplot(Faults,Size);
figure;
boxplot(Faults,Outgoing);
figure;
boxplot(Faults,Incoming);
close(h);
matlabpool close;