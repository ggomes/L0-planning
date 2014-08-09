
cfg_folder = fullfile(root,'config','680N_+RM_2013');

xlsx_file        = fullfile(cfg_folder,'I680NB_RM_override_dn.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N_rm_override_dn.xml');
sr_initial_guess = fullfile(cfg_folder,'680N_sr.xml');

range = [2 149];  % 680 NB

hov_prct = 0.15;

pm_dir = 1;

