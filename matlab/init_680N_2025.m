
cfg_folder = fullfile(root,'config','680N_2025');

xlsx_file        = fullfile(cfg_folder,'I680NB_Data_2025.xlsx');
csv_file        = fullfile(cfg_folder,'node_offramps.csv');
cfg_starter      = fullfile(cfg_folder,'680N.xml');
sr_initial_guess = fullfile(cfg_folder,'680N_sr.xml');

range = [2 149];  % 680 NB

hov_prct = 0.18;

pm_dir = 1;

