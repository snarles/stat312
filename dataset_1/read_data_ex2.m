
% Read data from first blockAnalyze matlab

addpath(genpath('/Users/Nora/Desktop/classes/data'))

% Find voxel 100 
v1_locs = csvread('v1_locations.csv',1,0);

v100_loc = v1_locs(100,:);


first_block = load_nii('rawValidationData/Sub1_Ses1_Run1_Val.nii');
second_block = load_nii('rawValidationData/Sub1_Ses1_Run2_Val.nii');
third_block = load_nii('rawValidationData/Sub1_Ses2_Run1_Val.nii');
forth_block = load_nii('rawValidationData/Sub1_Ses2_Run2_Val.nii');
% ...

% A picture of activity (from the top) in slice 21 after 20 seconds
% The V1 area is in the back side of the brain. 

imagesc(squeeze(first_block.img(:,21,:,20)))

% Now lets extract our voxel of interest: 
first_block_v100 = squeeze(first_block.img(v100_loc(1), v100_loc(2),  v100_loc(3),:));
plot(first_block_v100)
 
% load the shown stimuli sequence; we are looking for variable
% seqVal. Each column of seqVal shows the stimulus sequence for a
% separate block

load('rawValidationData/Stimuli.mat')
size(seqVal)

% So seqVal(:,1) matches the stimuli order of the first block. 
seqVal(:,1);

% To maintain a ballanced design, the first 6 stimuli in each block
% were discarded. 
stim_order_bl1 = seqVal(seqVal(:,1)>0,1);

figure; hist(stim_order_bl1,1:12)
figure; hist(stim_order_bl1(7:end),1:12)

