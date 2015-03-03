% Estimate split ratios from on- and off-ramp demand adjusted by knobs and
% growth factors, and record it in the spreadsheet.

clear
close all

init_config;

sz = range(2) - 1;

gf2 = 0;

fprintf('Reading on- and off-ramp demand data, knobs and growth factors from %s...\n', xlsx_file);

or_id = xlsread(xlsx_file, 'On-Ramp_CollectedFlows', sprintf('g%d:g%d', range(1), range(2)))';
ORD = xlsread(xlsx_file, 'On-Ramp_CollectedFlows', sprintf('k%d:kl%d', range(1), range(2)));
ORK = xlsread(xlsx_file, 'On-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
ORGF = xlsread(xlsx_file, 'On-Ramp_GrowthFactors', sprintf('k%d:kl%d', range(1), range(2)));
if gf2
  ORGF2 = xlsread(xlsx_file, 'On-Ramp_GrowthFactors_2', sprintf('k%d:kl%d', range(1), range(2)));
  ORGF = ORGF .* ORGF2;
end
ORD = ORD .* ORK .* ORGF;


fr_id = xlsread(xlsx_file, 'Off-Ramp_CollectedFlows', sprintf('g%d:g%d', range(1), range(2)))';
FRD = xlsread(xlsx_file, 'Off-Ramp_CollectedFlows', sprintf('k%d:kl%d', range(1), range(2)));
FRK = xlsread(xlsx_file, 'Off-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
FRGF = xlsread(xlsx_file, 'Off-Ramp_GrowthFactors', sprintf('k%d:kl%d', range(1), range(2)));
if gf2
  FRGF2 = xlsread(xlsx_file, 'Off-Ramp_GrowthFactors_2', sprintf('k%d:kl%d', range(1), range(2)));
  FRGF = FRGF .* FRGF2;
end
FRD = FRD .* FRK .* FRGF;


gp_id = xlsread(xlsx_file, 'On-Ramp_CollectedFlows', sprintf('a%d:a%d', range(1), range(2)))';
hov_id = xlsread(xlsx_file, 'On-Ramp_CollectedFlows', sprintf('b%d:b%d', range(1), range(2)))';
gp_cap = xlsread(xlsx_file, 'GP_Flow', sprintf('e%d:e%d', range(1), range(2)));
hov_cap = xlsread(xlsx_file, 'HOV_Flow', sprintf('e%d:e%d', range(1), range(2)));
fr_lanes = xlsread(xlsx_file, 'Configuration', sprintf('u%d:u%d', range(1), range(2)))';


fprintf('Estimating off-ramp split ratios...\n');

max_sr = ones(1, sz);

% Compute max split ratio
for i = 1:sz
  if fr_id(i) ~= 0
    fr_cap = 1900 * fr_lanes(i);
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

fprintf('Writing split ratios to %s\n', xlsx_file);
xlswrite(xlsx_file, SR, 'Off-Ramp_SplitRatios', sprintf('k%d:kl%d', range(1), range(2)));
