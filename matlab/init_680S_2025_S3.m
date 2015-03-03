%  680S Scenario 3: Scenario 2b + SR-4 Interconnect modification

cfg_folder       = fullfile(root,'config','680S_S3_2025');

xlsx_file        = fullfile(cfg_folder,'I680SB_2025_S3.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

no_ml_queue = 1;

orgf2 = 1;

rm_control = 1;

special_onramps = 1;

hot_offramps = 1;
