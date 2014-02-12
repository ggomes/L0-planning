
clear
close all

ptr = ScenarioPtr;
ptr.load('680N_v2_control.xml');

link_ids = ptr.get_link_ids;
link_types = ptr.get_link_types;
node_ids = ptr.get_node_ids;

for i=1:length(ptr.scenario.NetworkSet.network.NodeList.node)
    
    clear nIn nOut in_link_id in_link_type out_link_id out_link_type

    N = ptr.scenario.NetworkSet.network.NodeList.node(i);
    
    nIn = length(N.inputs.input);
    for j=1:nIn
        in_link_id(j) = N.inputs.input(j).ATTRIBUTE.link_id;
        in_link_type{j} = link_types{link_ids==in_link_id(j)};
    end
    
    nOut = length(N.outputs.output);
    for j=1:nOut
        out_link_id(j) = N.outputs.output(j).ATTRIBUTE.link_id;
        out_link_type{j} = link_types{link_ids==out_link_id(j)};
    end
    
    if(nOut<=1)
        continue
    end
    
    in_fw = strcmp(in_link_type,'Freeway');
    in_hov = strcmp(in_link_type,'HOV');
    in_or = strcmp(in_link_type,'On-Ramp');
    out_fw = strcmp(out_link_type,'Freeway');
    out_hov = strcmp(out_link_type,'HOV');
    out_fr = strcmp(out_link_type,'Off-Ramp');
    
    if(any(in_fwy))
        
        if(any(out_hov))
            % no sov go to hov lane
            
            % all hov go to hov lane
            
        end
        
        if(any(out_fw))
            % 
            
        end
        
    end
    
    if(any(in_hv))
        
    end
    
    if(any(in_or))
        
    end
    
end



is_fr = strcmp(link_types,'Off-Ramp');

fr_info = ptr.link_id_begin_end(fr_ind,:);
num_fr = size(fr_info,1);

srs = generate_mo('SplitRatioSet');
srs.ATTRIBUTE.id = 0;
srs.ATTRIBUTE.project_id = 0;
srs.splitRatioProfile = repmat(generate_mo('splitRatioProfile'),1,num_fr);

for i=1:num_fr
    
    node_id = fr_info(i,2);
    
    srs.splitRatioProfile(i).ATTRIBUTE.id = i;
    srs.splitRatioProfile(i).ATTRIBUTE.node_id = node_id;
    
    ind = ptr.link_id_begin_end(:,3)==node_id;
    up_link_ids = ptr.link_id_begin_end(ind,1);
    link_types(ind)
    
    sr = repmat(generate_mo('splitratio'),1,2);
    for j=1:2
        sr(j).ATTRIBUTE.link_in = x;
        sr(j).ATTRIBUTE.link_out = fr_info(i,1);
        sr(j).ATTRIBUTE.vehicle_type_id = j-1;
    end
    srs.splitRatioProfile(i).splitratio = sr;
    clear sr
    
end