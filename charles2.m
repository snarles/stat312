%% 

load('vox100stuff.mat');
%%

sel_vox = vox100s;
ind = 1;
cur_block = vox100s{ind};
stim_block_12 = seqVal(:,ind); % there are 12 stimuli
nt = length(cur_block); % total number of time points, 696
ns = nt/4; % total number of stimuli, 174
sub_stim_block = stim_block(-3 + 4*(1:ns)); 
sub_stim_block(sub_stim_block ==0) = 13; % assign a new factor for the zero signal
stim_block_13 = stim_block_12;
stim_block_13(-3 + 4*(1:ns)) = sub_stim_block;
%%

len_hrf = 30; % number of points to include in the HRF
stim_block = stim_block_13;

%% test the functions


hrf_params = randn(len_hrf,1);
stim_amps = randn(13,1);
y = pred_signal( hrf_params, stim_block, stim_amps );
hrf_params2 = fit_hrf( y, stim_block, stim_amps, len_hrf );
stim_amps2 = fit_amps( y, hrf_params, stim_block);

figure; scatter(stim_amps,stim_amps2)
figure; scatter(hrf_params,hrf_params2)

{norm(stim_amps - stim_amps2), norm(hrf_params-hrf_params2)}


%% test stuff

hrf_params = randn(len_hrf,1);
stim_amps = randn(13,1);
hmat = hrf_mat(hrf_params, nt);
stmat = stim_mat(stim_block_13);
%%
y = cur_block;
design_amps = hmat * stmat;
stim_amps = lsqr(design_amps,y);
yhat = design_amps * stim_amps;
%%

ta = stmat * stim_amps;
