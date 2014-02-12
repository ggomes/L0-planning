clear
close all

load 680N_v2_givensr_sim

vt_ids = [0 1];

num_nodes = ptr.scenario_ptr.get_num_nodes;
node_ids = ptr.scenario_ptr.get_node_ids;
link_ids = ptr.scenario_ptr.get_link_ids;

is_trivial_split = nan(1,num_nodes);
for i=1:num_nodes
    node_io = ptr.scenario_ptr.get_node_io(node_ids(i));
    is_trivial_split(i) = length(node_io.link_out)<=1;
end
non_trivial_node_ids = sort(node_ids(~is_trivial_split));

for i=1:length(non_trivial_node_ids)
    node_id = non_trivial_node_ids(i);
    node_io = ptr.scenario_ptr.get_node_io(node_id);

    
    numIn = length(node_io.link_in);
    numOut = length(node_io.link_out);
    numVt = length(vt_ids);
    
    
    for ii=1:numIn
        for jj=1:numOut
            for kk=1:numVt
                
                link_in = node_io.link_in(ii);
                link_out = node_io.link_out(jj);
                vt_id = vt_ids(kk);
                
                link_in_ind = link_in==link_ids;
                link_out_ind = link_out==link_ids;
                
                fin = ptr.outflow_veh{kk}(:,link_in_ind);
                fout = ptr.inflow_veh{kk}(:,link_out_ind);
                
                beta = fout./fin
                

                ind = x(:,2)==node_io.link_in(ii) & x(:,3)==node_io.link_out(jj) & x(:,4)==vt_ids(kk);
                if(~any(ind))
                    error('!!!!!!!!')
                end
                beta(k,ii,jj,kk) = x(ind,5);
            end
        end
    end
    
    
    
end
