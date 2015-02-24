function covmat = gp_cov_est( resd, basis_mat, eps, nits)
% estimates covariance matrix using Gaussian process model
% Inputs:
%  - resid, column vector, 1-dimensional observed gaussian process
%  - basis_mat, functions in KL expansion, should be orthonormal
%  - eps, small number
%  - nits, nits*epsilon control smoothing used for KL variance terms
nt = length(resd);
coefs = basis_mat' * resd;
c2 = coefs.^2;
for ii=1:3;
    est_sigma2 = (norm(resd)^2-sum(c2))/nt;
    c2 = c2-est_sigma2/2;
    c2(c2 < 0) = 0;
end
covmat = est_sigma2 .* eye(nt);
k = size(basis_mat,2);
c2est = diffusion_process(c2',eps,nits);
%plot(c2); hold on; plot(c2est)
for ii=1:k;
    covmat = covmat + c2est(ii).*(basis_mat(:,ii)*basis_mat(:,ii)');
end

end

