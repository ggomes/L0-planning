function SR = estimate_sr(ord, frd, max_sr)
% ord - row vector of on-ramp demand (its size equals the number of freeway cells)
% frd - row vector of off-ramp demand
% max_sr - maximum split ratio value

sz = size(frd, 2);
SR = [];

for i = 1:sz
  ml_f = sum(ord(1:i-1)) - sum(frd(1:i-1));
  sr = max([0 (frd(i)/ml_f)]);
  sr = min([sr max_sr(i)]);
  SR = [SR sr];
end

return;
