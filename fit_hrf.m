function hrf_params = fit_hrf( y, stim_block, stim_amps )
% fit amplitudes given fixed HRF function
% Inputs:
%  - y, MRI signal
%  - stim_amps, amplitudes for the stimuli
%  - stim_block, stimuli assignments
% Outputs:
%  - hrf_params, parameters for HRF signal

nt = length(y);
stmat = stim_mat(stim_block);
ta = stmat * stim_amps;
design_hrf = hrf_mat(ta, nt);
hrf_params = lsqr(design_hrf,y);


end

