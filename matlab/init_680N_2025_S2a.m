% 680N Scenario 2a 2025: Scenario 1 + Ramp Metering

cfg_folder       = fullfile(root,'config','680N_S2a_2025');

xlsx_file        = fullfile(cfg_folder,'I680NB_2025_S2a.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N_generated.xml');

range = [2 149];  % 680 NB

pm_dir = 1;

no_ml_queue = 0;

orgf2 = 1;

rm_control = 1;

special_onramps = 1;


% On-ramp -130 (Crow Canyon WB)
% Lanes = 18
% Queue limit = 4
