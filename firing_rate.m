function lambda = firing_rate(s, r_0, r_max, s_max)
    if nargin == 1
        r_0=30;
        r_max=50;
        s_max=pi/2;
    end
    lambda = r_0+(r_max-r_0)*cos(s-s_max);
end