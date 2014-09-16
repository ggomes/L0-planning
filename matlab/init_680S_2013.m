% 680S 2013 baseline init file

cfg_folder = fullfile(root,'config','680S');

xlsx_file        = fullfile(cfg_folder,'I680SB_Data.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');
sr_initial_guess = fullfile(cfg_folder,'680S_sr.xml');

range = [2 147];  % 680 SB

hov_prct = 0.135;

pm_dir = -1;

