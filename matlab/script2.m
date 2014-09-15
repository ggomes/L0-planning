
init_config;

% 6. Take fr demands from xls to xml .....................................
disp('6. Take fr demands from xls to xml')
tic
write_offramp_demand_xml(xlsx_file,fr_demand_file,range)
disp(['Done in ' num2str(toc) ' seconds.']);  

% 7. Load split actuators/controllers .....................................
disp('7. Load split actuators/controllers');
tic
act_and_ctrl = xml_read(act_cntrl);
act_and_ctrl.ControllerSet.controller.parameters.parameter.ATTRIBUTE.value = ...
    fullfile(cfg_gen_folder,'fr_demand.xml');
ptr.scenario_ptr.scenario.ControllerSet = act_and_ctrl.ControllerSet;
ptr.scenario_ptr.scenario.ActuatorSet = act_and_ctrl.ActuatorSet;
ptr.scenario_ptr.save(cfg_srout);
disp(['Done in ' num2str(toc) ' seconds.']);

% 8. Run offramp split ratio computation .................................
disp('8. Run offramp split ratio computation');
tic
ptr.reset_simulation;
system(['java -jar ' beats_jar opt_minus_s beatsprop_sr_out]);
ptr.simulation_done = true;
ptr.load_simulation_output('../beats_output/srout');
disp(['Done in ' num2str(toc) ' seconds.']);

% 9. Put the result into Excel spreadsheet ...............................
disp('9. Put the result into Excel spreadsheet')
tic
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range,no_ml_queue);
disp(['Done in ' num2str(toc) ' seconds.']); 

