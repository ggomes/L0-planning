
cfg_folder = fullfile(root,'config','680N_+RM_2013');

xlsx_file        = fullfile(cfg_folder,'I680NB_Data_nooverride_up.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N_rm_nooverride_up.xml');
sr_initial_guess = fullfile(cfg_folder,'680N_sr.xml');
act_cntrl        = fullfile(cfg_folder,'680N_rm_nooverride_up.xml');

range = [2 149];  % 680 NB

hov_prct = 0.15;

pm_dir = 1;

