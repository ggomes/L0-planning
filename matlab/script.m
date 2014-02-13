
clear
close all

root = fileparts(fileparts(mfilename('fullpath')));
cfg_folder = fullfile(root,'config','680N-no217');

xlsx_file        = fullfile(cfg_folder,'I680NB-no217_Data.xlsx');
cfg_starter      = fullfile(cfg_folder,'680N.xml');
cfg_gp           = fullfile(cfg_folder,'gp.xml');
cfg_srout        = fullfile(cfg_folder,'srout.xml');
act_cntrl        = fullfile(cfg_folder,'actuators_and_controllers.xml');
fr_demand_file   = fullfile(cfg_folder,'fr_demand.xml');
sr_initial_guess = fullfile(cfg_folder,'sr_initial_guess.xml');
beatsprop_gp     = fullfile(cfg_folder,'beats_gp.properties');
beatsprop_sr_out = fullfile(cfg_folder,'beats_srout.properties');
gp_out = fullfile(root,'beats_output','sr');

range = [2 149];
hov_prct = 0.2;

% 1. Load basic network ..................................................
ptr = BeatsSimulation;
ptr.load_scenario(cfg_starter);

% 2. Load or demands from xls ............................................
ptr.scenario_ptr.scenario.DemandSet = attach_onramp_demands(xlsx_file,range,hov_prct);

% 3. Load initial guess at fr splits .....................................
ptr.scenario_ptr.scenario.SplitRatioSet = xml_read(sr_initial_guess);

% 4. Run greedy policy ...................................................
ptr.scenario_ptr.save(cfg_gp)
system(['java -jar ..\\beats\\beats-0.1-SNAPSHOT.jar ' beatsprop_gp])
ptr.simulation_done = true;
ptr.load_simulation_output('..\\beats_output\\gp');
            
% 5. aggregate GP/HOV split ratios to 5min ...............................
ptr.scenario_ptr.scenario.SplitRatioSet = compute_5min_splits_from_sim(ptr,gp_out);

% 6. Take fr demands from xls to xml .....................................
write_offramp_demand_xml(xlsx_file,fr_demand_file,range)

% 7. Assemble a scenario .................................................
act_and_ctrl = xml_read(act_cntrl);
ptr.scenario_ptr.scenario.ControllerSet = act_and_ctrl.ControllerSet;
ptr.scenario_ptr.scenario.ActuatorSet = act_and_ctrl.ActuatorSet;
ptr.scenario_ptr.save(cfg_srout)

% 8. Run offramp split ratio computation .................................
ptr.reset_simulation;
system(['java -jar ..\\beats\\beats-0.1-SNAPSHOT.jar ' beatsprop_sr_out])
ptr.simulation_done = true;
ptr.load_simulation_output('..\\beats_output\\srout');

% 9. Put the result into Excel spreadsheet ...............................
extract_simulation_data(ptr,xlsx_file,range)

disp('done')
