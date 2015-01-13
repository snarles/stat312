%% Load Data
stim = csvread('data/valid_stim.csv',1,0);
stim_index = csvread('data/valid_index.csv',1,0);
response = csvread('data/valid_v1.csv',1,0);

%% Look at some images

for i=1:12
    imagesc(reshape(stim(i,:),[128,128]))
    colormap gray
    axis image
    pause() 
end

%% PART A

% choose two images to compare responses
   image_A=53; % princess
   image_B=52; % frog
   image_A_responses=response(100,stim_index==image_A);
   image_B_responses=response(100,stim_index==image_B);
   estimated_diff=-abs(mean(image_A_responses)-mean(image_B_responses));
   % assuming the responses are independent, the variances add
   std_diff=sqrt(std(image_A_responses)^2+std(image_B_responses)^2)/sqrt(12);
   p_value=2*cdf('normal', estimated_diff, 0, std_diff)
   
% There doesn't seem to be a significant difference. 

%%
[h,p]=ttest2(image_A_responses, image_B_responses)


