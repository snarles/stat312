function hmat = hrf_mat( hrf_params, nt )
%
% Inputs:
%  - hrf_params, p x 1 vector, where p ~ duration of the HRF signal
%  - nt, total number of time points 
% Outputs:
%  - hmat, an nt x nt matrix, mat(:,1) = (hrf_params, 0, ...)

p = length(hrf_params);
hmat = zeros(nt);
for ii=1:nt;
    hmat((ii-1)+ (1:p),ii) = hrf_params;
end
hmat = hmat(1:nt,:);

end

