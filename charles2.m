%% 

load('vox100stuff.mat');
%%

sel_vox = vox100s;
ind = 1;
cur_block = vox100s{ind};
stim_block = seqVal(:,ind); % there are 12 stimuli
nt = length(cur_block); % total number of time points, 696
ns = nt/4; % total number of stimuli, 174
sub_stim_block = stim_block(-3 + 4*(1:ns)); 
sub_stim_block(sub_stim_block ==0) = 13; % assign a new factor for the zero signal
stim_block_13 = stim_block;
stim_block_13(-3 + 4*(1:ns)) = sub_stim_block;
%%

len_hrf = 30; % number of points to include in the HRF


%% test stuff

hrf_params = randn(1,len_hrf);
hmat = hrf_mat(hrf_params, nt);
