function hrf_params = fit_hrf( y, stim_block, stim_amps, len_hrf )
% fit amplitudes given fixed HRF function
% Inputs:
%  - y, MRI signal
%  - stim_amps, amplitudes for the stimuli
%  - stim_block, stimuli assignments
%  - len_hrf, length of hrf
% Outputs:
%  - hrf_params, parameters for HRF signal

nt = length(y);
stmat = stim_mat(stim_block);
ta = stmat * stim_amps;
design_hrf = hrf_mat(ta, nt);
design_hrf = design_hrf(:,1:len_hrf);
hrf_params = lsqr(design_hrf,y);


end

