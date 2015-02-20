function w = subsample( v, period )
% returns v[1, 1+period, 1+2*period,..]
l = length(v);
k = l/period;
w = v(1+((1:k)-1)*period);
end

