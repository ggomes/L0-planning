clear all;

hov_prct = 0.2;
sov_prct = 1 - hov_prct;


% 680 NB
data_file = 'I680NB_Data.xlsx';
cfg_file = '680N_cfg.xml';
src_cfg = '680N_src_cfg.xml';
fr_demand_file = '680N_fr_demand.xml';
range = [2 149];



% generate BeATS config file
gen_beats_config;


% load scenario
fprintf('Loading scenario...\n');
ptr = BeatsSimulation;
ptr.load_scenario(cfg_file);



% run simulation
fprintf('Running simulation...\n');
ptr.run_simulation(5, 0, 86400, 300);



% extract speed & flow simulation data
extract_simulation_data;



