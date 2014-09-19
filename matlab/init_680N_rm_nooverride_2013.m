% 680N base year 2013 data with ramp metering and no queue control

cfg_folder = fullfile(root,'config','680N_+RM_2013');

xlsx_file        = fullfile(cfg_folder,'I680NB_RM_nooverride.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N_generated.xml');

range = [2 149];  % 680 NB

pm_dir = 1;

