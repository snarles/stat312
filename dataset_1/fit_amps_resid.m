function [stim_amps,const] = fit_amps_resid( y, hrf_params, stim_block, l2p_a, l2p_r)
% fit amplitudes given fixed HRF function
% Inputs:
%  - y, MRI signal
%  - hrf_params, parameters for HRF signal
%  - stim_block, stimuli assignments
%  - l2p_a, l2penalty on amplitudes
%  - l2p_r, l2penalty on residual
% Outputs:
%  - stim_amps, amplitudes for the stimuli
%  - const, residual
nt = length(y);
hmat = hrf_mat(hrf_params, nt);
stmat = stim_mat(stim_block);
design_amps = hmat * stmat;
cdes = [eye(nt),design_amps];
p = max(stim_block);
if length(l2p_a) ==1
    l2p_a=l2p_a * ones(1,p);
end
pmat = [-eye(nt-2),zeros(nt-2,2)] + [zeros(nt-2,1),2.*eye(nt-2),zeros(nt-2,1)] + [zeros(nt-2,2),-eye(nt-2)];
pm = (pmat'*pmat);
xtx = cdes'*cdes + diag([zeros(1,nt), l2p_a]);
xtx(1:nt,1:nt) = xtx(1:nt,1:nt) + l2p_r * pm;
xty = cdes'*y;
cstim_amps = lsqr(xtx,xty);
const = cstim_amps(1:nt);
stim_amps = cstim_amps(nt + (1:p));
end

