
cfg_folder       = fullfile(root,'config','680S_+HOV+Aux_2013');

xlsx_file        = fullfile(cfg_folder,'I680SB_+HOV+Aux_Data.xlsx');
csv_file         = fullfile(cfg_folder,'node_offramps.csv');
cfg_starter      = fullfile(cfg_folder,'680S.xml');
sr_initial_guess = fullfile(cfg_folder,'680S_sr.xml');
sr_init_file     = fullfile(cfg_folder,'680S_sr_init.xml');

range = [2 147];  % 680 SB

hov_prct = 0.135;

pm_dir = -1;

auto_sr = 1;
