
cfg_folder = fullfile(root,'config','680N-no217');

xlsx_file        = fullfile(cfg_folder,'I680NB_Data.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N.xml');
sr_initial_guess = fullfile(cfg_folder,'680N_sr.xml');
act_cntrl        = fullfile(cfg_folder,'actuators_and_controllers.xml');



range = [2 149];  % 680 NB

hov_prct = 0.15;

pm_dir = 1;

