function [hrf_params,const] = fit_hrf_l2( y, stim_block, stim_amps, len_hrf, l2p )
% fit amplitudes given fixed HRF function with L2 penalty
% Inputs:
%  - y, MRI signal
%  - stim_amps, amplitudes for the stimuli
%  - stim_block, stimuli assignments
%  - len_hrf, length of hrf
%  - l2p, L2 penalty
% Outputs:
%  - hrf_params, parameters for HRF signal
%  - const, constant term

nt = length(y);
stmat = stim_mat(stim_block);
ta = stmat * stim_amps;
design_hrf = hrf_mat(ta, nt);
design_hrf = design_hrf(:,1:len_hrf);
design_hrf = [ones(nt,1),design_hrf];
pmat = [zeros(len_hrf-1,1),[eye(len_hrf-1), zeros(len_hrf-1,1)] - [zeros(len_hrf-1,1), eye(len_hrf-1)]];
xty = design_hrf'*y;
xtx = design_hrf'*design_hrf + l2p*pmat'*pmat;
chrf_params = xtx\xty;
const = chrf_params(1);
hrf_params = chrf_params(2:(len_hrf+1));

end

