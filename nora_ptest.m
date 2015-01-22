clear; clc;
load results.mat

fit_types={'SPM','HRFfit','GLS'};
p=zeros(3,13,13);

for fit=1:3
    eval(['amps=results.' fit_types{fit} '.amps;']);
    for image_A=1:13
        image_A_responses=amps(results.images==image_A);
        for image_B=1:image_A
            image_B_responses=amps(results.images==image_B);
            [~,p(fit,image_A,image_B),~,~]=ttest2(image_A_responses, image_B_responses);
        end
    end
end

clear image_A image_B image_A_responses image_B_responses fit

%% figure
figure;

subplot(2,3,1)
scatter(results.images, results.SPM.amps,'.');
xlim([0,13.5])
ylim([-5 5])
title('Fixed HRF')
xlabel('Image')
ylabel('Fit Event Amplitude')

subplot(2,3,2)
scatter(results.images, results.HRFfit.amps,'.');
xlim([0,13.5])
ylim([-5 5])
title('Fitted HRF')

subplot(2,3,3)
scatter(results.images, results.GLS.amps,'.');
xlim([0,13.5])
ylim([-5 5])
title('GLS')

p1=p(1,:,:);
p2=p(2,:,:);
p3=p(3,:,:);

subplot(2,3,4)
scatter(p1(:),p2(:),'k.');
hold on;
plot([0 1],[0.05,0.05]);
plot([0.05,0.05],[0 1]);
xlim([0,0.4])
ylim([0,0.4])
xlabel('Fixed HRF')
ylabel('Fitted HRF')
axis square

subplot(2,3,5)
scatter(p1(:),p3(:),'k.');
hold on;
plot([0 1],[0.05,0.05]);
plot([0.05,0.05],[0 1]);
xlim([0,0.4])
ylim([0,0.4])
xlabel('Fixed HRF')
ylabel('GLS')
axis square

subplot(2,3,6)
scatter(p2(:),p3(:),'k.');
hold on;
plot([0 1],[0.05,0.05]);
plot([0.05,0.05],[0 1]);
xlim([0,0.4])
ylim([0,0.4])
xlabel('Fitted HRF')
ylabel('GLS')
axis square







