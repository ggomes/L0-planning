clear 
close all

root = fileparts(fileparts(mfilename('fullpath')));

start_config = fullfile(root,'config','680S','680S.xml');
end_config = fullfile(root,'config','680S_Scenario_1','680S_hov.xml');

ptr = ScenarioPtr;
ptr.load(start_config);

[fwy_links,hov_links,ordered_nodes_ids] = ptr.extract_linear_fwy;

add_hov_fwy_links = fwy_links(find(fwy_links==-35):find(fwy_links==-52));
       
node_ids = ptr.get_node_ids;
node_output = ptr.scenario.NetworkSet.network.NodeList.node(1).outputs.output(1);
node_input = ptr.scenario.NetworkSet.network.NodeList.node(1).inputs.input(1);

max_link_id = max(ptr.link_id_begin_end(:,1));

fd_link_map = ptr.get_fd_link_map;
max_fd_id = max(fd_link_map,1);

add_hov_links = [];
add_hov_fds = [];
for i=1:length(add_hov_fwy_links)
    
    i 
    
    %  create hov link
    new_hov_link_id = max_link_id + i;
    new_hov_link = ptr.get_link_byID(add_hov_fwy_links(i));
    new_hov_link.link_type.ATTRIBUTE.name = 'HOV';
    new_hov_link.ATTRIBUTE.id = new_hov_link_id;
    new_hov_link.ATTRIBUTE.link_name = ['HOV ' new_hov_link.ATTRIBUTE.link_name];
    
    add_hov_links = [add_hov_links new_hov_link];
    
    link_ind = ptr.link_id_begin_end(:,1)==add_hov_fwy_links(i);
    
    % modify begin node
    begin_node = ptr.link_id_begin_end(link_ind,2);
    begin_node_ind = begin_node==node_ids;
    new_node_output = node_output;
    new_node_output.ATTRIBUTE.link_id = new_hov_link_id;
    ptr.scenario.NetworkSet.network.NodeList.node(begin_node_ind).outputs.output(end+1) = new_node_output;
    
    % modify end node
    end_node = ptr.link_id_begin_end(link_ind,3);
    end_node_ind = end_node==node_ids;
    new_node_input = node_input;
    new_node_input.ATTRIBUTE.link_id = new_hov_link_id;
    ptr.scenario.NetworkSet.network.NodeList.node(end_node_ind).inputs.input(end+1) = new_node_input;
    
    % replicate the fd
    fd_ind = fd_link_map(:,2) == add_hov_fwy_links(i);
    if(~any(fd_ind))
        error('no fd')
    end
    new_hov_fd = ptr.scenario.FundamentalDiagramSet.fundamentalDiagramProfile(fd_ind);
    new_hov_fd.ATTRIBUTE.id = max_fd_id + i;
    new_hov_fd.ATTRIBUTE.link_id = new_hov_link_id;
    add_hov_fds = [add_hov_fds new_hov_fd];
    
end

% append links and fds
ptr.scenario.NetworkSet.network.LinkList.link = [ ...
    ptr.scenario.NetworkSet.network.LinkList.link add_hov_links];
ptr.scenario.FundamentalDiagramSet.fundamentalDiagramProfile = [ ...
    ptr.scenario.FundamentalDiagramSet.fundamentalDiagramProfile add_hov_fds ];

ptr.save(end_config)