function fm = fourier_matrix(nt,k )
% creates fourier matrix
% nt: number of time points in each sinusoid
% k: order of sinusoid

fm = zeros(nt, 2*k+1);
fm(:,1) = 1;
ts = 2*pi.*(1:nt)./nt;
for ii=1:k;
    fm(:,2*ii) = cos(ii*ts);
    fm(:,2*ii+1) = sin(ii*ts);
end
for ii=1:(2*k+1);
    fm(:,ii) = fm(:,ii)/norm(fm(:,ii));
end

end

