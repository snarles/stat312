%% PART A
% Homogeneous Poisson process
set(gca,'DefaultTextFontSize',18)
figure;

for k=0
    
    % calculate the firing rate
    lambda=firing_rate(k*pi/4);
    
    % Generate the spike trains 
    for trial=1:100
        spike_times = cumsum(-log(rand(ceil(2*lambda),1))/lambda);
        spike_trials{trial} = spike_times(spike_times<1);
    end
    
    % Plot the trials
    subplot(4,2,k+1)
    hold on
    title(['s=' num2str(k) '\pi/4'])
    for trial=1:5
        plot(spike_trials{trial}, trial*ones(length(spike_trials{trial})),'.k')
        ylim([0 6])
        xlim([0 1])
        xlabel('Time')
        ylabel('Trials')
    end
    
    % Spike histogram 
    bin_size=0.020;
    n_bins=1/bin_size;
    Binned_spikes=zeros(trials, n_bins);
    for trial=1:100
        a=floor(spike_trials{trial}/bin_size);
        Spike_hist=[Spike_hist a];
    end
    
end

