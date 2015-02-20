function v = diffusion_process( v, eps, nits )
% smooths out vector v by 1-dimensional diffusion process
% so that sum(v) is preserved

for ii=1:nits;
    % the contribution from left to right
    dr2l = -[v(1:(end-1))-v(2:end),0];
    % the contribution from right to left
    dl2r = -[0, v(2:end) - v(1:(end-1))];
    % the derivative
    dtot = dr2l + dl2r;
    v = v+eps.*dtot;
end



end

