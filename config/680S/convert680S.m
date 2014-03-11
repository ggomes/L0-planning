clear
close all

scenario = xml_read('680S_hand_modified_from_original.xml');

%% node type
num_nodes = length(scenario.NetworkSet.network.NodeList.node);
anode = generate_mo('node',true);
anode = rmfield(anode,{'roadway_markers'});
anode.ATTRIBUTE = rmfield(anode.ATTRIBUTE,{'crudFlag','in_sync','mod_stamp'});
node = repmat(anode,1,num_nodes);
x = CCTypes.get_type_with_name('node','Freeway');
node_fwy_type = struct('ATTRIBUTE',struct('id',x.id,'name',x.name));
x = CCTypes.get_type_with_name('node','Terminal');
node_trm_type = struct('ATTRIBUTE',struct('id',x.id,'name',x.name));
for i=1:num_nodes
    N = scenario.NetworkSet.network.NodeList.node(i);
    node(i).outputs = N.outputs;
    node(i).position = N.position;
    node(i).ATTRIBUTE.id = N.ATTRIBUTE.id;
    node(i).ATTRIBUTE.node_name = N.ATTRIBUTE.name;
    if(~isempty(N.inputs))
        for j=1:length(N.inputs.input)
            node(i).inputs.input(j).ATTRIBUTE.link_id = N.inputs.input(j).ATTRIBUTE.link_id;
        end
    else
        node(i).inputs = rmfield(node(i).inputs,'input');
    end
    
    switch(N.ATTRIBUTE.type)
        case 'F'
            node(i).node_type = node_fwy_type;
        case 'T'
            node(i).node_type = node_trm_type;
    end
end
scenario.NetworkSet.network.NodeList.node = node';
clear node x anode

%% link type
num_links = length(scenario.NetworkSet.network.LinkList.link);
alink = generate_mo('link',true);
alink = rmfield(alink,{'shape','roads','dynamics','position'});
alink.ATTRIBUTE = rmfield(alink.ATTRIBUTE,{'crudFlag','lane_offset','speed_limit','mod_stamp','in_sync'});
link = repmat(alink,1,num_links);

x = CCTypes.get_type_with_name('link','Freeway');
link_fwy_type = struct('ATTRIBUTE',struct('id',x.id,'name',x.name));

x = CCTypes.get_type_with_name('link','On-Ramp');
link_or_type = struct('ATTRIBUTE',struct('id',x.id,'name',x.name));

x = CCTypes.get_type_with_name('link','Off-Ramp');
link_fr_type = struct('ATTRIBUTE',struct('id',x.id,'name',x.name));

x = CCTypes.get_type_with_name('link','HOV');
link_hov_type = struct('ATTRIBUTE',struct('id',x.id,'name',x.name));

for i=1:num_links
    L = scenario.NetworkSet.network.LinkList.link(i);
    fd(i) = L.fd;
    link(i).begin = L.begin;
    link(i).end = L.xEnd;
    link(i).ATTRIBUTE.id = L.ATTRIBUTE.id;
    link(i).ATTRIBUTE.lanes = L.ATTRIBUTE.lanes;
    link(i).ATTRIBUTE.length = L.ATTRIBUTE.length/5280;
    link(i).ATTRIBUTE.link_name = L.ATTRIBUTE.name;
    switch(L.ATTRIBUTE.type)
        case 'FW'
            link(i).link_type = link_fwy_type;
        case 'OR'
            link(i).link_type = link_or_type;
        case 'FR'
            link(i).link_type = link_fr_type;
        case 'HOV'
            link(i).link_type = link_hov_type;
    end
end
scenario.NetworkSet.network.LinkList.link = link';
clear link x alink

%% fd
fdp = generate_mo('fundamentalDiagramProfile',true);
fdp = rmfield(fdp,{'calibrationAlgorithmType','fundamentalDiagramType'});
fdp.ATTRIBUTE = rmfield(fdp.ATTRIBUTE,{'crudFlag','sensor_id','start_time','dt','mod_stamp','agg_run_id'});
fdp.fundamentalDiagram = generate_mo('fundamentalDiagram');
fdp = repmat(fdp,1,num_links);
for i=1:num_links
    rhoc = fd(i).ATTRIBUTE.densityCritical;
    rhoj = fd(i).ATTRIBUTE.densityJam;
    fmax = fd(i).ATTRIBUTE.flowMax;
    fdp(i).ATTRIBUTE.id = i;
    fdp(i).ATTRIBUTE.link_id = scenario.NetworkSet.network.LinkList.link(i).ATTRIBUTE.id;
    
    capacity = fmax;
    congestion_speed = fmax / (rhoj-rhoc);
    free_flow_speed = fmax / rhoc;
    
    capacity = round(capacity*10)/10;
    congestion_speed = round(congestion_speed*10)/10;
    free_flow_speed = round(free_flow_speed*10)/10;
    
    fdp(i).fundamentalDiagram.ATTRIBUTE.id = i;
    fdp(i).fundamentalDiagram.ATTRIBUTE.capacity = capacity;
    fdp(i).fundamentalDiagram.ATTRIBUTE.congestion_speed = congestion_speed;
    fdp(i).fundamentalDiagram.ATTRIBUTE.free_flow_speed = free_flow_speed;
end
scenario.FundamentalDiagramSet = struct('ATTRIBUTE',struct('id',0,'project_id',0));
scenario.FundamentalDiagramSet.fundamentalDiagramProfile = fdp;
clear fdp

%% write
xml_write('680S.xml',scenario)


disp('done')