
clear
close all

root = fileparts(fileparts(mfilename('fullpath')));
beats_jar = fullfile(root,'beats','beats-0.1-SNAPSHOT.jar');
cfg_folder = fullfile(root,'config','680N_+HOV+Aux_2013');
beats_out_folder = fullfile(root,'beats_output');

xlsx_file     = fullfile(cfg_folder,'I680NB-no217_Data.xlsx');
cfg_file      = fullfile(cfg_folder,'680N_hov_aux_sr.xml');
beatsprop     = fullfile(cfg_folder,'beats.properties');

range = [2 149];

% 1. Run simulation
system(['java -jar ' beats_jar ' -s ' beatsprop])

% 2. Load scenario and simulation output
ptr = BeatsSimulation;
ptr.load_scenario(cfg_file);
ptr.simulation_done = true;
ptr.load_simulation_output('..\\beats_output\\gp');

% 3. Put the result into Excel spreadsheet
extract_simulation_data(ptr,xlsx_file,range)

disp('done')
