function DLY = compute_delay(D, V, FFV, L)
% D - density contour (m-by-n)
% V - speed contour (m-by-n)
% FFV - free flow speed vector (m-by-1)
% L - vector of link lengths (m-by-1)

[m, n] = size(D);

L = repmat(L, 1, n);
FFV = repmat(FFV, 1, n);

D = round(D.*L); % density -> vehicle count

V(1, :) = FFV(1, :);
DLY = D .* max(zeros(m, n), (L ./ V) - (L ./FFV));
DLY(isnan(DLY)) = 0;
%DLY = round(DLY);

return;
