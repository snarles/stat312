function [hrf_params,const] = fit_hrf_resid( y, stim_block, stim_amps, len_hrf, l2p, l2p_r )
% fit amplitudes given fixed HRF function with L2 penalty
% Inputs:
%  - y, MRI signal
%  - stim_amps, amplitudes for the stimuli
%  - stim_block, stimuli assignments
%  - len_hrf, length of hrf
%  - l2p, L2 penalty
%  - l2p_r, L2 penalty of residual
% Outputs:
%  - hrf_params, parameters for HRF signal
%  - const, residual

nt = length(y);
stmat = stim_mat(stim_block);
ta = stmat * stim_amps;
design_hrf = hrf_mat(ta, nt);
design_hrf = design_hrf(:,1:len_hrf);
design_hrf = [eye(nt),design_hrf];
pmat1 = sqrt(l2p_r) * ([-eye(nt-2),zeros(nt-2,2)] + [zeros(nt-2,1),2.*eye(nt-2),zeros(nt-2,1)] + [zeros(nt-2,2),-eye(nt-2)]);
pmat2 = sqrt(l2p)*([eye(len_hrf-1), zeros(len_hrf-1,1)] - [zeros(len_hrf-1,1), eye(len_hrf-1)]);
pmat = [[pmat1,zeros(nt-2,len_hrf)];[zeros(len_hrf-1,nt) ,pmat2]];
xty = design_hrf'*y;
xtx = design_hrf'*design_hrf + (pmat'*pmat);
chrf_params = lsqr(xtx,xty);
const = chrf_params(1:nt);
hrf_params = chrf_params(nt + (1:len_hrf));

end

