% 680S 2013 baseline init file

cfg_folder = fullfile(root,'config','680S');

xlsx_file        = fullfile(cfg_folder,'I680SB_Data.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');
sr_initial_guess = fullfile(cfg_folder,'680S_sr.xml');
act_cntrl        = fullfile(cfg_folder,'actuators_and_controllers.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

