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

% 8.5 Load and save offramp split ratios to xml (used for rm scenarios) ..
link_id_begin_end = ptr.scenario_ptr.link_id_begin_end;
link_ids = ptr.scenario_ptr.get_link_ids;
link_types = ptr.scenario_ptr.get_link_types;
fr_links_ids = link_ids(strcmp(link_types,'Off-Ramp'));
srps = [];
for i=1:length(fr_links_ids)
    
    begin_node = link_id_begin_end(link_id_begin_end(:,1)==fr_links_ids(i),2);
    srp = ptr.scenario_ptr.get_split_ratios_for_node_id(begin_node);
    if(~isempty(srp))

        A = [srp.splitratio.ATTRIBUTE];
        
        [~,x]=ismember([A.link_in],link_ids);
        ind = strcmp(link_types(x),'Freeway') | strcmp(link_types(x),'HOV');
        ind = ind & [A.link_out]==fr_links_ids(i);
        
        if(sum(ind)~=4)
            error('I was expecting 4.')
        end
        
        xxx = srp.splitratio(ind);
        
        for j=1:length(xxx)
            xxx(1).CONTENT

            xxx(2).ATTRIBUTE
        
        end
        
        
    end
end


% 9. Put the result into Excel spreadsheet ...............................
disp('9. Put the result into Excel spreadsheet')
tic
[GP_V, GP_F, GP_D, HOV_V, HOV_F, HOV_D, ORD, ORF, FRD, FRF, ORQ] = extract_simulation_data(ptr,xlsx_file,range);
disp(['Done in ' num2str(toc) ' seconds.']); 

