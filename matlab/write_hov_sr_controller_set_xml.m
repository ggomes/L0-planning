function write_hov_sr_controller_set_xml(fid, fr_demand_file, hov_demand_file, a_id, num_frs)
% fid - file descriptor for the output xml
% fr_demand_file - full path to the off-ramp demand XML
% hov_demand_file - full path to the downstream HOV demand XML
% a_id - array of actuator IDs

disp('  G. Generating split ratio controller set...');


fprintf(fid, ' <ControllerSet id="1" project_id="1">\n');
fprintf(fid, '  <controller dt="5" enabled="true" id="23" name="SR_Generator" type="SR_Generator">\n');
fprintf(fid, '   <parameters><parameter name="fr_flow_file" value="%s"/></parameters>\n', fr_demand_file);
fprintf(fid, '   <target_actuators>\n');

sz = size(a_id, 2);
for i = 1:num_frs
  fprintf(fid, '    <target_actuator id="%d"/>\n', a_id(i));
end

fprintf(fid, '   </target_actuators>\n');
fprintf(fid, '  </controller>\n');

fprintf(fid, '  <controller dt="5" enabled="true" id="24" name="HOV_SR_Generator" type="HOV_SR_Generator">\n');
fprintf(fid, '   <parameters><parameter name="hov_flow_file" value="%s"/></parameters>\n', hov_demand_file);
fprintf(fid, '   <target_actuators>\n');

for j = i+1:sz
    fprintf(fid, '    <target_actuator id="%d"/>\n', a_id(j));
end

fprintf(fid, '   </target_actuators>\n');
fprintf(fid, '  </controller>\n </ControllerSet>\n');


return;
