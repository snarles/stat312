function [stim_amps, yhat] = fit_amps( y, hrf_params, stim_block)
% fit amplitudes given fixed HRF function
% Inputs:
%  - y, MRI signal
%  - hrf_params, parameters for HRF signal
%  - stim_block, stimuli assignments
% Outputs:
%  - stim_amps, amplitudes for the stimuli
nt = length(y);
hmat = hrf_mat(hrf_params, nt);
stmat = stim_mat(stim_block);
design_amps = hmat * stmat;
stim_amps = lsqr(design_amps,y);
yhat = design_amps * stim_amps;

end

