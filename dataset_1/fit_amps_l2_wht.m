function [stim_amps,const] = fit_amps_l2_wht( y, hrf_params, stim_block, l2p_a, whtmat)
% fit amplitudes given fixed HRF function
% Inputs:
%  - y, MRI signal
%  - hrf_params, parameters for HRF signal
%  - stim_block, stimuli assignments
%  - l2p_a, l2penalty on amplitudes
% Outputs:
%  - stim_amps, amplitudes for the stimuli
%  - const, constant term
nt = length(y);
hmat = hrf_mat(hrf_params, nt);
stmat = stim_mat(stim_block);
design_amps = hmat * stmat;
cdes = whtmat*[ones(nt,1),design_amps];
p = max(stim_block);
if length(l2p_a) ==1
    l2p_a=l2p_a * ones(1,p);
end
xtx = cdes'*cdes + diag([0, l2p_a]);
xty = cdes'*whtmat*y;
cstim_amps = lsqr(xtx,xty);
const = cstim_amps(1);
stim_amps = cstim_amps(1 + (1:p));
end

