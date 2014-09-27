% 680S 2025 baseline init

cfg_folder = fullfile(root,'config','680S_2025');

xlsx_file        = fullfile(cfg_folder,'I680SB_2025_Data.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');
sr_initial_guess = fullfile(cfg_folder,'680S_sr.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

no_ml_queue = 0;

