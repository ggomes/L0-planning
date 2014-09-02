clear
close all

init_config;

% 1. Load basic network ..................................................
disp('1. Load basic network');
tic
ptr = BeatsSimulation;
ptr.load_scenario(cfg_starter);
disp(['Done in ' num2str(toc) ' seconds.']);

% 2. Load or demands from xls ............................................
disp('2. Load or demands from xls');
tic
ptr.scenario_ptr.scenario.DemandSet = attach_onramp_demands(xlsx_file,range,hov_prct);
disp(['Done in ' num2str(toc) ' seconds.']);  

% 3. Load initial guess at fr splits .....................................
disp('3. Load initial guess at fr splits');
tic
ptr.scenario_ptr.scenario.SplitRatioSet = xml_read(sr_initial_guess);
disp(['Done in ' num2str(toc) ' seconds.']);

% 4. Run greedy policy ...................................................
disp('4. Run greedy policy');
tic
ptr.scenario_ptr.save(cfg_gp);
system(['java -jar ' beats_jar opt_minus_s beatsprop_gp]);
ptr.simulation_done = true;
ptr.load_simulation_output('../beats_output/gp');
disp(['Done in ' num2str(toc) ' seconds.']);

% 5. aggregate GP/HOV split ratios to 5min ...............................
disp('5. aggregate GP/HOV split ratios to 5min');
tic
is_5min_gp = ~isempty(strfind(beatsprop_gp,'beats_gp_5min.properties'));
ptr.scenario_ptr.scenario.SplitRatioSet = compute_5min_splits_from_sim(ptr,gp_out,is_5min_gp);
disp(['Done in ' num2str(toc) ' seconds.']);  

% 6. Take fr demands from xls to xml .....................................
disp('6. Take fr demands from xls to xml')
tic
write_offramp_demand_xml(xlsx_file,fr_demand_file,range)
disp(['Done in ' num2str(toc) ' seconds.']);  

% 7. Load split actuators/controllers .....................................
disp('7. Load split actuators/controllers');
tic
act_and_ctrl = xml_read(act_cntrl);
act_and_ctrl.ControllerSet.controller.parameters.parameter(1).ATTRIBUTE.value = fullfile(cfg_gen_folder,'fr_demand.xml');
act_and_ctrl.ControllerSet.controller.parameters.parameter(2).ATTRIBUTE.value = sr_cntrl_log;
ptr.scenario_ptr.scenario.ControllerSet = act_and_ctrl.ControllerSet;
ptr.scenario_ptr.scenario.ActuatorSet = act_and_ctrl.ActuatorSet;
ptr.scenario_ptr.save(cfg_srout);
clear act_and_ctrl
disp(['Done in ' num2str(toc) ' seconds.']);

% 8. Run offramp split ratio computation .................................
disp('8. Run offramp split ratio computation');
tic
ptr.reset_simulation;
system(['java -jar ' beats_jar opt_minus_s beatsprop_sr_out]);
ptr.simulation_done = true;
ptr.load_simulation_output('../beats_output/srout');
disp(['Done in ' num2str(toc) ' seconds.']);

% 9. Read computed split ratios, save final config .......................
ptr.scenario_ptr.scenario.SplitRatioSet.splitRatioProfile = load_computed_splits(sr_cntrl_log);
ptr.scenario_ptr.save(cfg_final)

% 10. Put the result into Excel spreadsheet ...............................
disp('9. Put the result into Excel spreadsheet')
tic
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range);
disp(['Done in ' num2str(toc) ' seconds.']); 

