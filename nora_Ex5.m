%% PART A
% Homogeneous Poisson process
set(gca,'DefaultTextFontSize',18)
n_trials=100;

for k=0 %:7
    
    % calculate the firing rate
    lambda=firing_rate(k*pi/4);
    
    % Generate the spike trains 
    for trial=1:n_trials
        spikes{trial}=generate_Poisson(lambda, 1);
    end
    
    % Plot the trials
    subplot(4,2,k+1)
    hold on
    title(['s=' num2str(k) '\pi/4'])
    plot_raster(spikes,5)
    
    % Spike histogram 
    bins=0.01:0.02:1;
    Spike_histogram=zeros(length(bins),1);
    for trial=1:n_trials
        Spike_histogram=Spike_histogram+hist(spike_trials{trial}, bins)';
    end
    Spike_histogram=Spike_histogram/n_trials;
    figure;
    plot(Spike_histogram)
    
    % Tuning curve
    emperical_firing_rate=zeros(n_trials,1);
    for trial=1:n_trials
        emperical_firing_rate(trial)=length(spike_trials{trial});
    end
    
end

