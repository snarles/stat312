%% 

load('vox100stuff.mat');
load('spm_hrf_01');
%%
plot(spm_hrf_01)
%%

% First question: how to deal with the "null" signal and also
% the first 6 "calibration" signals? (for a single block)
% 
% A: Treat the "null" signal (the one that occurs at the time
% you would expect a stimuli) as the "13th" stimuli.
% Treat the first 6 calibration as "14"th to "19"th stimuli.

sel_vox = vox100s;
ind = 6;
cur_block = sel_vox{ind};
stim_block_12 = seqVal(:,ind);
stim_block_12(stim_block_12 > 0) = stim_block_12(stim_block_12 > 0)- (ind-1)*12; % there are 12 stimuli
nt = length(cur_block); % total number of time points, 696
ns = nt/4; % total number of stimuli, 174
sub_stim_block = stim_block_12(-3 + 4*(1:ns)); 
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
stim_amps = 1.*randn(max(stim_block),1)+1;
const = 10.0*randn(1);
y = pred_signal( hrf_params, stim_block, stim_amps, const );
hrf_params2 = fit_hrf_l2( y, stim_block, stim_amps, len_hrf, 1000 );
stim_amps2 = fit_amps_l2( y, hrf_params, stim_block, 10);

figure; scatter(stim_amps,stim_amps2)
figure; plot(hrf_params); hold on; plot(hrf_params2,'r')

{norm(stim_amps - stim_amps2), norm(hrf_params-hrf_params2)}


%% fit data


y0 = sel_vox{ind};
y = y0 -resid_corr;
const.off = 5.5; % chosen so that stim_amps(13) ~~ 0
y = y - const.off; 
len_hrf = 20;
hrf_params = spm_hrf_01(-9+ 10*(1:len_hrf));
nits = 30;
[ hrf_params, stim_amps, yhat, rsse ] = fit_amps_hrf( y, hrf_params, stim_block, nits );
{const,stim_amps(13),rsse, norm(stim_amps)}
figure; plot(stim_amps)
figure; plot(hrf_params)

%% fit data with auto constant

y0 = sel_vox{ind};
y = y0 -resid_corr;
len_hrf = 30;
hrf_params = spm_hrf_01(-9+ 10*(1:len_hrf));
nits = 20;
l2p_a = 0.01*ones(1,max(stim_block));
%l2p_a(13) = 100;
l2p = 100;
[ hrf_params, stim_amps, yhat, rsse ,const ] = fit_amps_hrf_l2( y, hrf_params, stim_block, nits, l2p_a ,l2p );
{const,stim_amps(13),rsse, norm(stim_amps)}

figure; plot(stim_amps)
figure; plot(hrf_params)

%% effect of each event

spm_params = spm_hrf_01(-9+ 10*(1:len_hrf));
[event_amps, yhat] = fit_amps_l2( y, spm_params, stim_block_all,l2p_a(1));
figure; scatter(sub_stim_block, event_amps); hold on; plot([12.5,12.5],[-10,10])

[event_amps, yhat] = fit_amps_l2( y, hrf_params, stim_block_all,l2p_a(1));
figure; plot(event_amps)
figure; scatter(sub_stim_block, event_amps)

%% residuals

resd = y - yhat;
resids = smooth(resd, .1, 'lowess');
figure; plot(resd); hold on; plot(resids, 'r')
resid_corr = resids;

%% GLS

resd = y - yhat;
basis_mat = gp_eigenfuncs(nt,.1);
basis_mat = basis_mat(:,1:10);
eps = 0.01;
nits = 200;
covmat = gp_cov_est(resd,basis_mat,eps,nits);
L = chol(covmat,'lower');
%% look at a sample drawn from estimated cov matrix
zsynth = L*randn(nt,1);
plot(zsynth); hold on; plot(smooth(zsynth, .1, 'lowess'),'r')
%% get whitening matrix

[e,v] = eig(covmat);
whtmat = e*diag(1./sqrt(diag(v)))*e';


%% fit the model

[event_amps, yhat] = fit_amps_l2_wht( y, hrf_params, stim_block_all,l2p_a(1),whtmat);
figure; plot(event_amps)
figure; scatter(sub_stim_block, event_amps)