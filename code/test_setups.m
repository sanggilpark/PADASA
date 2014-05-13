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
  % d = 1*N List of consumer deposits per bank
  % b = 1*N List of interbank borrowing per bank
  [F, d] = simulate(B, a, e, i, c, d, b, w, S, s);
  % F = number of failed banks
  % d = 1*N List of consumer deposits per bank at the end
  
  
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
Runs=100;
nFaults=zeros(Runs,nGamma);
lostDeposit=zeros(Runs,nGamma);
h=waitbar(0,'0%');
for gamma=1:nGamma
    for r=1:Runs
        [B,a,e,i,c,d,b,w]=generate_banks(N,p,Gamma(gamma),theta,E);
        faults=zeros(1,N);
        deposit=zeros(1,N);
        parfor s=1:N
            [faults(s), de]=simulate(B,a,e,i,c,d,b,w,S,s);
            deposit(s)=sum(de)/sum(d);
        end
        nFaults(r,gamma)=sum(faults)/N;
        lostDeposit(r,gamma)=1-sum(deposit)/N;
        waitbar(((gamma-1)*Runs+r)/nGamma/Runs,h,sprintf('%g%%',round(((gamma-1)*Runs+r)/nGamma/Runs*1000)/10));
    end
end
X=[Gamma,fliplr(Gamma)];
Y1=[max(nFaults),fliplr(min(nFaults))];
Y2=[max(lostDeposit),fliplr(min(lostDeposit))];

