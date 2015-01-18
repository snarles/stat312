%% 

load('vox100stuff.mat');
load('spm_hrf_01');
%%
plot(spm_hrf_01)
%%

sel_vox = vox100s;
ind = 2;
cur_block = sel_vox{ind};
stim_block_12 = seqVal(:,ind); % there are 12 stimuli
nt = length(cur_block); % total number of time points, 696
ns = nt/4; % total number of stimuli, 174
sub_stim_block = stim_block(-3 + 4*(1:ns)); 
sub_stim_block(sub_stim_block ==0) = 13; % assign a new factor for the zero signal
sub_stim_block(1:6) = 13 + (1:6); % assign new factors for the calibration signals
stim_block_13 = stim_block_12;
stim_block_13(-3 + 4*(1:ns)) = sub_stim_block;
%%

len_hrf = 30; % number of points to include in the HRF
stim_block = stim_block_13;

%% test the functions


hrf_params = randn(len_hrf,1);
stim_amps = randn(max(stim_block),1);
y = pred_signal( hrf_params, stim_block, stim_amps );
hrf_params2 = fit_hrf_l2( y, stim_block, stim_amps, len_hrf, 100 );
stim_amps2 = fit_amps( y, hrf_params, stim_block);

figure; scatter(stim_amps,stim_amps2)
figure; plot(hrf_params); hold on; plot(hrf_params2,'r')

{norm(stim_amps - stim_amps2), norm(hrf_params-hrf_params2)}


%% fit data


y0 = sel_vox{10};
y = y0 + 0.0*randn(696,1);
y = y - 5.4; % chosen so that stim_amps(13) ~~ 0
len_hrf = 30;
hrf_params = spm_hrf_01(-9+ 10*(1:len_hrf));
nits = 20;
l2p = 3000;
[ hrf_params, stim_amps, yhat, rsse ] = fit_amps_hrf( y, hrf_params, stim_block, l2p, nits );
figure; plot(stim_amps)
figure; plot(hrf_params)

%% effect of each event

fit_amps( y, hrf_params, stim_block)
