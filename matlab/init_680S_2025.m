
cfg_folder = fullfile(root,'config','680S_2025');

xlsx_file        = fullfile(cfg_folder,'I680SB_2025_Data.xlsx');
hov_csv        = fullfile(cfg_folder,'hov.csv');
csv_file        = fullfile(cfg_folder,'node_offramps.csv');
cfg_starter      = fullfile(cfg_folder,'680S.xml');
sr_initial_guess = fullfile(cfg_folder,'680S_sr.xml');

range = [2 147];  % 680 SB

hov_prct = 0.138;

pm_dir = -1;