fill(X,Y1,[0.5 0.5 1]);
hold on;
plot(Gamma,sum(nFaults)/Runs,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('Percentage net worth');
ylabel('Number of defaults');
xlim([0 0.1]);
ylim([0 25]);
hold off;

figure;
fill(X,Y2,[0.5 0.5 1]);
hold on;
plot(Gamma,sum(lostDeposit)/Runs,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('Percentage net worth');
ylabel('Percentage lost consumer deposits');
xlim([0 0.1]);
ylim([0.03 0.1]);
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
Theta=0:0.01:0.5;
Gamma=[0.01 0.03 0.05];
nTheta=length(Theta);
nGamma=length(Gamma);
Runs=100;
nFaults=zeros(Runs,nTheta*nGamma);
lostDeposit=zeros(Runs,nTheta*nGamma);
h=waitbar(0,'0%');
for gamma=1:nGamma
    for theta=1:nTheta
        for r=1:Runs
            [B,a,e,i,c,d,b,w]=generate_banks(N,p,Gamma(gamma),Theta(theta),E);
            faults=zeros(1,N);
            deposit=zeros(1,N);
            parfor s=1:N
                [faults(s), de]=simulate(B,a,e,i,c,d,b,w,S,s);
                deposit(s)=1-sum(de)/sum(d);
            end
            nFaults(r,(gamma-1)*nTheta+theta)=sum(faults)/N;
            lostDeposit(r,(gamma-1)*nTheta+theta)=sum(deposit)/N;
            waitbar(((gamma-1)*nTheta*Runs+(theta-1)*Runs+r)/nGamma/nTheta/Runs,h,sprintf('%g%%',round(((gamma-1)*nTheta*Runs+(theta-1)*Runs+r)/nGamma/nTheta/Runs*1000)/10));
        end
    end
end
X=[Theta,fliplr(Theta)];
Y1=[max(nFaults(:,1:nTheta)),fliplr(min(nFaults(:,1:nTheta)))];
Y2=[max(nFaults(:,nTheta+(1:nTheta))),fliplr(min(nFaults(:,nTheta+(1:nTheta))))];
Y3=[max(nFaults(:,2*nTheta+(1:nTheta))),fliplr(min(nFaults(:,2*nTheta+(1:nTheta))))];
Y4=[max(lostDeposit(:,1:nTheta)),fliplr(min(lostDeposit(:,1:nTheta)))];
Y5=[max(lostDeposit(:,nTheta+(1:nTheta))),fliplr(min(lostDeposit(:,nTheta+(1:nTheta))))];
Y6=[max(lostDeposit(:,2*nTheta+(1:nTheta))),fliplr(min(lostDeposit(:,2*nTheta+(1:nTheta))))];

fill(X,Y1,[0.5 0.5 1]);
hold on;
fill(X,Y2,[0.5 1 0.5]);
fill(X,Y3,[1 0.5 0.5]);
pl=plot(Theta,sum(nFaults(:,1:nTheta))/Runs,Theta,sum(nFaults(:,nTheta+(1:nTheta)))/Runs,Theta,sum(nFaults(:,2*nTheta+(1:nTheta)))/Runs,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('Percentage interbank assets');
ylabel('Number of defaults');
legend(pl,'Net Worth 1%','Net Worth 3%','Net Worth 5%','Location','NorthWest');
xlim([0 0.5]);
ylim([0 25]);
hold off;

figure;
fill(X,Y4,[0.5 0.5 1]);
hold on;
fill(X,Y5,[0.5 1 0.5]);
fill(X,Y6,[1 0.5 0.5]);
pl=plot(Theta,sum(lostDeposit(:,1:nTheta))/Runs,Theta,sum(lostDeposit(:,nTheta+(1:nTheta)))/Runs,Theta,sum(nFaults(:,2*nTheta+(1:nTheta)))/Runs,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('Percentage interbank assets');
ylabel('Percentage lost consumer deposits');
legend(pl,'Net Worth 1%','Net Worth 3%','Net Worth 5%','Location','NorthWest');
xlim([0 0.5]);
ylim([0.03 0.2]);
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
Runs=100;
nFaults=zeros(Runs,nP*nGamma);
lostDeposit=zeros(Runs,nP*nGamma);
h=waitbar(0,'0%');
for gamma=1:nGamma
    for p=1:nP
        for r=1:Runs
            [B,a,e,i,c,d,b,w]=generate_banks(N,P(p),Gamma(gamma),theta,E);
            faults=zeros(1,N);
            deposit=zeros(1,N);
            parfor s=1:N
                [faults(s), de]=simulate(B,a,e,i,c,d,b,w,S,s);
                deposit(s)=1-sum(de)/sum(d);
            end
            nFaults(r,(gamma-1)*nP+p)=sum(faults)/N;
            lostDeposit(r,(gamma-1)*nP+p)=sum(deposit)/N;
            waitbar(((gamma-1)*nP*Runs+(p-1)*Runs+r)/nGamma/nP/Runs,h,sprintf('%g%%',round(((gamma-1)*nP*Runs+(p-1)*Runs+r)/nGamma/nP/Runs*1000)/10));
        end
    end
end
X=[P,fliplr(P)];
Y1=[max(nFaults(:,1:nP)),fliplr(min(nFaults(:,1:nP)))];
Y2=[max(nFaults(:,nP+(1:nP))),fliplr(min(nFaults(:,nP+(1:nP))))];
Y3=[max(nFaults(:,2*nP+(1:nP))),fliplr(min(nFaults(:,2*nP+(1:nP))))];
Y4=[max(lostDeposit(:,1:nP)),fliplr(min(lostDeposit(:,1:nP)))];
Y5=[max(lostDeposit(:,nP+(1:nP))),fliplr(min(lostDeposit(:,nP+(1:nP))))];
Y6=[max(lostDeposit(:,2*nP+(1:nP))),fliplr(min(lostDeposit(:,2*nP+(1:nP))))];

fill(X,Y1,[0.5 0.5 1]);
hold on;
fill(X,Y2,[0.5 1 0.5]);
fill(X,Y3,[1 0.5 0.5]);
pl=plot(P,sum(nFaults(:,1:nP))/Runs,P,sum(nFaults(:,nP+(1:nP)))/Runs,P,sum(nFaults(:,2*nP+(1:nP)))/Runs,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('Erdös-Rényi probability');
ylabel('Number of defaults');
legend(pl,'Net Worth 1%','Net Worth 3%','Net Worth 7%','Location','NorthWest');
xlim([0 1]);
ylim([0 25]);
hold off;

figure;
fill(X,Y4,[0.5 0.5 1]);
hold on;
fill(X,Y5,[0.5 1 0.5]);
fill(X,Y6,[1 0.5 0.5]);
pl=plot(P,sum(lostDeposit(:,1:nP))/Runs,P,sum(lostDeposit(:,nP+(1:nP)))/Runs,P,sum(lostDeposit(:,2*nP+(1:nP)))/Runs,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('Erdös-Rényi probability');
ylabel('Percentage lost consumer deposits');
legend(pl,'Net Worth 1%','Net Worth 3%','Net Worth 7%','Location','NorthWest');
xlim([0 1]);
ylim([0.03 0.1]);
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
Step=200;
Faults=zeros(1,Runs*N);
lostDeposit=zeros(1,Runs*N);
Size=Faults;
Outgoing=Faults;
h=waitbar(0,'0%');
for r=1:Runs
    [B,a,e,i,c,d,b,w]=generate_banks(N,p,gamma,theta,E);
    faults=zeros(1,N);
    deposit=zeros(1,N);
    parfor s=1:N
        [faults(s), de]=simulate(B,a,e,i,c,d,b,w,S,s);
        deposit(s)=1-sum(de)/sum(d);
    end
    a=round(a/Step)*Step;
    Faults(((r-1)*N+1):r*N)=faults;
    Size(((r-1)*N+1):r*N)=a;
    Outgoing(((r-1)*N+1):r*N)=round(i/w);
    lostDeposit(((r-1)*N+1):r*N)=deposit;
    waitbar(r/Runs,h,sprintf('%g%%',round(r/Runs*1000)/10));
end


boxplot(Faults,Size,'symbol','','labelorientation','inline');
set(gca,'FontSize',14);
xlabel('Total assets of the first bank (grouped)');
ylabel('Number of defaults');
ylim([0 25]);

figure;
boxplot(Faults,Outgoing,'symbol','');
set(gca,'FontSize',14);
xlabel('Outgoing links of the first bank');
ylabel('Number of defaults');
ylim([0 25]);

figure;
boxplot(lostDeposit,Size,'symbol','','labelorientation','inline');
set(gca,'FontSize',14);
xlabel('Total assets of the first bank (grouped)');
ylabel('Percentage lost consumer deposits');
ylim([0 0.1]);

figure;
boxplot(lostDeposit,Outgoing,'symbol','');
set(gca,'FontSize',14);
xlabel('Outgoing links of the first bank');
ylabel('Percentage lost consumer deposits');
ylim([0 0.1]);

figure;
boxplot(lostDeposit,Faults,'symbol','');
set(gca,'FontSize',14);
xlabel('Number of defaults');
ylabel('Percentage lost consumer deposits');
ylim([0 0.1]);

close(h);
matlabpool close;