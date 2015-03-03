% 680S Scenario 1 2025: Aux lane + HOT demand South of 24

cfg_folder       = fullfile(root,'config','680S_S1_2025');

xlsx_file        = fullfile(cfg_folder,'I680SB_2025_S1.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

no_ml_queue = 0;

orgf2 = 1;
