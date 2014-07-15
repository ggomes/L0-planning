function run_rm_scenarios()

root = fileparts(fileparts(mfilename('fullpath')));

% 680N setup
Y(1).init_file = fullfile(root,'matlab','init_680N_2013');
Y(1).xlsx_file = 'I680NB_Data.xlsx';
Y(1).scenario_folder = fullfile(root,'config','680N_+RM_2013');

% 680S setup
Y(2).init_file = fullfile(root,'matlab','init_680S_2013');
Y(2).xlsx_file = 'I680SB_Data.xlsx';
Y(2).scenario_folder = fullfile(root,'config','680S_+RM_2013');

% 680N scenarios
ii=1;
X(ii).Yind = 1;
X(ii).cntrl_suffix = 'rm_nooverride_up';

ii=ii+1;
X(ii).Yind = 1;
X(ii).cntrl_suffix = 'rm_override_up';

ii=ii+1;
X(ii).Yind = 1;
X(ii).cntrl_suffix = 'rm_nooverride_dn';

ii=ii+1;
X(ii).Yind = 1;
X(ii).cntrl_suffix = 'rm_override_dn';

% 680S scenarios
ii=ii+1;
X(ii).Yind = 2;
X(ii).cntrl_suffix = 'rm_nooverride_up';

ii=ii+1;
X(ii).Yind = 2;
X(ii).cntrl_suffix = 'rm_override_up';

ii=ii+1;
X(ii).Yind = 2;
X(ii).cntrl_suffix = 'rm_nooverride_dn';

ii=ii+1;
X(ii).Yind = 2;
X(ii).cntrl_suffix = 'rm_override_dn';

for ii = 1:length(X)
    run_scenario(Y(X(ii).Yind),X(ii))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_scenario(Y,X)

root = fileparts(fileparts(mfilename('fullpath')));
beats_out_folder = fullfile(root,'beats_output');

delete(fullfile(beats_out_folder,'*'))

% load from init file
range = [];
run(Y.init_file)
cfg_gen_folder   = fullfile(Y.scenario_folder,'generated');
clear act_cntrl

% Load basic network ..............................................
ptr = BeatsSimulation;
ptr.load_scenario(cfg_starter);

% Load or demands from xls ........................................
ptr.scenario_ptr.scenario.DemandSet = attach_onramp_demands( ...
    fullfile(cfg_folder,Y.xlsx_file),range,hov_prct);

% Load initial guess at fr splits .................................
ptr.scenario_ptr.scenario.SplitRatioSet = xml_read(sr_initial_guess);

% Run greedy policy ...............................................
gp_out  = fullfile(beats_out_folder,'gp');
ptr.run_beats( struct(  'SCENARIO',fullfile(cfg_gen_folder,'gp.xml'),...
    'SIM_DT','5',...
    'OUTPUT_PREFIX',gp_out,...
    'SPLIT_LOGGER_PREFIX',gp_out,...
    'SPLIT_LOGGER_DT','300',...
    'OUTPUT_DT','5' ) );

% 5. aggregate GP/HOV split ratios to 5min ........................
ptr.scenario_ptr.scenario.SplitRatioSet = compute_5min_splits_from_sim(ptr,gp_out,true);

% 6. Take fr demands from xls to xml ..............................
fr_demand_file   = fullfile(cfg_gen_folder,'fr_demand.xml');
write_offramp_demand_xml(xlsx_file,fr_demand_file,range)

% 7. Load split actuators/controllers .............................
act_and_ctrl = xml_read(fullfile(Y.scenario_folder,'act_cntrl_sr_generator.xml'));
act_and_ctrl.ControllerSet.controller.parameters.parameter.ATTRIBUTE.value = fr_demand_file;
ptr.scenario_ptr.scenario.ControllerSet = act_and_ctrl.ControllerSet;
ptr.scenario_ptr.scenario.ActuatorSet = act_and_ctrl.ActuatorSet;

