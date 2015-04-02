function collect_sr(data_file, range, gp_out, gp_id, fr_id)

SR = [];
HSR = [];

sz = size(gp_id, 2);

for i = 1:sz
  if fr_id(i) ~= 0
    SR = [SR; extract_sr(gp_out, gp_id(i), fr_id(i), gp_id(i-1), 1)];
    HSR = [HSR; extract_sr(gp_out, gp_id(i), fr_id(i), gp_id(i-1), 0)];
  else
    SR = [SR; zeros(1, 288)];
    HSR = [HSR; zeros(1, 288)];
  end
end

% write data to spreadsheet
if 1
fprintf('Writing data to %s...\n', data_file);
xlswrite(data_file, SR, 'Off-Ramp_SplitRatios', sprintf('k%d:kl%d', range(1), range(2)));
xlswrite(data_file, HSR, 'HOV_Off-Ramp_SplitRatios', sprintf('k%d:kl%d', range(1), range(2)));
end
