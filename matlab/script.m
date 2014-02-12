
clear
close all

root = fileparts(fileparts(mfilename('fullpath')));
cfg_folder = fullfile(root,'config','680N-no217');

basic_network    = fullfile(cfg_folder,'680N-no217_basic.xml');
xlsx_file        = fullfile(cfg_folder,'I680NB-no217_Data.xlsx');
fr_demand_file   = fullfile(cfg_folder,'680N_fr_demand.xml');
sr_initial_guess = fullfile(cfg_folder,'sr_initial_guess.xml');
gp_out           = fullfile(cfg_folder,'sr_');

range = [2 149];
hov_prct = 0.2;

%% x. Load basic network ..................................................
ptr = BeatsSimulation;
ptr.load_scenario(basic_network);

%% x. Load or demands from xls ............................................
ptr = attach_onramp_demands(ptr,xlsx_file,range,hov_prct);

%% x. Load initial guess at fr splits .....................................
ptr.scenario_ptr.scenario.SplitSet = xml_read(sr_initial_guess);

%% x. Run greedy policy ...................................................
run_beats_greedy_policy(ptr,gp_out);

%% x. aggregate GP/HOV split ratios to 5min ...............................
SplitRatioSet = compute_5min_splits_from_sim(ptr,gp_out);

%% x. Take fr demands from xls to xml .....................................
write_offramp_demand_xml(xlsx_file,fr_demand_file,range)

%% x. Assemble a scenario .................................................

%% x. Run offramp split ratio computation .................................
run_beats_sr_computation(ptr);

%% x. Put the result into Excel spreadsheet ...............................
%  extract_simulation_data

disp('done')
