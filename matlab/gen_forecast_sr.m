clear
close all

init_config;

sz = range(2) - 1;

or_id = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('g%d:g%d', range(1), range(2)))';
ORD = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('k%d:kl%d', range(1), range(2)));
ORK = xlsread(xlsx_file, 'On-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
ORD = ORD .* ORK;
has_or = find(max(ORD,[],2)>0);
has_or = has_or';


fr_id = xlsread(xlsx_file, 'Off-Ramp_Demand', sprintf('g%d:g%d', range(1), range(2)))';
FRD = xlsread(xlsx_file, 'Off-Ramp_Demand', sprintf('k%d:kl%d', range(1), range(2)));
FRK = xlsread(xlsx_file, 'Off-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
FRD = FRD .* FRK;
has_fr = find(max(FRD,[],2)>0);
has_fr = has_fr';


gp_id = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('a%d:a%d', range(1), range(2)))';
hov_id = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('b%d:b%d', range(1), range(2)))';
gp_cap = xlsread(xlsx_file, 'GP_Flow', sprintf('e%d:e%d', range(1), range(2)));
hov_cap = xlsread(xlsx_file, 'HOV_Flow', sprintf('e%d:e%d', range(1), range(2)));

NDOFF = csvread(csv_file);


max_sr = ones(1, sz);

% Compute max split ratio
for i = 1:sz
  if NDOFF(i, 2) ~= 0
    fr_cap = 1800 * NDOFF(i, 3);
    ml_cap = min([(gp_cap(i-1, 1)+hov_cap(i-1, 1)) (gp_cap(i, 1)+hov_cap(i, 1))]);
    max_sr(i) = min([1 (fr_cap/ml_cap)]);
  end
end

SR = [];
for i = 1:277
  sr = estimate_sr(mean(ORD(:, i:i+11)'), mean(FRD(:, i:i+11)'), max_sr);
  SR = [SR sr'];
end
SR = [SR repmat(sr', 1, 11)];


gen_sr_xml(gp_id, hov_id, or_id, fr_id, NDOFF(:, 1)', SR);
