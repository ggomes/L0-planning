% 680S Scenario 2b: Scenario 2a + Express Lane + Norris Canyon Ramps

cfg_folder       = fullfile(root,'config','680S_S2b_2013');

xlsx_file        = fullfile(cfg_folder,'I680SB_S2b.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

orgf2 = 0;

rm_control = 1;

special_onramps = 1;