% 8. Run offramp split ratio computation ..........................
cfg_srout = fullfile(cfg_gen_folder,'srout.xml');
sr_out = fullfile(beats_out_folder,'sr');
ptr.reset_simulation;
ptr.run_beats( struct(  'SCENARIO',cfg_srout,...
    'SIM_DT','5',...
    'OUTPUT_PREFIX',sr_out,...
    'RUN_MODE','fw_fr_split_output',...
    'OUTPUT_DT','300',...
    'SPLIT_LOGGER_PREFIX',sr_out,...
    'SPLIT_LOGGER_DT','300') );
% ptr.plot_performance

% plot
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range);
plot_simulation_data

% 9 Load and save offramp split ratios to xml (used for rm scenarios) ..
link_id_begin_end = ptr.scenario_ptr.link_id_begin_end;
link_ids = ptr.scenario_ptr.get_link_ids;
link_types = ptr.scenario_ptr.get_link_types;
fr_links_ids = link_ids(strcmp(link_types,'Off-Ramp'));
for i=1:length(fr_links_ids)
    
    begin_node = link_id_begin_end(link_id_begin_end(:,1)==fr_links_ids(i),2);
    
    % load computed node splits
    comp_sr = load(sprintf('%s%d.txt',sr_out,begin_node));
    
    % get existing split ratio profile
    [srp,srp_ind] = ptr.scenario_ptr.get_split_ratios_for_node_id(begin_node);
    
    % if we have it, extract splits and overwrite
    if(isempty(srp))
        error('BLA')
    end
    
    % replace all profiles in srp with corresponding values in comp_sr
    for j=1:length(srp.splitratio)
        link_in = srp.splitratio(j).ATTRIBUTE.link_in;
        link_out = srp.splitratio(j).ATTRIBUTE.link_out;
        vehicle_type_id = srp.splitratio(j).ATTRIBUTE.vehicle_type_id;
        
        ind = comp_sr(:,2)==link_in & comp_sr(:,3)==link_out & comp_sr(:,4)==vehicle_type_id;
        sr = comp_sr(ind,5);
        sr = sr(2:end);
        
        % replace old fr split
        ptr.scenario_ptr.scenario.SplitRatioSet.splitRatioProfile(srp_ind).splitratio(j).CONTENT = sr;
    end
end

% remove actuators/controllers
ptr.scenario_ptr.scenario = rmfield(ptr.scenario_ptr.scenario,{'ControllerSet','ActuatorSet'});

% NEED TO CHECK THAT THIS RUN GIVES SIMILAR RESULT TO FR DEMAND CONTROLLER RUN
cfg_srout2 = fullfile(cfg_gen_folder,'srout2.xml');
sr_out2 = fullfile(beats_out_folder,'sr2');
ptr.reset_simulation;
ptr.run_beats( struct( 'SCENARIO',cfg_srout2,...
    'SIM_DT','5',...
    'OUTPUT_PREFIX',sr_out2,...
    'OUTPUT_DT','300',...
    'SPLIT_LOGGER_PREFIX',sr_out2 ) );
ptr.plot_performance

% plot
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range);
plot_simulation_data

% Attach ramp metering actuators and controllers ..................
act_and_ctrl = xml_read(fullfile(Y.scenario_folder,[X.cntrl_suffix '.xml']));
ptr.scenario_ptr.scenario.ControllerSet = act_and_ctrl.ControllerSet;
ptr.scenario_ptr.scenario.ActuatorSet = act_and_ctrl.ActuatorSet;
ptr.scenario_ptr.scenario.SensorSet = act_and_ctrl.SensorSet;

% run scenario ....................................................
cfg_scenario = fullfile(cfg_gen_folder,['scenario_' X.cntrl_suffix '.xml']);
scenario_out = fullfile(beats_out_folder,['scenario_' X.cntrl_suffix]);
ptr.reset_simulation;
ptr.run_beats( struct(  'SCENARIO',cfg_scenario,...
    'SIM_DT','5',...
    'OUTPUT_PREFIX',scenario_out,...
    'OUTPUT_DT','300') );
%ptr.plot_performance



