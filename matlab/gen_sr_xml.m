function gen_sr_xml(gp_id, hov_id, or_id, fr_id, node_id, SR, init_file, output_file)
% gp_id - vector of GP link IDs
% hov_id - vector of HOV link IDs
% or_id - vector of on-ramp IDs
% fr_id - vector of off-ramp IDs
% node_id - vector of node IDs, begin nodes for off-ramp links
% SR - split ratios
% init_file - initial part of the split ratio file
% output_file - file for writing the output

sov_sr_buf = '-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1';


sz = size(fr_id, 2);

ifid = fopen(init_file, 'r');

fid = fopen(output_file, 'w+');

str = fgetl(ifid);
while str ~= -1
  fprintf(fid, '%s\n', str);
  str = fgetl(ifid);
end

fclose(ifid);



for i = 1:sz
  if node_id(i) ~= 0 
    fprintf(fid, '<splitRatioProfile id="%d" node_id="%d" start_time="0" dt="300">\n', 100+i, node_id(i));

    fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', gp_id(i-1), gp_id(i));
    fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">-1</splitratio>\n', gp_id(i-1), gp_id(i));
    fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">%s</splitratio>\n', gp_id(i-1), fr_id(i), form_buffer(SR(i, :)));
    fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', gp_id(i-1), fr_id(i), form_buffer(SR(i, :)));

    if hov_id(i) ~= 0
      fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', gp_id(i-1), hov_id(i));
      fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', gp_id(i-1), hov_id(i), sov_sr_buf);
    end
    
    if hov_id(i-1) ~= 0
      fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', hov_id(i-1), gp_id(i));
      fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">-1</splitratio>\n', hov_id(i-1), gp_id(i));
      fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">%s</splitratio>\n', hov_id(i-1), fr_id(i), form_buffer(SR(i, :)));
      fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', hov_id(i-1), fr_id(i), form_buffer(SR(i, :)));
      if hov_id(i) ~= 0
        fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', hov_id(i-1), hov_id(i));
        fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', hov_id(i-1), hov_id(i), sov_sr_buf);
      end
    end
    
    if or_id(i) ~= 0
      fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', or_id(i), gp_id(i));
      fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">-1</splitratio>\n', or_id(i), gp_id(i));
      fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">0</splitratio>\n', or_id(i), fr_id(i));
      fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">0</splitratio>\n', or_id(i), fr_id(i));
      if hov_id(i) ~= 0
        fprintf(fid, '\t<splitratio vehicle_type_id="0" link_in="%d" link_out="%d">-1</splitratio>\n', or_id(i), hov_id(i));
        fprintf(fid, '\t<splitratio vehicle_type_id="1" link_in="%d" link_out="%d">%s</splitratio>\n', or_id(i), hov_id(i), sov_sr_buf);
      end
    end

    fprintf(fid, '</splitRatioProfile>\n');
    
  end
end

fprintf(fid, '</SplitRatioSet>\n');
fclose(fid);

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
