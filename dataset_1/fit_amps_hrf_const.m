function [ const, hrf_params, stim_amps, yhat, rsse ] = fit_amps_hrf_const( null_ind, period, y, hrf_params, stim_block, l2p, nits )
% fits timuli and amplitudes for HRF signal
% Inputs:
%  - null_ind, index of null signal
%  - period, number of intervals between stimuli
%  - y, fMRI data
%  - hrf_params, initial parameters for HRF signal
%  - stim_block, stimuli assignments
%  - l2p, L2 penalty
%  - nits, number of iterations
% Outputs:
%  - const, intercept term to make the null signal equal to zero
%  - hrf_params, initial parameters for HRF signal
%  - stim_amps, amplitudes for the stimuli
%  - yhat: predicted signal
%  - rsse: root sum of squares residual to signal
const = 0;
delta = mean(y)/2;
len_hrf = length(hrf_params);
stim_amps = fit_amps( y, hrf_params, stim_block);
yhat = pred_signal( hrf_params, stim_block, stim_amps );
rsse = norm(y - yhat)
for ii=2:nits;
    stn = stim_amps(null_ind);
    const = const +sign(stn)*sign(sum(hrf_params))  * delta/ii;
    hrf_params = fit_hrf_l2( y-const, stim_block, stim_amps, len_hrf, l2p );
    stim_amps = fit_amps( y-const, hrf_params, stim_block);
    yhat = pred_signal( hrf_params, stim_block, stim_amps ) + const;
    rsse = norm(y - yhat);
    {const,stim_amps(null_ind),rsse}
end

end

