clear
close all

load 680N_v2_givensr

% preliminary
vt_ids = [0 1];
numVt = length(vt_ids);
num_nodes = ptr.scenario_ptr.get_num_nodes;
node_ids = ptr.scenario_ptr.get_node_ids;
link_ids = ptr.scenario_ptr.get_link_ids;

% is_trivial_split , non_trivial_node_ids
is_trivial_split = nan(1,num_nodes);
for i=1:num_nodes
    node_io = ptr.scenario_ptr.get_node_io(node_ids(i));
    is_trivial_split(i) = length(node_io.link_out)<=1;
end
non_trivial_node_ids = sort(node_ids(~is_trivial_split));

% cycle through non-trivial nodes
time_5min_ind = reshape(1:17280,288,60);
time_5min = (0:300:86100)';

srp = generate_mo('splitRatioProfile');
srp.ATTRIBUTE.dt = 300;
SplitRatioSet = generate_mo('SplitRatioSet');
SplitRatioSet.ATTRIBUTE.id = 0;
SplitRatioSet.ATTRIBUTE.project_id = 0;
SplitRatioSet.splitRatioProfile = repmat(srp,1,length(non_trivial_node_ids));

    sr = generate_mo('splitratio');
    sr.CONTENT = '';
clear srp

for i=1:length(non_trivial_node_ids)
    
    i
    
    node_id = non_trivial_node_ids(i);
    node_io = ptr.scenario_ptr.get_node_io(node_id);
    sr_data = load(['sr_' num2str(node_id) '.txt']);
    time_5sec = sort(unique(sr_data(:,1)));
    numIn = length(node_io.link_in);
    numOut = length(node_io.link_out);
    numT = length(time_5sec);

    SplitRatioSet.splitRatioProfile(i).ATTRIBUTE.id = i;
    SplitRatioSet.splitRatioProfile(i).ATTRIBUTE.node_id = node_id;
    SplitRatioSet.splitRatioProfile(i).splitratio = repmat(sr,1,numIn*numOut*numVt);
    
    c = 0;
    for ii=1:numIn
 
        link_in_ind = node_io.link_in(ii)==link_ids;

  
        for kk=1:numVt

    
            % fin
            fin = ptr.outflow_veh{kk}(:,link_in_ind);
            fin = fin(time_5min_ind);
            
            for jj=1:numOut

                % fout
                link_out_ind = node_io.link_out(jj)==link_ids;
                fout = ptr.inflow_veh{kk}(:,link_out_ind);
                fout = fout(time_5min_ind);
                
                % beta
                beta = sr_data(sr_data(:,2)==node_io.link_in(ii) & ...
                               sr_data(:,3)==node_io.link_out(jj) & ...
                               sr_data(:,4)==vt_ids(kk),5);
                beta = beta(1:end-1);
                beta = beta(time_5min_ind);
                
                Fd = sum(beta.*fin,2);
                Fu = sum(fin,2);
                beta_5min = Fd./Fu;
                
                c=c+1;
                SplitRatioSet.splitRatioProfile(i).splitratio(c).ATTRIBUTE.link_in = node_io.link_in(ii);
                SplitRatioSet.splitRatioProfile(i).splitratio(c).ATTRIBUTE.link_out = node_io.link_out(jj);
                SplitRatioSet.splitRatioProfile(i).splitratio(c).ATTRIBUTE.vehicle_type_id = vt_ids(kk);
                SplitRatioSet.splitRatioProfile(i).splitratio(c).CONTENT = writecommaformat(beta_5min,'%f');

            end
        end
    end
    
    
    
    
end

clear sr_data time_* beta fin fout Fd Fu beta_5min

xml_write('sr_from_sim.xml',SplitRatioSet)

