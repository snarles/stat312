function spike_times=generate_Poisson(lambda, time)
    % Homogeneous case
    if length(lambda) == 1
        spike_times = cumsum(-log(rand(ceil((time+10)*lambda),1))/lambda);
        spike_times = spike_times(spike_times<time);
    % Inhomogeneous
    else
        disp('Add inhomogeneous generation next')
    end

end