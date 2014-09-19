function write_actuator_set_xml(fid, xlsx_file, range, or_id)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% or_id - array of on-ramp link IDs

disp('  F. Generating actuator set...');


% On-ramp parameters
lanes = xlsread(xlsx_file, 'Configuration', sprintf('p%d:p%d', range(1), range(2)))';
metered = xlsread(xlsx_file, 'Configuration', sprintf('q%d:q%d', range(1), range(2)))';
qlimits = xlsread(xlsx_file, 'Configuration', sprintf('r%d:r%d', range(1), range(2)))';

sz = range(2) - range(1) + 1;

fprintf(fid, ' <ActuatorSet id="1" project_id="1">\n');
for i = 1:sz
	;
end


fprintf(fid, ' </ActuatorSet>\n\n');

return;
