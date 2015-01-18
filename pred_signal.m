function yhat = pred_signal( hrf_params, stim_block, stim_amps )
% predicts the fMRI signal
% Inputs:
%  - hrf_params, parameters for HRF signal
%  - stim_block, stimuli assignments
%  - stim_amps, amplitudes for the stimuli
% Outputs:
%  - yhat: predicted signal

nt = length(stim_block);
hmat = hrf_mat(hrf_params, nt);
stmat = stim_mat(stim_block);
design_amps = hmat * stmat;
yhat = design_amps * stim_amps;

end

