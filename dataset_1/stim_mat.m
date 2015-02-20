function stmat = stim_mat( stim_block )
%
% Input:
%  - stim_block: length nt vector, 0=no signal, 1..k = different stimuli
%  types
%
% Output:
%  - stmat: nt x k matrix, design matrix for stimuli

k = max(stim_block);
nt = length(stim_block);
stmat = zeros(nt,k);
for ii=1:k;
    stmat(:,ii) = (stim_block==ii);
end

end

