function mat = fft2mat( ffs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


nt = length(ffs);
mat = zeros(nt);
for k=1:nt;
    v = 0.* ffs;
    zk = real(ffs(k));
    wk = imag(ffs(k));
    v(k) = zk;
    v2 = 0.*ffs;
    v2(k) = wk;
    r = ifft(v);
    r2 = ifft(v2);
    m = r*r';
    m2 = r2*r2';
    mat = mat + zk^2.*m + wk^2.*m2;
end

end

