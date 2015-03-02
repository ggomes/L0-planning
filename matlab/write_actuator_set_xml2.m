function a_id = write_actuator_set_xml2(fid, xlsx_file, gp_id, fr_id)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% fr_id - array of off-ramp link IDs
% fr_id - array of off-ramp link IDs
%
% a_id - array of actuators

disp('  F. Generating actuator set...');



sz = size(gp_id, 2);

fprintf(fid, ' <ActuatorSet id="1" project_id="1">\n');

a_id = [];

for i = 1:sz
  if fr_id(i) ~= 0
    fprintf(fid, '  <actuator id="%d">\n', fr_id(i));
    fprintf(fid, '   <scenarioElement id="%d" type="node"/>\n', gp_id(i));
    fprintf(fid, '   <actuator_type id="0" name="cms"/>\n');
    fprintf(fid, '  </actuator>\n');
    a_id = [a_id fr_id(i)];
  end
end

fprintf(fid, ' </ActuatorSet>\n\n');

return;
