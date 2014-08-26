clear
close all

init_config;


% 0. Generate split ratio file [optional] ................................
if auto_sr
disp('0. Generating split ratio file')
tic
create_sr_set;
disp(['Done in ' num2str(toc) ' seconds.']);
end

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
disp('3. Load fr splits');
tic
ptr.scenario_ptr.scenario.SplitRatioSet = xml_read(sr_initial_guess);
disp(['Done in ' num2str(toc) ' seconds.']);   

% 4. Run greedy policy ...................................................
disp('4. Run simulation');
tic
ptr.scenario_ptr.save(cfg_gp);
system(['java -jar ' beats_jar opt_minus_s beatsprop_gp]);
ptr.simulation_done = true;
ptr.load_simulation_output('../beats_output/gp');
disp(['Done in ' num2str(toc) ' seconds.']);  


% 5. Put the result into Excel spreadsheet ...............................
disp('5. Put the result into Excel spreadsheet')
tic
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range);
disp(['Done in ' num2str(toc) ' seconds.']); 

