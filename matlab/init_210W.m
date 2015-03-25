% 210W baseline init file

cfg_folder = fullfile(root,'config','210W');

xlsx_file        = fullfile(cfg_folder,'I210WB_Data.xlsx');
cfg_starter      = fullfile(cfg_folder,'210W_generated.xml');
sr_initial_guess = fullfile(cfg_folder,'210W_sr.xml');

range = [2 135];  % 210 WB

pm_dir = 1;

%sr_control = 1;

hov_prct=0.15;

