function write_sensor_set_xml(fid, xlsx_file, range, gp_id)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% gp_id - array of GP link IDs

disp('  E. Generating sensor set...');



sz = range(2) - range(1) + 1;

fprintf(fid, ' <SensorSet id="1" project_id="1">\n');
for i = 1:sz
	;
end


fprintf(fid, ' </SensorSet>\n\n');

return;
