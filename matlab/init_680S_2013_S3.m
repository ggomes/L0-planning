% 680S Scenario 3: Scenario 2b + SR-4 Interconnect modification

cfg_folder       = fullfile(root,'config','680S_S3_2013');

xlsx_file        = fullfile(cfg_folder,'I680SB_S3.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

orgf2 = 0;

rm_control = 1;

special_onramps = 1;

hot_offramps = 1;
