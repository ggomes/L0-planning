function write_event_set_xml(fid)
% fid - file descriptor for the output xml

disp('  H. Generating event set...');


fprintf(fid, ' <EventSet id="1" project_id="1">\n');

fprintf(fid, '  <event enabled="true" id="0" tstamp="0" type="global_control_toggle">\n');
fprintf(fid, '   <parameters><parameter name="on_off_switch" value="off"/></parameters>\n');
fprintf(fid, '  </event>\n');

fprintf(fid, '  <event enabled="true" id="1" tstamp="21600" type="global_control_toggle">\n');
fprintf(fid, '   <parameters><parameter name="on_off_switch" value="on"/></parameters>\n');
fprintf(fid, '  </event>\n');

fprintf(fid, '  <event enabled="true" id="2" tstamp="32400" type="global_control_toggle">\n');
fprintf(fid, '   <parameters><parameter name="on_off_switch" value="off"/></parameters>\n');
fprintf(fid, '  </event>\n');

fprintf(fid, '  <event enabled="true" id="3" tstamp="54000" type="global_control_toggle">\n');
fprintf(fid, '   <parameters><parameter name="on_off_switch" value="on"/></parameters>\n');
fprintf(fid, '  </event>\n');

fprintf(fid, '  <event enabled="true" id="4" tstamp="68400" type="global_control_toggle">\n');
fprintf(fid, '   <parameters><parameter name="on_off_switch" value="off"/></parameters>\n');
fprintf(fid, '  </event>\n');


fprintf(fid, ' </EventSet>\n\n');

return;
