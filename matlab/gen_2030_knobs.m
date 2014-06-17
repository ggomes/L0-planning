clear all;

init_config;


ORGF = xlsread(xlsx_file, 'On-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
FRGF = xlsread(xlsx_file, 'Off-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));

sz = size(ORGF, 1);

ORK = ones(sz, 288);
FRK = ones(sz, 288);


OK_AM = ORGF(:, 2);
OK_MD = ORGF(:, 3);
OK_PM = ORGF(:, 4);
FK_AM = FRGF(:, 2);
FK_MD = FRGF(:, 3);
FK_PM = FRGF(:, 4);

ORK(:, 61:120) = repmat(OK_AM, 1, 60);
ORK(:, 121:180) = repmat(OK_MD, 1, 60);
ORK(:, 181:240) = repmat(OK_PM, 1, 60);
FRK(:, 61:120) = repmat(FK_AM, 1, 60);
FRK(:, 121:180) = repmat(FK_MD, 1, 60);
FRK(:, 181:240) = repmat(FK_PM, 1, 60);

xlswrite(xlsx_file, ORK, 'On-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)))
xlswrite(xlsx_file, FRK, 'Off-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)))

