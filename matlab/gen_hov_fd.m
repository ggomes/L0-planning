clear all;

init_config;

hov_fd = csvread(hov_csv);

sz = size(hov_fd, 1);
fid = fopen('hov_fd.xml', 'w+');


for i = 1:sz
  if hov_fd(i, 1) ~= 0
    fprintf(fid, '      <fundamentalDiagramProfile id="%d" link_id="%d" start_time="0" dt="3600">\n', 1000+i, hov_fd(i, 1));
    for j = 1:5
      fprintf(fid, '        <fundamentalDiagram capacity="1900" congestion_speed="%d" free_flow_speed="%d" id="%d"/>\n', hov_fd(i, 3), hov_fd(i, 2), 1000+i*24+j);
    end
    for j = 1:4
      fprintf(fid, '        <fundamentalDiagram capacity="1800" congestion_speed="%d" free_flow_speed="%d" id="%d"/>\n', hov_fd(i, 3), hov_fd(i, 2), 1005+i*24+j);
    end
    for j = 1:6
      fprintf(fid, '        <fundamentalDiagram capacity="1900" congestion_speed="%d" free_flow_speed="%d" id="%d"/>\n', hov_fd(i, 3), hov_fd(i, 2), 1009+i*24+j);
    end
    for j = 1:4
      fprintf(fid, '        <fundamentalDiagram capacity="1800" congestion_speed="%d" free_flow_speed="%d" id="%d"/>\n', hov_fd(i, 3), hov_fd(i, 2), 1015+i*24+j);
    end
    for j = 1:5
      fprintf(fid, '        <fundamentalDiagram capacity="1900" congestion_speed="%d" free_flow_speed="%d" id="%d"/>\n', hov_fd(i, 3), hov_fd(i, 2), 1019+i*24+j);
    end

    fprintf(fid, '      </fundamentalDiagramProfile>\n');
  end
end

fclose(fid);

