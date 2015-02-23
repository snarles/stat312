%% Homogeneous Poisson process

set(gca,'DefaultTextFontSize',18)
n_trials=100;
trial_length=1;

n_bins=1000*trial_length; % 1ms bins
plot_order=[6, 9, 8, 7, 4, 1, 2, 3];


for k=0:7
    
    % calculate the firing rate
    lambda=firing_rate(k*pi/4);
    
    % Generate the spike trains 
    spikes=zeros(n_bins, n_trials);
    for trial=1:n_trials
        spikes(:,trial)=generate_Poisson(lambda, 1);
    end
    
    % Plot the trials
    figure(1);
    subplot(3,3,plot_order(k+1))
    title(['s=' num2str(k) '\pi/4'])
    imagesc(spikes(:,1:5)'); colormap(flipud(gray));
    xlim([0 n_bins])
    ylim([0 6])
    set(gca,'XTick',[0 1000],'XTickLabel',[0 1])
    
    % Histogram
    figure(2);
    subplot(3,3,plot_order(k+1))
    tmp=reshape(conv(spikes(:), ones(20,1), 'same'), n_bins, n_trials);
    spike_hist = sum(tmp,2)/n_trials;
    stairs(spike_hist(10:20:end))
    ylim([0 1.5])
    
    % Tuning curve
    temp=sum(spikes);
    emp_firing_rate(k+1)=mean(temp);
    emp_var(k+1)=std(temp);
    
    % Count distribution
    figure(4);
    subplot(3,3,plot_order(k+1))
    [counts,centers] = hist(temp);
    lambda_hat=poissfit(temp);
    plot(centers, 2*poisspdf(round(centers),lambda_hat), 'k')
    hold on
    plot(centers, counts/(n_trials), 'r')
    hold off
    xlim([0 75])
    ylim([0 0.3])
    
    % ISI
    figure(6);
    subplot(3,3,plot_order(k+1))
    ISI=diff(find(spikes))/1000;
    mean_ISI(k+1)=mean(ISI);
    Cv_ISI(k+1)=std(ISI)/mean(ISI);
    [counts, centers] = hist(ISI);
    mu_hat=expfit(ISI);
    plot(centers, 2*exppdf(centers,mu_hat), 'k')
    hold on
    plot(centers, counts/(n_trials), 'r')
    hold off
    xlim([0 0.5])
    ylim([0 60])

end

% Tuning Curve
figure(3);
hold on
errorbar(emp_firing_rate, emp_var/sqrt(n_trials), 'r')
plot(firing_rate((0:7)*pi/4), 'k')
legend('Simulated Firing Rate', 'True Tuning Curve')
title('Tuning Curve')

% Fano Factor
figure(5);
hold on
scatter(emp_firing_rate, emp_var.^2)
plot([0 50],[0 50])
title('Mean Firing Rate vs. Variance')

% Coefficient of variation
figure(7)
subplot(1,2,1)
plot(mean_ISI)
ylim([0 0.12])

subplot(1,2,2)
plot(Cv_ISI)
hold on
plot([0 8],[1 1], 'k')
ylim([0.5 1.5])

%% Heterogeneous

% calculate the firing rate
time=0.001:0.001:1;
lambda=firing_rate(sqrt(time) * pi);

% Generate the spike trains
spikes=zeros(n_bins, n_trials);
for trial=1:n_trials
    spikes(:,trial)=generate_Poisson(lambda, 1);
end
imagesc(spikes(:,:)'); colormap(flipud(gray));

% Histogram
figure(8);
tmp=reshape(conv(spikes(:), ones(20,1), 'same'), n_bins, n_trials);
spike_hist = sum(tmp,2)/n_trials;
stairs(time(10:20:end), spike_hist(10:20:end), 'r')
hold on
plot(time(10:20:end), lambda(10:20:end)/3, 'k')
title('Spike Histogram')

% Count distribution
figure(9);
[counts,centers] = hist(temp);
lambda_hat=poissfit(temp);
plot(centers, 2*poisspdf(round(centers),lambda_hat), 'k')
hold on
plot(centers, counts/(n_trials), 'r')
hold off
title('Count Distribution')

% ISI
figure(10);
ISI=diff(find(spikes))/1000;
mean_ISI(k+1)=mean(ISI);
Cv_ISI(k+1)=std(ISI)/mean(ISI);
[counts, centers] = hist(ISI);
mu_hat=expfit(ISI);
plot(centers, 2*exppdf(centers,mu_hat), 'k')
hold on
plot(centers, counts/(n_trials), 'r')
hold off
title('ISI Distribution')

%% Real neural data






