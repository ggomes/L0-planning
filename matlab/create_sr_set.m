
gp_id = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('a%d:a%d', range(1), range(2)))';
hov_id = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('b%d:b%d', range(1), range(2)))';
or_id = xlsread(xlsx_file, 'On-Ramp_Demand', sprintf('g%d:g%d', range(1), range(2)))';
fr_id = xlsread(xlsx_file, 'Off-Ramp_Demand', sprintf('g%d:g%d', range(1), range(2)))';
SR = xlsread(xlsx_file, 'Off-Ramp_SplitRatios', sprintf('k%d:kl%d', range(1), range(2)));
FRK = xlsread(xlsx_file, 'Off-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
%SR = SR .* FRK;

NDOFF = csvread(csv_file);

gen_sr_xml(gp_id, hov_id, or_id, fr_id, NDOFF(:, 1)', SR, sr_init_file, sr_initial_guess);
