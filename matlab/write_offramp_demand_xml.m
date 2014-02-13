function [] = write_offramp_demand_xml(xlsx_file,fr_demand_file,range)

fprintf('Generating off-ramp demand config...\n');
fr_id = xlsread(xlsx_file, 'Off-Ramp_Flows', sprintf('g%d:g%d', range(1), range(2)));
fr_id = fr_id';
FRD = xlsread(xlsx_file, 'Off-Ramp_Flows', sprintf('k%d:kl%d', range(1), range(2)));

dp = generate_mo('demandProfile');
dp.demand = generate_mo('demand');
dp.demand.CONTENT = '';
dp.demand.ATTRIBUTE.vehicle_type_id = 1;     % ignored
dps = repmat(dp,1,size(FRD,1));

for i=1:size(FRD,1)
    dps(i).ATTRIBUTE.id = i;
    dps(i).ATTRIBUTE.link_id_org = fr_id(i);
    dps(i).demand.CONTENT = writecommaformat(FRD(i,:),'%.2f');
end

DemandSet = generate_mo('DemandSet');
DemandSet.ATTRIBUTE.id = 2;
DemandSet.ATTRIBUTE.project_id = 1;
DemandSet.ATTRIBUTE.name = 'offramps';
DemandSet.demandProfile = dps;

xml_write(fr_demand_file,DemandSet);


