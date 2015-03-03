% 680S Scenario 4: Scenario 3 + misc aux lanes

cfg_folder       = fullfile(root,'config','680S_S4_2013');

xlsx_file        = fullfile(cfg_folder,'I680SB_S4.xlsx');
cfg_starter      = fullfile(cfg_folder,'680S_generated.xml');

range = [2 146];  % 680 SB

pm_dir = -1;

orgf2 = 0;

rm_control = 1;

special_onramps = 1;

hot_offramps = 1;
