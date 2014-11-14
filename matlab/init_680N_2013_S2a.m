% 680N Scenario 2a: Scenario 1 + Ramp Metering

cfg_folder       = fullfile(root,'config','680N_S2a_2013');

xlsx_file        = fullfile(cfg_folder,'I680NB_S2a.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N_generated.xml');

range = [2 149];  % 680 NB

pm_dir = 1;

orgf2 = 0;

rm_control = 1;

