%% Load Data
stim = csvread('valid_stim.csv',1,0);
stim_index = csvread('valid_index.csv',1,0);
response = csvread('valid_v1.csv',1,0);
locations = csvread('v1_locations.csv',1,0);

%% Look at some images
for i=1:12
    imagesc(reshape(stim(i,:),[128,128]))
    colormap gray  
    axis image
    pause() 
end

%% PART A
image_A=53; % princess
image_B=52; % frog

figure;
subplot(1,2,1)
imagesc(reshape(stim(53,:),[128,128]))
axis image
colormap gray
axis off
title('The Princess')
subplot(1,2,2)
imagesc(reshape(stim(52,:),[128,128]))
axis image
colormap gray
axis off
title('The Frog')

% Get the responses
image_A_responses=response(100,stim_index==image_A);
image_B_responses=response(100,stim_index==image_B);
estimated_diff=abs(mean(image_A_responses)-mean(image_B_responses));

% Assuming the responses are independent, the variances add
std_diff=sqrt(std(image_A_responses)^2+std(image_B_responses)^2)/sqrt(13);
p_value=2*cdf('t', -estimated_diff/std_diff, 24);
Conf_int_upper=estimated_diff+2*std_diff;
Conf_int_lower=estimated_diff+2*std_diff;

% Compare to MATLAB built in
[~,p,ci,stats]=ttest2(image_A_responses, image_B_responses)

% Visualize
figure;
boxplot([image_A_responses' image_B_responses'])
title('Princess Responses(1) versus Frog Responses(2)')

figure;
stem(image_A_responses-image_B_responses-estimated_diff)
title('Residuals')

% There definitely is a difference between the distributions, but due to
% the overlap, it would be very hard to distinguish without many repeats.

%% PART B
for i=13:24
    imagesc(reshape(stim(i,:),[128,128]))
    colormap gray
    axis image
    pause() 
end

% Two groups
dark=[17 18 20 21 23 24];
light=[13 14 15 16 19 22];

%%
group_A_responses=response(100,ismember(stim_index,dark));
group_B_responses=response(100,ismember(stim_index,light));

estimated_diff=abs(mean(group_A_responses)-mean(group_B_responses));

% Assuming the responses are independent, the variances add
std_diff=sqrt(std(group_A_responses)^2+std(group_B_responses)^2)/sqrt(78);
p_value=2*cdf('t', -estimated_diff/std_diff, 154);
Conf_int_upper=estimated_diff+2*std_diff;
Conf_int_lower=estimated_diff+2*std_diff;

% Compare to MATLAB built in
[~,p,ci,stats]=ttest2(group_A_responses, group_B_responses)
%%

boxplot([group_A_responses' group_B_responses'])

%% Calculate the STA!
% need validation data to do this

% Load validation data
load('Data/EstimatedResponses.mat');
load('Data/Stimuli.mat');

% Figure out the equivalent pixel
V1=roiS1==1;
count=0;
idx=0;
while count<100
    idx=idx+1;
    count=count+V1(idx);
end
resp=dataTrnS1(idx, :);

% Calulate the STA
STA=zeros(1,128,128);
stim_avg=zeros(1,128,128);
for i=1:length(resp)
    STA=STA+resp(i)*stimTrn(i,:,:);
    stim_avg=stim_avg+stimTrn(i,:,:);
end

% Plot STA
subplot(1,2,1)
colormap gray
imagesc(squeeze(stim_avg))
axis image
axis off
title('Average Stimulus')

subplot(1,2,2)
colormap gray
imagesc(squeeze(STA))
axis image
axis off

% find and plot center of RF
[a,b]=max(abs(STA));
[~,x]=max(a);
y=b(x);
clear a b

hold on
plot(x, y,'r*')
title('Receptive Field of Voxel 100');

%% Now that we have RF of voxel, try to pick two very different images
clear resp
STA=reshape(STA,128,128);
for i=1:120
    resp(i)=sum(sum(squeeze(stimVal(i,:,:)).*squeeze(STA)));
end
[~,image_A]=max(resp);
[~,image_B]=min(resp);

% Get the responses
image_A_responses=response(100,stim_index==image_A);
image_B_responses=response(100,stim_index==image_B);
abs(mean(image_A_responses)-mean(image_B_responses))

% MATLAB built in
[~,p,ci,stats]=ttest2(image_A_responses, image_B_responses)

% Visualize
boxplot([image_A_responses' image_B_responses'])

