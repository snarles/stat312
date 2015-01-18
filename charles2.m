%% 

load('vox100stuff.mat');
%%

sel_vox = vox100s;
ind = 1;
cur_block = vox100s{ind};
stim_block = seqVal(:,ind); % there are 12 stimuli
nt = length(cur_block); % total number of 
ns = n/4; % total number of stimuli
sub_stim_block = subsample(stim_block,4);
%%

len_hrf = 30;
