function metered = write_actuator_set_xml(fid, xlsx_file, range, or_id, ORS)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% or_id - array of on-ramp link IDs
% ORS - configuration table for specially treated on-ramps
%
% metered - array with the number of metered lanes

disp('  F. Generating actuator set...');


min_rate = 240;
max_rate = 900;


% On-ramp parameters
lanes = xlsread(xlsx_file, 'Configuration', sprintf('p%d:p%d', range(1), range(2)))';
metered = xlsread(xlsx_file, 'Configuration', sprintf('q%d:q%d', range(1), range(2)))';
qlimits = xlsread(xlsx_file, 'Configuration', sprintf('r%d:r%d', range(1), range(2)))';

sz = range(2) - range(1) + 1;

fprintf(fid, ' <ActuatorSet id="1" project_id="1">\n');
for i = 1:sz
  if (or_id(i) ~= 0) & (metered(i) ~= 0)
    ml = round(metered(i) / lanes(i));
    mq = 100000;
    fprintf(fid, '  <actuator id="%d">\n', or_id(i));
    fprintf(fid, '   <scenarioElement id="%d" type="link"/>\n', or_id(i));
    fprintf(fid, '   <actuator_type id="0" name="ramp_meter"/>\n');
    if qlimits(i) ~= 0
      fprintf(fid, '   <queue_override strategy="max_rate"/>\n');
      mq = qlimits(i);
    end
    fprintf(fid, '   <parameters>\n');
    fprintf(fid, '    <parameter name="min_rate_in_vphpl" value="%d"/>\n', min_rate*ml);
    fprintf(fid, '    <parameter name="max_rate_in_vphpl" value="%d"/>\n', max_rate*ml);
    fprintf(fid, '    <parameter name="max_queue_vehicles" value="%d"/>\n', mq);
    fprintf(fid, '   </parameters>\n');
    fprintf(fid, '  </actuator>\n');
  end
end


fprintf(fid, ' </ActuatorSet>\n\n');

return;
