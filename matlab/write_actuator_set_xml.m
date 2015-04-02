function metered = write_actuator_set_xml(fid, xlsx_file, range, or_id, ORS)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% or_id - array of on-ramp link IDs
% ORS - configuration table for specially treated on-ramps
%
% metered - array with the number of metered lanes

disp('  F. Generating actuator set...');



% On-ramp parameters
lanes = xlsread(xlsx_file, 'Configuration', sprintf('p%d:p%d', range(1), range(2)))';
metered = xlsread(xlsx_file, 'Configuration', sprintf('q%d:q%d', range(1), range(2)))';
min_rate = xlsread(xlsx_file, 'Configuration', sprintf('r%d:r%d', range(1), range(2)))';
max_rate = xlsread(xlsx_file, 'Configuration', sprintf('s%d:s%d', range(1), range(2)))';
qlimits = xlsread(xlsx_file, 'Configuration', sprintf('t%d:t%d', range(1), range(2)))';

sz = range(2) - range(1) + 1;

fprintf(fid, ' <ActuatorSet id="1" project_id="1">\n');
for i = 1:sz
  if (or_id(i) ~= 0) & (metered(i) ~= 0)
    ors = find_or_struct(ORS, or_id(i));
    if isempty(ors)
      ml = round(metered(i) / lanes(i));
      if ml < 1
        ml = metered(i);
      end
      mq = 100000;
      fprintf(fid, '  <actuator id="%d">\n', or_id(i));
      fprintf(fid, '   <scenarioElement id="%d" type="link"/>\n', or_id(i));
      fprintf(fid, '   <actuator_type id="0" name="ramp_meter"/>\n');
      if qlimits(i) ~= 0
        fprintf(fid, '   <queue_override strategy="max_rate"/>\n');
        mq = qlimits(i);
      end
      fprintf(fid, '   <parameters>\n');
      fprintf(fid, '    <parameter name="min_rate_in_vphpl" value="%d"/>\n', min_rate(i)*ml);
      fprintf(fid, '    <parameter name="max_rate_in_vphpl" value="%d"/>\n', max_rate(i)*ml);
      fprintf(fid, '    <parameter name="max_queue_vehicles" value="%d"/>\n', mq);
      fprintf(fid, '   </parameters>\n');
      fprintf(fid, '  </actuator>\n');
    else
      if isempty(ors.feeders)
        links = ors.peers;
        or_lanes = ors.peer_lanes;
        or_metered = ors.peer_metered;
        or_min_rate = ors.peer_min_rate;
        or_max_rate = ors.peer_max_rate;
        or_qlim = ors.peer_queue_limit;
      else      
        links = ors.feeders;
        or_lanes = ors.feeder_lanes;
        or_metered = ors.feeder_metered;
        or_min_rate = ors.feeder_min_rate;
        or_max_rate = ors.feeder_max_rate;
        or_qlim = ors.feeder_queue_limit;
      end
      in_count = size(links, 2);
      for j = 1:in_count
        ml = round(or_metered(j) / or_lanes(j));
        mq = 100000;
        fprintf(fid, '  <actuator id="%d">\n', links(j));
        fprintf(fid, '   <scenarioElement id="%d" type="link"/>\n', links(j));
        fprintf(fid, '   <actuator_type id="0" name="ramp_meter"/>\n');
        if or_qlim(j) ~= 0
          fprintf(fid, '   <queue_override strategy="max_rate"/>\n');
          mq = or_qlim(j);
        end
        fprintf(fid, '   <parameters>\n');
        fprintf(fid, '    <parameter name="min_rate_in_vphpl" value="%d"/>\n', or_min_rate(j)*ml);
        fprintf(fid, '    <parameter name="max_rate_in_vphpl" value="%d"/>\n', or_max_rate(j)*ml);
        fprintf(fid, '    <parameter name="max_queue_vehicles" value="%d"/>\n', mq);
        fprintf(fid, '   </parameters>\n');
        fprintf(fid, '  </actuator>\n');
      end
    end
  end
end


fprintf(fid, ' </ActuatorSet>\n\n');

return;
