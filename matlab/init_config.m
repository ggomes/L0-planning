
root = fileparts(fileparts(mfilename('fullpath')));
beats_jar = fullfile(root,'beats','beats-0.1-SNAPSHOT.jar');

%init_680N_2013
init_680N_2013_S1
%init_680N_2025
%init_680N_2030
%init_680S_2013

beats_out_folder = fullfile(root,'beats_output');
cfg_gen_folder = fullfile(cfg_folder,'generated');

beatsprop_gp     = fullfile(cfg_folder,'beats_gp_5min.properties');
beatsprop_sr_out = fullfile(cfg_folder,'beats_srout.properties');
act_cntrl        = fullfile(cfg_folder,'actuators_and_controllers.xml');
cfg_gp           = fullfile(cfg_gen_folder,'gp.xml');
cfg_srout        = fullfile(cfg_gen_folder,'srout.xml');
fr_demand_file   = fullfile(cfg_gen_folder,'fr_demand.xml');
gp_out           = fullfile(beats_out_folder,'sr');
ppt_report_file  = fullfile(cfg_gen_folder,'compare_fr_flows');

opt_minus_s = ' -s ';
%opt_minus_s = ' ';


