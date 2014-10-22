% 680N Scenario 1 2025: Aux lane + HOT demand South of 24

cfg_folder       = fullfile(root,'config','680N_S1_2025');

xlsx_file        = fullfile(cfg_folder,'I680NB_2025_S1.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N_generated.xml');

range = [2 149];  % 680 NB

pm_dir = 1;

no_ml_queue = 1;
