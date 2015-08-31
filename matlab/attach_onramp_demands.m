function [DemandSet] = attach_onramp_demands(xlsx_file,range,hov_prct)

sov_prct = 1-hov_prct;

fprintf('Generating on-ramp demand config...\n');
or_id = xlsread(xlsx_file, 'On-Ramp_CollectedFlows', sprintf('g%d:g%d', range(1), range(2)));
or_id = or_id';
ORD = xlsread(xlsx_file, 'On-Ramp_CollectedFlows', sprintf('k%d:kl%d', range(1), range(2)));
ORK = xlsread(xlsx_file, 'On-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
ORD = ORD .* ORK;
has_or_dem = find(max(ORD,[],2)>0);

dp = generate_mo('demandProfile');
dp.ATTRIBUTE.dt = 300;
d = generate_mo('demand');
d.CONTENT = '';
dp.demand = repmat(d,1,2);
dp.demand(1).ATTRIBUTE.vehicle_type_id = 1;     % sov
dp.demand(2).ATTRIBUTE.vehicle_type_id = 0;     % hov
dps = repmat(dp,1,length(has_or_dem));
for i=1:length(has_or_dem)    
    dps(i).ATTRIBUTE.id = i;
    dps(i).ATTRIBUTE.link_id_org = or_id(has_or_dem(i));
    dps(i).demand(1).CONTENT = sov_prct*ORD(has_or_dem(i),:);
    dps(i).demand(2).CONTENT = hov_prct*ORD(has_or_dem(i),:);
end

% put into scenario
DemandSet = generate_mo('DemandSet');
DemandSet.ATTRIBUTE.id = 1;
DemandSet.ATTRIBUTE.project_id = 1;
DemandSet.ATTRIBUTE.name = 'onramps';
DemandSet.demandProfile = dps;
