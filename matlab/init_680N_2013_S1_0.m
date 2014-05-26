
cfg_folder = fullfile(root,'config','680N_Scenario_1_0');

xlsx_file        = fullfile(cfg_folder,'I680NB_+Aux.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N.xml');
sr_initial_guess = fullfile(cfg_folder,'680N_sr.xml');

range = [2 149];  % 680 NB

hov_prct = 0.15;

pm_dir = 1;

