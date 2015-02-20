function emat = gp_eigenfuncs( nt, h )
% eigenfunctions of gp with covariance exp(-d^2/h)

mat1 = repmat((1:nt)-1, nt, 1)./nt;
cmat = exp(-(mat1 - mat1').^2/h);
[emat, v] = eig(cmat);
v = diag(v);
[~,o] = sort(-v);
emat = emat(:,o);

end

