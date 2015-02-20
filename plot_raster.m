function plot_raster(spikes, n_trials)
    for trial=1:n_trials
        plot(spikes{trial}, trial*ones(length(spikes{trial})),'.k')
    end
    ylim([0 n_trials+1])
    xlabel('Time')
    ylabel('Trials')
end