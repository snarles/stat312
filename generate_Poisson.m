function spikes=generate_Poisson(lambda, time)

    % Homogeneous case
    if length(lambda) == 1
        spike_times = cumsum(-log(rand(ceil((time+10)*lambda),1))/lambda);
        spike_times = spike_times(spike_times<time);
    % Spike histogram 
    bins=0.0005:0.001:time;
    spikes=hist(spike_times, bins);
    spikes(spikes~=0)=1;

    % Heterogeneous case
    else
        spikes=zeros(length(lambda), 1);
        lambda_max=1.2*max(lambda);
        for time=1:length(lambda)
            if rand() < lambda(time)/lambda_max;
                spikes(time)=1;
            end
        end
    end

end