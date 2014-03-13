function []=create_actuators_and_controllers(folder,config)
% e.g.
% folder='C:\Users\gomes\code\L0\L0-planning\config\680S';
% config='680S.xml';

ptr = ScenarioPtr;
ptr.load(fullfile(folder,config));


link_types = ptr.get_link_types;
link_id_begin_end = ptr.get_link_id_begin_end;
node_ids = ptr.get_node_ids;


is_offramp = strcmp(link_types,'Off-Ramp');

offramp_node_ids = link_id_begin_end(is_offramp,2);
num_actuators = length(offramp_node_ids);


actuator = repmat(struct('ATTRIBUTE',struct('id',nan) , ...
    'scenarioElement',struct('ATTRIBUTE',struct('id',nan,'type','node')),...
    'actuator_type',struct('ATTRIBUTE',struct('id',0,'name','cms'))) , ...
    1,num_actuators);


for i=1:num_actuators
    actuator(i).ATTRIBUTE.id = i;
    actuator(i).scenarioElement.ATTRIBUTE.id = offramp_node_ids(i);
end


controller.ATTRIBUTE.dt = 5;
controller.ATTRIBUTE.enabled='true'; 
controller.ATTRIBUTE.id=23; 
controller.ATTRIBUTE.name='SR_Generator'; 
controller.ATTRIBUTE.type='SR_Generator';
controller.parameters.parameter.ATTRIBUTE.name='fr_flow_file';
controller.parameters.parameter.ATTRIBUTE.value='';

for i=1:num_actuators
    controller.target_actuators.target_actuator(i).ATTRIBUTE.id = i;
end


scenario.ActuatorSet.ATTRIBUTE.id = 0;
scenario.ActuatorSet.ATTRIBUTE.project_id = 0;
scenario.ActuatorSet.actuator = actuator;
scenario.ControllerSet.ATTRIBUTE.id = 0;
scenario.ControllerSet.ATTRIBUTE.project_id = 0;
scenario.ControllerSet.controller = controller;

xml_write(fullfile(folder,'actuators_and_controllers.xml'),scenario)