function [ srp ] = load_computed_splits( sr_cntrl_log )

SR = load(sr_cntrl_log);
unique_node_id = unique(SR(:,2));
asr = generate_mo('splitratio');
asr.CONTENT = [];
asrp = generate_mo('splitRatioProfile');
asrp.ATTRIBUTE.dt = 300;
asrp.splitratio = asr;
srp = repmat(asrp,1,length(unique_node_id));
clear asrp 
for i=1:length(unique_node_id)
    SRn = SR(SR(:,2)==unique_node_id(i),:);
    in_link_id = unique(SRn(:,3));
    out_link_id = unique(SRn(:,4));
    vehicle_type = unique(SRn(:,5));
    
    srp(i).ATTRIBUTE.id = i;
    srp(i).ATTRIBUTE.node_id = unique_node_id(i);
    
    all_sr = [];
    for ii=1:length(in_link_id)
        for jj=1:length(out_link_id)
            for kk=1:length(vehicle_type)
                ind = in_link_id(ii)==SRn(:,3) & out_link_id(jj)==SRn(:,4) & vehicle_type(kk)==SRn(:,5);
                if(~any(ind))
                    continue
                end
                new_sr = asr;
                new_sr.ATTRIBUTE.link_in = in_link_id(ii);
                new_sr.ATTRIBUTE.link_out = out_link_id(jj);
                new_sr.ATTRIBUTE.vehicle_type_id = vehicle_type(kk);
                new_sr.CONTENT = SRn(ind,6);
                all_sr = [all_sr new_sr];
            end
        end
    end
    srp(i).splitratio = all_sr;
end


