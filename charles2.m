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


%% fit data

y0 = sel_vox{10};
y = y0 + 0.1*randn(696,1);
hrf_params = spm_hrf_01(-9+ 10*(1:30));
stim_amps = fit_amps( y, hrf_params, stim_block);
yh = pred_signal( hrf_params, stim_block, stim_amps );
{norm(y - yh),norm(y0-yh)}
%% -------- iteration
hrf_params = fit_hrf( y, stim_block, stim_amps, len_hrf );
stim_amps = fit_amps( y, hrf_params, stim_block);
yh = pred_signal( hrf_params, stim_block, stim_amps );
{norm(y - yh),norm(y0-yh)}

%%

figure; plot(stim_amps)
figure; plot(hrf_params)