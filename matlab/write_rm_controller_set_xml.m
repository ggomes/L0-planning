function write_rm_controller_set_xml(fid, xlsx_file, range, gp_id, or_id)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% gp_id - array of GP link IDs
% or_id - array of on-ramp link IDs

disp('  G. Generating ramp metering controller set...');


sz = range(2) - range(1) + 1;

fprintf(fid, ' <ControllerSet id="1" project_id="1">\n');
for i = 1:sz
  ;
end


fprintf(fid, ' </ControllerSet>\n\n');

return;
