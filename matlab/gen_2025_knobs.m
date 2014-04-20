clear all;

init_config;


ORD = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('k%d:kl%d', range(1), range(2)));
FRD = xlsread(xlsx_file, 'Off-Ramp_Demand', sprintf('k%d:kl%d', range(1), range(2)));
ORK = xlsread(xlsx_file, 'On-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
FRK = xlsread(xlsx_file, 'Off-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));

sz = size(ORD, 1);
ORK_out = ones(sz, 288);
FRK_out = ones(sz, 288);

for i = 1:sz
  if max(ORD(i, :)) > 0
    for j = 1:288
      k = ORD(i, j) * (ORK(i, j) - 1) / (3*ORK(i, j) + 17);
      b = ORD(i, j) - 13*k;
      ORK_out(i, j) = (25*k + b) / ORD(i, j);
    end
  end
  if max(FRD(i, :)) > 0
    for j = 1:288
      k = FRD(i, j) * (FRK(i, j) - 1) / (3*FRK(i, j) + 17);
      b = FRD(i, j) - 13*k;
      FRK_out(i, j) = (25*k + b) / FRD(i, j);
    end
  end
end



