clear
close all

load 680N_v2_givensr

vt_ids = [0 1];

num_nodes = ptr.get_num_nodes;
node_ids = ptr.get_node_ids;
num_srp = length(ptr.scenario.SplitRatioSet.splitRatioProfile);

srp_nodeid = nan(1,num_srp);
for i=1:num_srp
    srp_nodeid(i) = ptr.scenario.SplitRatioSet.splitRatioProfile(i).ATTRIBUTE.node_id;
end

link_id_begin_end = ptr.link_id_begin_end;
is_trivial_split = nan(1,num_nodes);
for i=1:num_nodes
    node_io = ptr.get_node_io(node_ids(i));
    is_trivial_split(i) = length(node_io.link_out)<=1;
end

non_trivial_node_ids = sort(node_ids(~is_trivial_split));

if(~isempty(setdiff(non_trivial_node_ids,srp_nodeid)) || ...
   ~isempty(setdiff(srp_nodeid,non_trivial_node_ids)) )
    error('asdfsadf')
end

for i=1:length(non_trivial_node_ids)
   
    node_id = non_trivial_node_ids(i);
    node_io = ptr.get_node_io(node_id);
    srp_ind = srp_nodeid==node_id;
    
    data = load(['sr_' num2str(node_id) '.txt']);
    t = sort(unique(data(:,1)));
    
    numIn = length(node_io.link_in);
    numOut = length(node_io.link_out);
    numVt = length(vt_ids);
    numT = length(t);
    
    beta = nan(numT,numIn,numOut,numVt);
    
    for k=1:numT
        k
        x = data(data(:,1)==t(k),:);
        for ii=1:numIn
            for jj=1:numOut
                for kk=1:numVt
                
                    ind = x(:,2)==node_io.link_in(ii) & x(:,3)==node_io.link_out(jj) & x(:,4)==vt_ids(kk);
                    if(~any(ind))
                        error('!!!!!!!!')
                    end
                    beta(k,ii,jj,kk) = x(ind,5);
                end
            end
        end
    end
    
    
    
    
    
end

    