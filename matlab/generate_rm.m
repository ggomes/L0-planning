function [] = generate_rm(config_file,out_file,up_or_down,gain_value,queue_limit)

ptr = ScenarioPtr;
ptr.load(config_file);

has_queue_override = ~isinf(queue_limit);

link_types = ptr.get_link_types;
link_ids = ptr.get_link_ids;
is_onramp = strcmp(link_types,'On-Ramp');
num_onramps = sum(is_onramp);
onramp_ids = link_ids(is_onramp);
link_id_begin_end = ptr.get_link_id_begin_end;

%% create basic structures ................................................

% actuators
p_max_queue_vehicles = generate_mo('parameter');
p_max_queue_vehicles.ATTRIBUTE.name = 'max_queue_vehicles';
p_max_queue_vehicles.ATTRIBUTE.value = nan;
p_max_rate = generate_mo('parameter');
p_max_rate.ATTRIBUTE.name = 'max_rate_in_vphpl';
p_max_rate.ATTRIBUTE.value = 900;
p_min_rate = generate_mo('parameter');
p_min_rate.ATTRIBUTE.name = 'min_rate_in_vphpl';
p_min_rate.ATTRIBUTE.value = 240;
a_actuator = struct( ...
    'ATTRIBUTE',struct('id',nan) , ...
    'scenarioElement', struct('ATTRIBUTE',struct('id',nan,'type','link')) , ...
    'actuator_type', struct('ATTRIBUTE',struct('id',0,'name','ramp_meter')) , ...
    'parameters',struct('parameter',[p_max_queue_vehicles p_max_rate p_min_rate]),...
    'queue_override', struct('ATTRIBUTE',struct('strategy','max_rate')) );
if(~has_queue_override)
    a_actuator = rmfield(a_actuator,{'queue_override'});
end
actuators = repmat(a_actuator,1,num_onramps);
clear a_actuator

% sensors
a_sensor = struct( 'ATTRIBUTE', struct('id',nan,'link_id',nan) , ...
                   'sensor_type', struct('ATTRIBUTE',struct('id',0,'name','loop') ) );
sensors = repmat(a_sensor,1,num_onramps);

% controllers
a_controller = generate_mo('controller',true);
a_controller = rmfield(a_controller,{'ActivationIntervals','table'});
a_controller.ATTRIBUTE = rmfield(a_controller.ATTRIBUTE,{'name','mod_stamp','crudFlag'});
a_controller.ATTRIBUTE.enabled = 'true';
a_controller.ATTRIBUTE.dt = 300;
a_controller.ATTRIBUTE.type = 'IRM_ALINEA';
a_controller.parameters = rmfield(a_controller.parameters,{'description','ATTRIBUTE'});
a_parameter = struct('ATTRIBUTE',struct('name','','value',nan));
a_controller.parameters.parameter = repmat(a_parameter,1,1);
a_controller.parameters.parameter(1).ATTRIBUTE.name = 'gain';
a_controller.parameters.parameter(1).ATTRIBUTE.value = gain_value;
a_controller.feedback_sensors.feedback_sensor = struct('ATTRIBUTE',struct('id',nan,'usage','mainline'));
a_controller.target_actuators.target_actuator = struct('ATTRIBUTE',struct('id',nan));
controllers = repmat(a_controller,1,num_onramps);
clear a_controller

%% populate ...............................................................

for i=1:num_onramps
    
    % actuators
    actuators(i).ATTRIBUTE.id = i;
    actuators(i).scenarioElement.ATTRIBUTE.id = onramp_ids(i);
    if(has_queue_override)
        actuators(i).parameters.parameter(1).ATTRIBUTE.value = queue_limit;
    end
    
    % sensors
    sensors(i).ATTRIBUTE.id = i;
    end_node = link_id_begin_end(link_id_begin_end(:,1)==onramp_ids(i),3);
    switch(up_or_down)
        case 'up'
            some_links = link_id_begin_end(link_id_begin_end(:,3)==end_node,1);
        case 'down'
            some_links = link_id_begin_end(link_id_begin_end(:,2)==end_node,1);
        otherwise
            error('incorrect value for up_or_down')
    end
    [~,ind]=ismember(some_links,link_ids);
    sensors(i).ATTRIBUTE.link_id = some_links(strcmp(link_types(ind),'Freeway'));
    if(length(sensors(i).ATTRIBUTE.link_id)~=1)
        error('zero or multiple candidates for placing a feedback sensor')
    end
    
    % controllers
    controllers(i).ATTRIBUTE.id = i;
    controllers(i).feedback_sensors.feedback_sensor.ATTRIBUTE.id = sensors(i).ATTRIBUTE.id;
    controllers(i).target_actuators.target_actuator.ATTRIBUTE.id = actuators(i).ATTRIBUTE.id;
end

%% put into sets ..........................................................
newptr = ScenarioPtr;

newptr.scenario.ActuatorSet = struct('ATTRIBUTE',struct('project_id',0,'id',0));
newptr.scenario.ActuatorSet.actuator = actuators;
clear actuators

newptr.scenario.SensorSet = struct('ATTRIBUTE',struct('project_id',0,'id',0));
newptr.scenario.SensorSet.sensor = sensors;
clear sensors

newptr.scenario.ControllerSet = struct('ATTRIBUTE',struct('project_id',0,'id',0));
newptr.scenario.ControllerSet.controller = controllers;
clear controllers

%% attach to scenario and save ............................................
% ptr.scenario.ActuatorSet = ActuatorSet;
% ptr.scenario.SensorSet = SensorSet;
% ptr.scenario.ControllerSet = ControllerSet;
newptr.save(out_file);


