function [ hrf_params, stim_amps, yhat, rsse, const ] = fit_amps_hrf_resid( y, hrf_params, stim_block, nits, l2p_a ,l2p,l2p_r )
% fits timuli and amplitudes for HRF signal
% Inputs:
%  - hrf_params, initial parameters for HRF signal
%  - stim_block, stimuli assignments
%  - nits, number of iterations
%  - l2p_a, L2 penalty for amplitudes
%  - l2p, L2 penalty for HRF
%  - l2p, L2 penalty for resid
% Outputs:
%  - hrf_params, initial parameters for HRF signal
%  - stim_amps, amplitudes for the stimuli
%  - const, constant term
%  - yhat: predicted signal
%  - rsse: root sum of squares residual to signal

len_hrf = length(hrf_params);
stim_amps = fit_amps( y, hrf_params, stim_block);
yhat = pred_signal( hrf_params, stim_block, stim_amps, 0 );
rsse = norm(y - yhat)
for ii=2:nits;
    hrf_params = fit_hrf_resid( y, stim_block, stim_amps, len_hrf, l2p, l2p_r);
    [stim_amps, const] = fit_amps_resid( y, hrf_params, stim_block, l2p_a, l2p_r);
    yhat = pred_signal( hrf_params, stim_block, stim_amps, const );
    rsse = norm(y - yhat)
    {stim_amps(13),rsse}
end

end

