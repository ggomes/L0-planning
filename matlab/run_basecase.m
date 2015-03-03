clear
close all

init_config;

ORS = [];



if auto_config
% 0. Generate configuration file [optional] ................................
disp('0. Generating XML configuration file')
tic
make_config_xml2;
disp(['Done in ' num2str(toc) ' seconds.']);

% 1. Generate XML off-ramp demand file [optional] ........................
disp('1. Generating XML off-ramp demand file')
tic
write_offramp_demand_xml(xlsx_file, fr_demand_file, range);
disp(['Done in ' num2str(toc) ' seconds.']);
end

% 2. Load basic network ..................................................
disp('2. Load basic network');
tic
ptr = BeatsSimulation;
ptr.load_scenario(cfg_starter);
disp(['Done in ' num2str(toc) ' seconds.']);

% 3. Run simulation ...................................................
disp('3. Run simulation');
tic
system(['java -jar ' beats_jar opt_minus_s beatsprop_sr_out]);
ptr.simulation_done = true;
ptr.load_simulation_output('../beats_output/srout');
disp(['Done in ' num2str(toc) ' seconds.']);  

% 4. Put the result into Excel spreadsheet ...............................
disp('4. Put the result into Excel spreadsheet')
tic
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ, ORS] = extract_simulation_data(ptr,xlsx_file,range,no_ml_queue,ORS,orgf2,orgf3,orgf4);
disp(['Done in ' num2str(toc) ' seconds.']); 

