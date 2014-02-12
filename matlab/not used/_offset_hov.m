

clear
close all

ptr = ScenarioPtr;
ptr.load('C:\Users\gomes\Desktop\680\680N_shapes.xml');


% extract layout
ordered_ind = extract_linear_fwy_indices(ptr);
link_types = ptr.get_link_types;
link_ids = ptr.get_link_ids;
link_lanes = ptr.get_link_lanes;
numlinks = ptr.get_num_links;
sensor_link_map = ptr.get_sensor_link_map;
vds2id = ptr.get_sensor_vds2id_map;
layout = cell(length(ordered_ind),6);
for i=1:length(ordered_ind)
    layout{i,1} = i;
    link_id = link_ids(ordered_ind(i));
    layout{i,2} = link_id;
    layout{i,3} = link_types(ordered_ind(i));
    layout{i,4} = link_lanes(ordered_ind(i));
    layout{i,5} = ptr.link_id_begin_end(ordered_ind(i),2);
    layout{i,6} = ptr.link_id_begin_end(ordered_ind(i),3);
    ind=sensor_link_map(:,2)==link_id;
    if(any(ind))
        sensor_id = sensor_link_map(ind,1);
        layout{i,7} = writecommaformat(vds2id(ismember(vds2id(:,2),sensor_id),1),'%d');
    else
        layout{i,7} = '-';
    end
end

% actuators and controllers

frind = strcmp([layout{:,3}]','Off-Ramp');
fr_layout = layout(frind,:);
out_nodes = [fr_layout{:,5}]';
out_nodes = unique(out_nodes);

as = generate_mo('ActuatorSet',false);
as.ATTRIBUTE.id = 0;
as.ATTRIBUTE.project_id = 0;
actuator = struct('ATTRIBUTE',struct('id',nan),'scenarioElement',[],'actuator_type',[]);
actuator.scenarioElement.ATTRIBUTE = struct('id',nan,'type','node');
actuator.actuator_type.ATTRIBUTE = struct('id',0,'name','cms');
as.actuator = repmat(actuator,1,length(out_nodes));
clear actuator

cs = generate_mo('ControllerSet');
cs.ATTRIBUTE.id=0;
cs.ATTRIBUTE.project_id=0;
cs.controller = generate_mo('controller',true);
cs.controller = rmfield(cs.controller,{'controllerType','feedback_sensors','queue_controller','ActivationIntervals','table'});
cs.controller.ATTRIBUTE = rmfield(cs.controller.ATTRIBUTE,{'mod_stamp','crudFlag'});
cs.controller.ATTRIBUTE.enabled = 'true';
cs.controller.ATTRIBUTE.id = i;
cs.controller.parameters = generate_mo('parameters');
cs.controller.parameters.parameter = generate_mo('parameter');
cs.controller.parameters.parameter.ATTRIBUTE.name = 'fr_flow_file';
cs.controller.parameters.parameter.ATTRIBUTE.value = 'C:\\Users\\gomes\\Desktop\\680\\demand_set.xml';

ta = struct('ATTRIBUTE',struct('id',nan));
cs.controller.target_actuators.target_actuator = repmat(ta,1,length(out_nodes));
cs.controller.ATTRIBUTE.type = 'SR_Generator';
cs.controller.ATTRIBUTE.name = 'SR_Generator';
cs.controller.ATTRIBUTE.dt = 300;
% cs.controller = repmat(controller,1,size(fr_layout,1));

for i=1:length(out_nodes)    
    as.actuator(i).ATTRIBUTE.id = i;
    as.actuator(i).scenarioElement.ATTRIBUTE.id = out_nodes(i);
    cs.controller.target_actuators.target_actuator(i).ATTRIBUTE.id = i;
end
scenario.ActuatorSet = as;
scenario.ControllerSet = cs;
xml_write('C:\Users\gomes\Desktop\680\actuators_and_controllers.xml',scenario)

DemandSet = generate_mo('DemandSet');
DemandSet.ATTRIBUTE.id = 0;
DemandSet.ATTRIBUTE.project_id = 0;
DemandSet.demandProfile = repmat(generate_mo('demandProfile'),1,size(fr_layout,1));
for i=1:size(fr_layout,1) 
    DemandSet.demandProfile(i).ATTRIBUTE.id = i;
    DemandSet.demandProfile(i).ATTRIBUTE.link_id_org = fr_layout{i,2};
    DemandSet.demandProfile(i).demand = generate_mo('demand');
    DemandSet.demandProfile(i).demand.ATTRIBUTE.vehicle_type_id = 0;
    DemandSet.demandProfile(i).demand.CONTENT = '1,2,3,4,5';
end
xml_write('C:\Users\gomes\Desktop\680\demand_set.xml',DemandSet)


for i=1:ptr.get_num_links
    if(strcmp(link_types{i},'HOV'))
        ptr.scenario.NetworkSet.network.LinkList.link(i).ATTRIBUTE.lane_offset = 2;
    end
    if(strcmp(link_types{i},'Freeway'))
        ptr.scenario.NetworkSet.network.LinkList.link(i).ATTRIBUTE.lane_offset = -2;
    end
end

ptr.save('C:\Users\gomes\Desktop\680\680N_shapes_hov.xml');

disp('done')