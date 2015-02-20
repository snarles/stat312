function [ hrf_params, stim_amps, yhat, rsse ] = fit_amps_hrf( y, hrf_params, stim_block, nits )
% fits timuli and amplitudes for HRF signal
% Inputs:
%  - hrf_params, initial parameters for HRF signal
%  - stim_block, stimuli assignments
%  - l2p, L2 penalty
%  - nits, number of iterations
% Outputs:
%  - hrf_params, initial parameters for HRF signal
%  - stim_amps, amplitudes for the stimuli
%  - yhat: predicted signal
%  - rsse: root sum of squares residual to signal

len_hrf = length(hrf_params);
stim_amps = fit_amps( y, hrf_params, stim_block);
yhat = pred_signal( hrf_params, stim_block, stim_amps, 0 );
rsse = norm(y - yhat)
for ii=2:nits;
    hrf_params = fit_hrf( y, stim_block, stim_amps, len_hrf);
    stim_amps = fit_amps( y, hrf_params, stim_block);
    yhat = pred_signal( hrf_params, stim_block, stim_amps,0 );
    rsse = norm(y - yhat)
end

end

