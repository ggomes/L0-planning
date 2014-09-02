function [ ptr ] = remove_hov_splits(ptr,hov_splits_file)
% provide a ScenarioPtr with a scenario and a file name with hov split
% ratios. These are -1s and 0s defining the hours of operation of the hov 
% lane. The script will go through the split ratios in the pointer, and 
% replaces them with profiles from the file wherever they are found. 

% read hov splits
sr = xml_read(hov_splits_file);
sr_nodes = nan(1,length(sr.splitRatioProfile));
for i=1:length(sr.splitRatioProfile)
    sr_nodes(i) = sr.splitRatioProfile(i).ATTRIBUTE.node_id;
end

link_types = ptr.get_link_types;
link_ids = ptr.get_link_ids;
is_hov = strcmpi(link_types,'hov');
is_mnl = strcmpi(link_types,'freeway');
hov_ids = link_ids(is_hov);
mnl_ids = link_ids(is_mnl);

if(~isfieldRecursive(ptr.scenario,'SplitRatioSet','splitRatioProfile'))
    return;
end

% remove_srp = false(1,length(ptr.scenario.SplitRatioSet.splitRatioProfile));
for i=1:length(ptr.scenario.SplitRatioSet.splitRatioProfile)
    srp = ptr.scenario.SplitRatioSet.splitRatioProfile(i);
    
    % find corresponding profile in sr
    sr_ind = srp.ATTRIBUTE.node_id==sr_nodes;
    if(~any(sr_ind))
        continue
    end
    
    % buuild list of link_in and link_out in sr profile
    sr_io = nan(length(sr.splitRatioProfile(sr_ind).splitratio),3);
    for j=1:length(sr.splitRatioProfile(sr_ind).splitratio)
        sr_io(j,1) = sr.splitRatioProfile(sr_ind).splitratio(j).ATTRIBUTE.link_in;
        sr_io(j,2) = sr.splitRatioProfile(sr_ind).splitratio(j).ATTRIBUTE.link_out;
        sr_io(j,3) = sr.splitRatioProfile(sr_ind).splitratio(j).ATTRIBUTE.vehicle_type_id;
    end

    % loop through srp
    for j=1:length(srp.splitratio)
        link_in = srp.splitratio(j).ATTRIBUTE.link_in;
        link_out = srp.splitratio(j).ATTRIBUTE.link_out;
        vehicle_type_id = srp.splitratio(j).ATTRIBUTE.vehicle_type_id;
        
        % find corresponding row in sr_io
        sr_io_ind = sr_io(:,1)==link_in & sr_io(:,2)==link_out & sr_io(:,3)==vehicle_type_id;
        
        if(~any(sr_io_ind))
            continue
        end
        
        % determine whether this is a ml/hov mixing split
        in_is_mnl_or_hov = ismember(link_in,hov_ids) || ismember(link_in,mnl_ids);
        out_is_mnl_or_hov = ismember(link_out,hov_ids) || ismember(link_out,mnl_ids);
        is_mixing_split = in_is_mnl_or_hov && out_is_mnl_or_hov;
        
        % if so, replace with value in sr
        if(is_mixing_split)
            ptr.scenario.SplitRatioSet.splitRatioProfile(i).splitratio(j).CONTENT = ...
                sr.splitRatioProfile(sr_ind).splitratio(sr_io_ind).CONTENT;
        end
        
    end
        
end

