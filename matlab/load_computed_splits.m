function [ srp ] = load_computed_splits( folder, node_id )

file = fullfile(folder,['sr-' num2str(node_id) '.txt']);
SR = load(file);
% unique_node_id = unique(SR(:,2));
asr = generate_mo('splitratio');
asr.CONTENT = [];
srp = generate_mo('splitRatioProfile');
srp.ATTRIBUTE.dt = 300;
srp.splitratio = asr;
srp.ATTRIBUTE.id = node_id;
srp.ATTRIBUTE.node_id = node_id;

in_link_id = unique(SR(:,2));
out_link_id = unique(SR(:,3));
vehicle_type = unique(SR(:,4));

all_sr = [];
for ii=1:length(in_link_id)
    for jj=1:length(out_link_id)
        for kk=1:length(vehicle_type)
            ind = in_link_id(ii)==SR(:,2) & out_link_id(jj)==SR(:,3) & vehicle_type(kk)==SR(:,4);
            if(~any(ind))
                continue
            end
            new_sr = asr;
            new_sr.ATTRIBUTE.link_in = in_link_id(ii);
            new_sr.ATTRIBUTE.link_out = out_link_id(jj);
            new_sr.ATTRIBUTE.vehicle_type_id = vehicle_type(kk);
            new_sr.CONTENT = SR(ind,5);
            all_sr = [all_sr new_sr];
        end
    end
end
srp.splitratio = all_sr;




