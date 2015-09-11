% 210E baseline init file

cfg_folder = fullfile(root,'config','210E');

xlsx_file        = fullfile(cfg_folder,'I210EB_Data.xlsx');
cfg_starter      = fullfile(cfg_folder,'210E_generated.xml');
sr_initial_guess = fullfile(cfg_folder,'210E_sr.xml');

range = [2 136];  % 210 EB

pm_dir = 1;
sr_control = 0;

hov_prct=0.15;

