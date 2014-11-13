% 680S Scenario 2b 2025: Scenario 2a + Express Lane + Norris Canyon Ramps

cfg_folder       = fullfile(root,'config','680S_S2b_2025');

xlsx_file        = fullfile(cfg_folder,'I680SB_2025_S2b.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

no_ml_queue = 1;

orgf2 = 1;

rm_control = 1;
