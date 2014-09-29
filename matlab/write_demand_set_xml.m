function write_demand_set_xml(fid, xlsx_file, range, or_id, ORS)
% ORS - configuration table for specially treated on-ramps
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% or_id - array of on-ramp link IDs
% ORS - configuration table for specially treated on-ramps

disp('  C. Generating demand set...');

% Link IDs
hov_prct = xlsread(xlsx_file, 'Configuration', sprintf('c%d:c%d', range(1), range(2)))';
ORD = xlsread(xlsx_file, 'On-Ramp_CollectedFlows', sprintf('k%d:kl%d', range(1), range(2)));
ORK = xlsread(xlsx_file, 'On-Ramp_Knobs', sprintf('k%d:kl%d', range(1), range(2)));
ORGF = xlsread(xlsx_file, 'On-Ramp_GrowthFactors', sprintf('k%d:kl%d', range(1), range(2)));
ORD = ORD .* ORK .* ORGF;


sz = range(2) - range(1) + 1;

fprintf(fid, ' <DemandSet id="1" name="onramps" project_id="1">\n');

for i = 1:sz
  if or_id(i) ~= 0
    ors = find_or_struct(ORS, or_id(i));
    if isempty(ors)
      write_demand_profile_xml(fid, or_id(i), ORD(i, :), hov_prct(i));
    else      
      if isempty(ors.feeders)
        links = ors.peers;
      else      
        links = ors.feeders;
      end
      in_count = size(links, 2);
      for j = 1:in_count
        idx = (j - 1) * 4 + 1;
        ord = ors.data(idx, :) .* ors.data(idx + 1, :) .* ors.data(idx + 2, :) .* ors.data(idx + 3, :);
        write_demand_profile_xml(fid, links(j), ord, hov_prct(i));
      end
    end
  end
end

fprintf(fid, ' </DemandSet>\n\n');

return;





function write_demand_profile_xml(fid, or_id, demand, hov_prct)
% fid - file descriptor for the output xml
% or_id - on-ramp ID
% demand - array of total demand values
% hov_prct - HOV portion of total demand

sz = size(demand, 2);
hov_d = hov_prct * demand;
gp_d = demand - hov_d;

fprintf(fid, '   <demandProfile id="%d" link_id_org="%d" dt="300" start_time="0">\n', or_id, or_id);

fprintf(fid, '    <demand vehicle_type_id="0">%f', hov_d(1));
for i = 2:sz
  fprintf(fid, ',%f', hov_d(i));  
end
fprintf(fid, '</demand>\n');

fprintf(fid, '    <demand vehicle_type_id="1">%f', gp_d(1));
for i = 2:sz
  fprintf(fid, ',%f', gp_d(i));  
end
fprintf(fid, '</demand>\n');

fprintf(fid, '   </demandProfile>\n');

return;
