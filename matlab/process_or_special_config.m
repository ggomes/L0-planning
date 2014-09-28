function ORS_processed = process_or_special_config(ORS)
% ORS - special on-ramp configuration sheet
% 
% ORS_processed - processed special on-ramp config

ORS_processed = [];

entry_idx = find(~isnan(ORS(:, 1)));

sz = size(entry_idx, 2);

for i = 1:sz
  b = entry_idx(i);
  e = size(ORS, 1);
  if i < sz
    e = entry_idx(i+1);
  end
  ORS_processed = [ORS_processed process_entry(ORS(b:e, :))
end


return;





function s = process_entry(ORS)
