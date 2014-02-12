clear
close all

load 680N_old_format.xml;

numlink = length(scenario.network.LinkList.link);
fdp = generate_mo('fundamentalDiagramProfile',true);
fdp.ATTRIBUTE = rmfield(fdp.ATTRIBUTE,{'crudFlag','sensor_id','start_time','dt','mod_stamp','agg_run_id'});
fdp = rmfield(fdp,{'fundamentalDiagramType','calibrationAlgorithmType'});
fdp.fundamentalDiagram = generate_mo('fundamentalDiagram');
fundamentalDiagramProfile = repmat(fdp,1,numlink);

for i=1:numlink
    L = scenario.network.LinkList.link(i);
    
    nc = L.fd.ATTRIBUTE.densityCritical;
    nj = L.fd.ATTRIBUTE.densityJam;
    F = L.fd.ATTRIBUTE.flowMax;
    
    fundamentalDiagramProfile(i).ATTRIBUTE.id = i;
    fundamentalDiagramProfile(i).ATTRIBUTE.link_id = L.ATTRIBUTE.id;
    fundamentalDiagramProfile(i).fundamentalDiagram.ATTRIBUTE.id = 0;
    fundamentalDiagramProfile(i).fundamentalDiagram.ATTRIBUTE.capacity = F;
    fundamentalDiagramProfile(i).fundamentalDiagram.ATTRIBUTE.free_flow_speed = round(10*F/nc)/10;
    fundamentalDiagramProfile(i).fundamentalDiagram.ATTRIBUTE.congestion_speed = round(10*F/(nj-nc))/10;
    
    
end

FundamentalDiagramSet = generate_mo('FundamentalDiagramSet');
FundamentalDiagramSet.ATTRIBUTE.id = 0;
FundamentalDiagramSet.ATTRIBUTE.project_id = 0;
FundamentalDiagramSet.fundamentalDiagramProfile = fundamentalDiagramProfile;

xml_write('fd.xml',FundamentalDiagramSet)
