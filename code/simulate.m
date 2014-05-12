function [F,d] = simulate(B, a, e, i, c, d, b, w, S, s)
    % Simulation routine
    % B = N*N Array Bij = 1 -> connection from Bank i to j / 0 -> no connection 
    % a = 1*N List of total assets per bank
    % e = 1*N List of external assets per bank
    % i = 1*N List of interbank assets per bank
    % c = 1*N List of net worth per bank
    % d = 1*N List of customer deposits per bank
    % b = 1*N List of interbank borrowing per bank
    % S = 1*1 shock size
    % s = 1*1 shocked bank
    eps=1E-15;
    N=length(a);
    interbank_left=B*w;
    remaining_shocks=zeros(1,N);
    if(S>a(s))
        %disp(sprintf('WARNING: shock bigger than total assets, reducing: %s to: %s\n',num2str(S),num2str(a(s))));
        S=a(s);
    end
    remaining_shocks(s)=S;
    while (max(remaining_shocks)>eps)
        for s=1:length(remaining_shocks)
            if(remaining_shocks(s)>eps)
                prec=c;
                [i,c,d,remaining_shocks,interbank_left]=single_shock(a,c,s,d,i,interbank_left,remaining_shocks,w);
                post=c;
            end
        end
    end   
    F=sum(abs(c)<eps);
end

function [i,c,d,remaining_shocks,interbank_left]=single_shock(a,c,s,d,i,interbank_left,remaining_shocks,w)
    if(remaining_shocks(s)>a(s))
       error('Shock bigger than total assets!')
    end 
    %reduce net worth first
    [c(s),postnet_shock]=absorber(c(s),remaining_shocks(s));

    if (postnet_shock>0)  %default of first bank
        %after using all interbank connections the remainder hits depositors
        depositor_shock=max(0,postnet_shock-i(s));
        d(s)=d(s)-depositor_shock;

        interbank_shock=min(postnet_shock,i(s));
        i(s)=i(s)-interbank_shock;
        num_creditors=sum(interbank_left(s,:))/w;   %could be non, integer. interbank_left(s,:) or interbank_left(:,?)
        individual_interbank_shock=min(interbank_left(s,:),postnet_shock/num_creditors);
        interbank_left(s,:)=interbank_left(s,:)-individual_interbank_shock;
        [c,new_shocks]=absorber(c,individual_interbank_shock);
        remaining_shocks=remaining_shocks+new_shocks;
    end
    remaining_shocks(s)=0;
end
