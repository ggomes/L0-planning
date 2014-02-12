
%hov_prct = 0.2;
%sov_prct = 1 - hov_prct;


% 680 NB
%data_file = 'I680NB_Data.xlsx';
%cfg_file = '680N_cfg.xml';
%src_cfg = '680N_src_cfg.xml';
%fr_demand_file = '680N_fr_demand.xml';
%range = [2 149];




% On-ramp demand
fprintf('Generating on-ramp demand config...\n');
or_id = xlsread(data_file, 'On-Ramp_Flows', sprintf('g%d:g%d', range(1), range(2)));
or_id = or_id';
ORD = xlsread(data_file, 'On-Ramp_Flows', sprintf('k%d:kl%d', range(1), range(2)));
[m, n] = size(ORD);
rp = fopen(src_cfg, 'r');
txt_cfg = fread(rp, inf);
fclose(rp);
fp = fopen(cfg_file, 'w+');
fwrite(fp, txt_cfg);
fprintf(fp, '<DemandSet id="1" name="onramps" project_id="1">\n');
for i = 1:m
  if max(ORD(i, :)) > 0
    fprintf(fp, '<demandProfile id="%d" link_id_org="%d" start_time="0" dt="300" std_dev_add="0" std_dev_mult="0">\n<demand vehicle_type_id="1">', i, or_id(i));
    for j = 1:n
      fprintf(fp, '%f', sov_prct*ORD(i, j));
      if j < n
        fprintf(fp, ', ');
      end
    end
    fprintf(fp, '</demand>\n<demand vehicle_type_id="0">');
    for j = 1:n
      fprintf(fp, '%f', hov_prct*ORD(i, j));
      if j < n
        fprintf(fp, ', ');
      end
    end
    fprintf(fp, '</demand>\n</demandProfile>\n');
  end
end
fprintf(fp, '</DemandSet>\n</scenario>\n');
fclose(fp);






% Off-ramp demand
fprintf('Generating off-ramp demand config...\n');
fr_id = xlsread(data_file, 'Off-Ramp_Flows', sprintf('g%d:g%d', range(1), range(2)));
fr_id = fr_id';
FRD = xlsread(data_file, 'Off-Ramp_Flows', sprintf('k%d:kl%d', range(1), range(2)));
[m, n] = size(FRD);
fp = fopen(fr_demand_file, 'w+');
fprintf(fp, '<DemandSet id="2" name="offramps" project_id="1">\n');
for i = 1:m
  if max(FRD(i, :)) > 0
    fprintf(fp, '<demandProfile id="%d" link_id_org="%d" start_time="0" dt="300" std_dev_add="0" std_dev_mult="0">\n<demand vehicle_type_id="1">', i, fr_id(i));
    for j = 1:n
      fprintf(fp, '%f', FRD(i, j));
      if j < n
        fprintf(fp, ', ');
      end
    end
    fprintf(fp, '</demand>\n</demandProfile>\n');
  end
end
fprintf(fp, '</DemandSet>\n');
fclose(fp);



