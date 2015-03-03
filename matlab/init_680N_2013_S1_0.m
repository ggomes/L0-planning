% 680N Scenario 1: Aux lane only

cfg_folder = fullfile(root,'config','680N_Scenario_1_0');

xlsx_file        = fullfile(cfg_folder,'I680NB_S1_AuxLane.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N_generated.xml');
act_cntrl        = fullfile(cfg_folder,'actuators_and_controllers.xml');

range = [2 149];  % 680 NB

pm_dir = 1;

