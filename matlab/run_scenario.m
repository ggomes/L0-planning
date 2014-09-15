clear
close all

init_config;


% 0. Generate configuration file [optional] ................................
if auto_config
disp('0. Generating XML configuration file')
tic
make_config_xml;
disp(['Done in ' num2str(toc) ' seconds.']);
end

% 1. Load basic network ..................................................
disp('1. Load basic network');
tic
ptr = BeatsSimulation;
ptr.load_scenario(cfg_starter);
disp(['Done in ' num2str(toc) ' seconds.']);

% 4. Run simulation ...................................................
disp('2. Run simulation');
tic
ptr.scenario_ptr.save(cfg_gp);
system(['java -jar ' beats_jar opt_minus_s beatsprop_gp]);
ptr.simulation_done = true;
ptr.load_simulation_output('../beats_output/gp');
disp(['Done in ' num2str(toc) ' seconds.']);  


% 5. Put the result into Excel spreadsheet ...............................
disp('3. Put the result into Excel spreadsheet')
tic
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range,no_ml_queue);
disp(['Done in ' num2str(toc) ' seconds.']); 

