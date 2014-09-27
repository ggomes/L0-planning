% 680S base year 2013 data with ramp metering and queue control

cfg_folder = fullfile(root,'config','680S_+RM_2013');

xlsx_file        = fullfile(cfg_folder,'I680SB_RM_override.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');
sr_initial_guess = fullfile(cfg_folder,'680S_sr.xml');

range = [2 146];  % 680 SB

rm_control = 1;

pm_dir = -1;

