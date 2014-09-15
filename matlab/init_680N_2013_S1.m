
cfg_folder       = fullfile(root,'config','680N_S1_2013');

xlsx_file        = fullfile(cfg_folder,'I680NB_S1.xlsx');
csv_file         = fullfile(cfg_folder,'node_offramps.csv');
cfg_starter      = fullfile(cfg_folder,'680N_generated.xml');
sr_initial_guess = fullfile(cfg_folder,'680N_sr.xml');
sr_init_file     = fullfile(cfg_folder,'680N_sr_init.xml');

range = [2 149];  % 680 NB

pm_dir = 1;

rm_control = 0;
