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
stim_block_all = stim_block_12;
stim_block_all(-3 + 4*(1:ns)) = 1:ns;

%%

len_hrf = 30; % number of points to include in the HRF
stim_block = stim_block_13;
resid_corr = 0.*cur_block;
%% test the functions


hrf_params = randn(len_hrf,1);
stim_amps = randn(max(stim_block),1);
const = 100*randn(1);
y = pred_signal( hrf_params, stim_block, stim_amps, const );
hrf_params2 = fit_hrf_l2( y, stim_block, stim_amps, len_hrf, 1 );
stim_amps2 = fit_amps_l2( y, hrf_params, stim_block, 1);

figure; scatter(stim_amps,stim_amps2)
figure; plot(hrf_params); hold on; plot(hrf_params2,'r')

{norm(stim_amps - stim_amps2), norm(hrf_params-hrf_params2)}


%% fit data


y0 = sel_vox{5};
y = y0 -resid_corr;
const.off = 5.2; % chosen so that stim_amps(13) ~~ 0
y = y - const.off; 
len_hrf = 30;
hrf_params = spm_hrf_01(-9+ 10*(1:len_hrf));
nits = 30;
[ hrf_params, stim_amps, yhat, rsse ] = fit_amps_hrf( y, hrf_params, stim_block, nits );
{const,stim_amps(null_ind),rsse, norm(stim_amps)}
figure; plot(stim_amps)
figure; plot(hrf_params)

%% fit data with auto constant

y0 = sel_vox{5};
y = y0 -resid_corr;
len_hrf = 30;
hrf_params = spm_hrf_01(-9+ 10*(1:len_hrf));
nits = 20;
l2p_a = 0.1*ones(1,max(stim_block));
%l2p_a(13) = 100;
l2p = 1000;
[ hrf_params, stim_amps, yhat, rsse ,const ] = fit_amps_hrf_l2( y, hrf_params, stim_block, nits, l2p_a ,l2p );
{const,stim_amps(13),rsse, norm(stim_amps)}

figure; plot(stim_amps)
figure; plot(hrf_params)

%% effect of each event

event_amps = fit_amps_l2( y, hrf_params, stim_block_all,l2p_a(1));
figure; plot(event_amps)
figure; scatter(sub_stim_block, event_amps)

%% residuals

resid = y - yhat;
resids = smooth(resid, .1, 'lowess');
figure; plot(resid); hold on; plot(resids, 'r')
resid_corr = resids;
