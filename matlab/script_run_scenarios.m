clear
close all

init_config;

% 1. Load basic network ..................................................
ptr = BeatsSimulation;
ptr.load_scenario(cfg_starter);

% 2. Load or demands from xls ............................................
ptr.scenario_ptr.scenario.DemandSet = attach_onramp_demands(xlsx_file,range,hov_prct);

% 3. Load initial guess at fr splits .....................................
ptr.scenario_ptr.scenario.SplitRatioSet = xml_read(sr_initial_guess);

% 4. Run greedy policy ...................................................
ptr.run_beats( struct( 'SCENARIO','..\\config\\680N_+RM_2013\\generated\\gp.xml',...
                       'SIM_DT','5',...
                       'OUTPUT_PREFIX','..\\beats_output\\gp',...
                       'SPLIT_LOGGER_PREFIX','..\\beats_output\\sr',...
                       'SPLIT_LOGGER_DT','300',...
                       'OUTPUT_DT','5' ) );
ptr.plot_performance

% 5. aggregate GP/HOV split ratios to 5min ...............................
is_5min_gp = ~isempty(strfind(beatsprop_gp,'beats_gp_5min.properties'));
ptr.scenario_ptr.scenario.SplitRatioSet = compute_5min_splits_from_sim(ptr,gp_out,is_5min_gp);

% 6. Take fr demands from xls to xml .....................................
write_offramp_demand_xml(xlsx_file,fr_demand_file,range)

% 7. Load split actuators/controllers .....................................
act_and_ctrl = xml_read(sr_act_cntrl);
act_and_ctrl.ControllerSet.controller.parameters.parameter.ATTRIBUTE.value = ...
    fullfile(cfg_gen_folder,'fr_demand.xml');
ptr.scenario_ptr.scenario.ControllerSet = act_and_ctrl.ControllerSet;
ptr.scenario_ptr.scenario.ActuatorSet = act_and_ctrl.ActuatorSet;

% 8. Run offramp split ratio computation .................................
ptr.reset_simulation;
ptr.run_beats( struct( 'SCENARIO','..\\config\\680N_+RM_2013\\generated\\srout.xml',...
                       'SIM_DT','5',...
                       'OUTPUT_PREFIX','..\\beats_output\\srout',...
                       'RUN_MODE','fw_fr_split_output',...
                       'OUTPUT_DT','300',...
                       'SPLIT_LOGGER_PREFIX','..\\beats_output\\sr' ) );
ptr.plot_performance

% 8 Load and save offramp split ratios to xml (used for rm scenarios) ..
link_id_begin_end = ptr.scenario_ptr.link_id_begin_end;
link_ids = ptr.scenario_ptr.get_link_ids;
link_types = ptr.scenario_ptr.get_link_types;
fr_links_ids = link_ids(strcmp(link_types,'Off-Ramp'));
srps = [];
for i=1:length(fr_links_ids)
        
    begin_node = link_id_begin_end(link_id_begin_end(:,1)==fr_links_ids(i),2);
    
    % load computed fr split
    comp_sr = load(fullfile(root,'beats_output',sprintf('sr%d.txt',begin_node)));
    
    % keep only splits going to offramp
    comp_sr = comp_sr(comp_sr(:,3)==fr_links_ids(i),:);
    
    % get existing split ratio profile
    [srp,srp_ind] = ptr.scenario_ptr.get_split_ratios_for_node_id(begin_node);
    
    % if we have it, extract splits and overwrite
    if(~isempty(srp))

        A = [srp.splitratio.ATTRIBUTE];
        
        % get splits fwy/HOV -> offramp splits
        [~,x]=ismember([A.link_in],link_ids);
        ind = strcmp(link_types(x),'Freeway') | strcmp(link_types(x),'HOV');
        ind = ind & [A.link_out]==fr_links_ids(i);
        ind = find(ind);
        
        if(length(ind)~=2 && length(ind)~=4)
            error('I was expecting 2 or 4.')
        end
                
        for j=1:length(ind)

            link_in = srp.splitratio(ind(j)).ATTRIBUTE.link_in;
            veh_type = srp.splitratio(ind(j)).ATTRIBUTE.vehicle_type_id;
            
            % computed split ratio
            new_fr_split = comp_sr(comp_sr(:,2)==link_in & comp_sr(:,4)==veh_type,5);
        
            % aggregate to 5 min
            new_fr_split = mean(reshape(new_fr_split(2:end),60,288),1);
            
            % replace old fr split
            ptr.scenario_ptr.scenario.SplitRatioSet.splitRatioProfile(srp_ind).splitratio(ind(j)).CONTENT = new_fr_split;
            
        end
        
    end
end

% remove actuators/controllers
ptr.scenario_ptr.scenario = rmfield(ptr.scenario_ptr.scenario,{'ControllerSet','ActuatorSet'});

% NEED TO CHECK THAT THIS RUN GIVES SIMILAR RESULT TO FR DEMAND CONTROLLER RUN
ptr.reset_simulation;
ptr.run_beats( struct( 'SCENARIO','..\\config\\680N_+RM_2013\\generated\\srout_2.xml',...
                       'SIM_DT','5',...
                       'OUTPUT_PREFIX','..\\beats_output\\srout_2',...
                       'OUTPUT_DT','300',...
                       'SPLIT_LOGGER_PREFIX','..\\beats_output\\sr' ) );
ptr.plot_performance

% % 9. Put the result into Excel spreadsheet ...............................
% disp('9. Put the result into Excel spreadsheet')
% tic
% [GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range);
% disp(['Done in ' num2str(toc) ' seconds.']); 

% Attach ramp metering actuators and controllers .........................
act_and_ctrl = xml_read(rm_act_cntrl);
ptr.scenario_ptr.scenario.ControllerSet = act_and_ctrl.ControllerSet;
ptr.scenario_ptr.scenario.ActuatorSet = act_and_ctrl.ActuatorSet;
ptr.scenario_ptr.scenario.SensorSet = act_and_ctrl.SensorSet;

% run scenario
ptr.reset_simulation;
ptr.run_beats( struct( 'SCENARIO','..\\config\\680N_+RM_2013\\680_rm_nooverride_up.xml',...
                       'SIM_DT','5',...
                       'OUTPUT_PREFIX','..\\beats_output\\680_rm_nooverride_up',...
                       'OUTPUT_DT','300') );
ptr.plot_performance



