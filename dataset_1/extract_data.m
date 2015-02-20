cd ~/stat312/nifti/statweb.stanford.edu/~yuvalben/stat312/dataset_1/
addpath('NIfTI')

% Find voxel 100 
v1_locs = csvread('v1_locations.csv',1,0);

v100_loc = v1_locs(100,:)


first_block = load_nii('rawValidationData/Sub1_Ses1_Run1_Val.nii');
second_block = load_nii('rawValidationData/Sub1_Ses1_Run2_Val.nii');
third_block = load_nii('rawValidationData/Sub1_Ses2_Run1_Val.nii');
forth_block = load_nii('rawValidationData/Sub1_Ses2_Run2_Val.nii');
%%
imagesc(squeeze(first_block.img(:,21,:,20)));
%%
first_block_v100 = squeeze(first_block.img(v100_loc(1), v100_loc(2),  v100_loc(3),:));
plot(first_block_v100)

%%
load('rawValidationData/Stimuli.mat')
size(seqVal)
seqVal(:,1)

%%
blocks = cell(10);
block{ 1} = load_nii('rawValidationData/Sub1_Ses1_Run1_Val.nii');
block{ 2} = load_nii('rawValidationData/Sub1_Ses1_Run2_Val.nii');
block{ 3} = load_nii('rawValidationData/Sub1_Ses2_Run1_Val.nii');
block{ 4} = load_nii('rawValidationData/Sub1_Ses2_Run2_Val.nii');
block{ 5} = load_nii('rawValidationData/Sub1_Ses3_Run1_Val.nii');
block{ 6} = load_nii('rawValidationData/Sub1_Ses3_Run2_Val.nii');
block{ 7} = load_nii('rawValidationData/Sub1_Ses4_Run1_Val.nii');
block{ 8} = load_nii('rawValidationData/Sub1_Ses4_Run2_Val.nii');
block{ 9} = load_nii('rawValidationData/Sub1_Ses5_Run1_Val.nii');
block{10} = load_nii('rawValidationData/Sub1_Ses5_Run2_Val.nii');
%%
vox100s = cell(10);
for ind = 1:10;
    vox100s{ind} = squeeze(block{ind}.img(v100_loc(1), v100_loc(2),  v100_loc(3),:));
end
%%

plot(vox100s{5})
%%
cd ~/stat312/
save('vox100stuff.mat','vox100s','seqVal');
