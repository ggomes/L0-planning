function write_rm_controller_set_xml(fid, xlsx_file, range, gp_id, or_id, metered, ORS)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% gp_id - array of GP link IDs
% or_id - array of on-ramp link IDs
% metered - array with the number of metered lanes
% ORS - configuration table for specially treated on-ramps

disp('  G. Generating ramp metering controller set...');

sz = range(2) - range(1) + 1;

fprintf(fid, ' <ControllerSet id="1" project_id="1">\n');
for i = 1:sz
  if (or_id(i) ~= 0) & (metered(i) ~= 0)
     ors = find_or_struct(ORS, or_id(i));
    if isempty(ors)
      fprintf(fid, '  <controller dt="300" enabled="true" id="%d" type="IRM_ALINEA">\n', or_id(i));
      fprintf(fid, '   <parameters><parameter name="gain" value="50"/></parameters>\n');
      fprintf(fid, '   <target_actuators><target_actuator id="%d"/></target_actuators>\n', or_id(i));
      fprintf(fid, '   <feedback_sensors><feedback_sensor id="%d" usage="mainline"/></feedback_sensors>\n', gp_id(i));
      fprintf(fid, '  </controller>\n');
    else
      if isempty(ors.feeders)
        links = ors.peers;
      else      
        links = ors.feeders;
      end
      in_count = size(links, 2);
      for j = 1:in_count
        fprintf(fid, '  <controller dt="300" enabled="true" id="%d" type="IRM_ALINEA">\n', links(j));
        fprintf(fid, '   <parameters><parameter name="gain" value="50"/></parameters>\n');
        fprintf(fid, '   <target_actuators><target_actuator id="%d"/></target_actuators>\n', links(j));
        fprintf(fid, '   <feedback_sensors><feedback_sensor id="%d" usage="mainline"/></feedback_sensors>\n', gp_id(i));
        fprintf(fid, '  </controller>\n');
      end
    end
  end
end


fprintf(fid, ' </ControllerSet>\n\n');

return;
