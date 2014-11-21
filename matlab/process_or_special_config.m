function ORS_processed = process_or_special_config(ORS)
% ORS - special on-ramp configuration sheet
% 
% ORS_processed - processed special on-ramp config

ORS_processed = [];

entry_idx = find(~isnan(ORS(:, 1)));

sz = size(entry_idx, 1);

for i = 1:sz
  b = entry_idx(i);
  e = size(ORS, 1);
  if i < sz
    e = entry_idx(i+1)-1;
  end
  ORS_processed = [ORS_processed process_entry(ORS(b:e, :), b)];
end

return;





function s = process_entry(ORS, b)
% ORS - config table for the special freeway entry
% b - begin index in the full array

s.id = ORS(1, 1);
s.idx = b;
s.data = ORS(:, 14:end);
s.output = [];
s.merge_length = min(ORS(find(~isnan(ORS(:, 2))), 2));
s.merge_lanes = min(ORS(find(~isnan(ORS(:, 3))), 3));

if ~s.merge_length
  s.peers = ORS(find(~isnan(ORS(:, 4))), 4)';
  s.peer_hov_portion = ORS(find(~isnan(ORS(:, 5))), 5)';
  s.peer_lanes = ORS(find(~isnan(ORS(:, 6))), 6)';
  s.peer_metered = ORS(find(~isnan(ORS(:, 7))), 7)';
  s.peer_min_rate = ORS(find(~isnan(ORS(:, 8))), 8)';
  s.peer_max_rate = ORS(find(~isnan(ORS(:, 9))), 9)';
  s.peer_queue_limit = ORS(find(~isnan(ORS(:, 10))), 10)';
  s.feeders = [];
  s.feeder_hov_portion = [];
  s.feeder_lanes = [];
  s.feeder_metered = [];
  s.feeder_min_rate = [];
  s.feeder_max_rate = [];
  s.feeder_queue_limit = [];
else
  s.feeders = ORS(find(~isnan(ORS(:, 4))), 4)';
  s.feeder_hov_portion = ORS(find(~isnan(ORS(:, 5))), 5)';
  s.feeder_lanes = ORS(find(~isnan(ORS(:, 6))), 6)';
  s.feeder_metered = ORS(find(~isnan(ORS(:, 7))), 7)';
  s.feeder_min_rate = ORS(find(~isnan(ORS(:, 8))), 8)';
  s.feeder_max_rate = ORS(find(~isnan(ORS(:, 9))), 9)';
  s.feeder_queue_limit = ORS(find(~isnan(ORS(:, 10))), 10)';
  s.peers = [];
  s.peer_hov_portion = [];
  s.peer_lanes = [];
  s.peer_metered = [];
  s.peer_min_rate = [];
  s.peer_max_rate = [];
  s.peer_queue_limit = [];
end



return;
