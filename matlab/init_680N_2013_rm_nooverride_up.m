
cfg_folder = fullfile(root,'config','680N_+RM_2013');

xlsx_file        = fullfile(cfg_folder,'I680NB_Data_nooverride_up.xlsx');
cfg_starter      = fullfile(root,'config','680N-no217','680N.xml');
sr_initial_guess = fullfile(cfg_folder,'680N_sr.xml');
rm_act_cntrl     = fullfile(cfg_folder,'rm_nooverride_up.xml');
sr_act_cntrl     = fullfile(cfg_folder,'act_cntrl_sr_generator.xml');
cfg_scenario     = fullfile(cfg_folder,'680_rm_nooverride_up.xml');

range = [2 149];  % 680 NB

hov_prct = 0.15;

pm_dir = 1;

