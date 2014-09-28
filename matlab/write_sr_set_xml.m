function write_demand_set_xml(fid, xlsx_file, range, gp_id, hov_id, or_id, fr_id, ORS)
% fid - file descriptor for the output xml
% xlsx_file - full path to the configuration spreadsheet
% range - row range to be read from the spreadsheet
% gp_id - array of GP link IDs
% hov_id - array of HOV link IDs
% or_id - array of on-ramp link IDs
% fr_id - array of off-ramp link IDs
% ORS - configuration table for specially treated on-ramps

disp('  D. Generating split ratio set...');

% Link IDs
hov_prct = xlsread(xlsx_file, 'Configuration', sprintf('c%d:c%d', range(1), range(2)))';
SR = xlsread(xlsx_file, 'Off-Ramp_SplitRatios', sprintf('k%d:kl%d', range(1), range(2)));
FRGF = xlsread(xlsx_file, 'Off-Ramp_GrowthFactors', sprintf('k%d:kl%d', range(1), range(2)));
%SR = SR .* FRGF;
[m, n] = size(SR);
SR = min(SR, ones(m, n));


sz = range(2) - range(1) + 1;

fprintf(fid, ' <SplitRatioSet id="1" project_id="1">\n');

for i = 2:sz
  if (hov_id(i) ~= 0) | (fr_id(i) ~= 0)
    write_sr_profile_xml(fid, gp_id(i-1:i), hov_id(i-1:i), or_id(i), fr_id(i), SR(i, :));
  end
end

fprintf(fid, ' </SplitRatioSet>\n\n');

return;





function write_sr_profile_xml(fid, gp_id, hov_id, or_id, fr_id, srp)
% fid - file descriptor for the output xml
% gp_id - previous and current GP link IDs
% hov_id - previous and current HOV link IDs
% or_id - on-ramp ID
% fr_id - of-ramp ID
% srp - array of off-ramp split ratios

sz = size(srp, 2);
if sz < 288
  srp(288) = 0;
end

sov_sr_buf = '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1';


fprintf(fid, '   <splitRatioProfile id="%d" node_id="%d" dt="300" start_time="0">\n', gp_id(2), gp_id(2));

fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', gp_id(1), gp_id(2));
fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">-1</splitratio>\n', gp_id(1), gp_id(2));

if hov_id(2) ~= 0   % HOV output exists
  fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', gp_id(1), hov_id(2));
  fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', gp_id(1), hov_id(2), sov_sr_buf);
end

if fr_id ~= 0   % Off-ramp exists
  fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">%s</splitratio>\n', gp_id(1), fr_id, form_buffer(srp));
  fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', gp_id(1), fr_id, form_buffer(srp));
end


if hov_id(1) ~= 0   % HOV input exists
  fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', hov_id(1), gp_id(2));
  fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">-1</splitratio>\n', hov_id(1), gp_id(2));
  
  if hov_id(2) ~= 0   % HOV output exists
    fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', hov_id(1), hov_id(2));
    fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', hov_id(1), hov_id(2), sov_sr_buf);
  end

  if fr_id ~= 0   % Off-ramp exists
    fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">%s</splitratio>\n', hov_id(1), fr_id, form_buffer(srp));
    fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', hov_id(1), fr_id, form_buffer(srp));
  end
end


if or_id ~= 0   % On-ramp exists
  fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', or_id, gp_id(2));
  fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">-1</splitratio>\n', or_id, gp_id(2));
  
  if hov_id(2) ~= 0   % HOV output exists
    fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', or_id, hov_id(2));
    fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', or_id, hov_id(2), sov_sr_buf);
  end

  if fr_id ~= 0   % Off-ramp exists
    fprintf(fid, '    <splitratio vehicle_type_id="0" link_in="%d" link_out="%d">0</splitratio>\n', or_id, fr_id);
    fprintf(fid, '    <splitratio vehicle_type_id="1" link_in="%d" link_out="%d">0</splitratio>\n', or_id, fr_id);
  end
end


fprintf(fid, '   </splitRatioProfile>\n');

return;








function buf = form_buffer(sr)
% sr - split ratio array

sz = size(sr, 2);

buf = '';

for i = 1:sz
  if i > 1
    buf = sprintf('%s,', buf);
  end
  buf = sprintf('%s%f', buf, sr(i));
end

return;
