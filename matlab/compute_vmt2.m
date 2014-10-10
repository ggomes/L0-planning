function VMT = compute_vmt(F, L)
% F - flow contour (m-by-n)
% L - vector of link lengths (m-by-1)

[m, n] = size(F);

F = round(F.*repmat(L, 1, n)); % density -> vehicle count

VMT = (1/12) * F;
%VMT = round(VMT);

return;