% Test all 120 images
p=zeros(120);
est_diff=zeros(120);
rec_diff=zeros(120);
for image_A=1:120
    for image_B=1:120
        image_A_responses=response(100,stim_index==image_A);
        image_B_responses=response(100,stim_index==image_B);
        [~,p(image_A,image_B),~,~]=ttest2(image_A_responses, image_B_responses);
        rec_diff(image_A,image_B)=abs(mean(image_A_responses)-mean(image_B_responses));
        est_diff(image_A,image_B)=abs(sum(sum(squeeze(stimVal(image_A,:,:)).*squeeze(STA)))-sum(sum(squeeze(stimVal(image_B,:,:)).*squeeze(STA))));
    end
end

%% Calculate a slice

image_A=7; % princess
image_B=2; % frog

slice=33;
idx=find(locations(:,1)==slice);

x_range=max(locations(idx,2));
y_range=min(locations(idx,3));

p_slice=zeros(x_range,y_range);

for i=1:length(idx)
    image_A_responses=response(idx(i),stim_index==image_A);
    image_B_responses=response(idx(i),stim_index==image_B);
    [~,p_slice(locations(idx(i),2),locations(idx(i),3)),~,~]=ttest2(image_A_responses, image_B_responses);
end

imagesc(p_slice(min(locations(idx,2)):end,min(locations(idx,3)):end))
colormap gray

%% TRY FOR 3D BECAUSE

image_A=3; % princess
image_B=6; % frog

p_slice=zeros(length(locations),1);

for i=1:length(locations)
    image_A_responses=response(i,stim_index==image_A);
    image_B_responses=response(i,stim_index==image_B);
    [~,p_slice(i),~,~]=ttest2(image_A_responses, image_B_responses);
end

scatter3(locations(:,1),locations(:,2),locations(:,3), exp(5-p_slice*5), p_slice,'filled')

%% Lets make a video of 3D responses over time 
volume=zeros(64,64,64);
for i=1:length(locations)
    volume(locations(i,1),locations(i,2),locations(i,3))=1;
end
p=isosurface(volume,0.99);
patch(p,'FaceAlpha',0.2,'EdgeColor','none')
axis equal
hold on
for i=1:1560
    s=scatter3(locations(:,2),locations(:,1),locations(:,3),15+exp(response(:,i)),response(:,i),'filled');
    view(i,20)
    camlight
    axis off
    set(gcf,'color','w');
    pause(0.01)
    F(i)=getframe(gcf);
    delete(s)
end
movie2avi(F,'brainactivity');

%% Calculate the STA!
% really need validation data to do this

% Calulate the STA
STA=zeros(1,128*128);
stim_avg=zeros(1,128*128);
for i=1:length(response)
    STA=STA+response(100,i)*stim(stim_index(i),:,:);
    stim_avg=stim_avg+stim(stim_index(i),:,:);
end

% Plot STA
subplot(1,2,1)
colormap gray
imagesc(reshape(stim_avg, 128,128))
axis image
axis off
title('Average Stimulus')

subplot(1,2,2)
colormap gray
imagesc(reshape(STA, 128,128))
axis image
axis off

% find and plot center of RF
[a,b]=max(abs(STA));
[~,x]=max(a);
y=b(x);
clear a b

hold on
plot(x, y,'r*')
title('Receptive Field of Voxel 100');

%% Lets make a video of 3D responses over time 
volume=zeros(64,64,64);
for i=1:length(locations)
    volume(locations(i,1),locations(i,2),locations(i,3))=1;
end
p=isosurface(volume,0.99);
patch(p,'FaceAlpha',0.2,'EdgeColor','none')
axis equal
hold on

image_A=52; % princess
image_B=53; % frog

for i=1:length(locations)
    image_A_responses=response(i,stim_index==image_A);
    image_B_responses=response(i,stim_index==image_B);
    [~,p_slice(i),~,~]=ttest2(image_A_responses, image_B_responses);
end
sig_indices=p_slice<0.1;
scatter3(locations(sig_indices,2),locations(sig_indices,1),locations(sig_indices,3), 1000*(0.1-p_slice(sig_indices)), p_slice(sig_indices),'filled')
axis off
set(gcf,'color','w');
axis equal
colorbar
colormap hot

for i=1:100
    view(3*i,20)
    camlight
    pause(0.01)
    F(i)=getframe(gcf);
end
movie2avi(F,'pvalue');
