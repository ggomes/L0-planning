function or_struct = find_or_struct(ORS, id)
% ORS - arrayf of on-ramp structures
% id - on-ramp ID

sz = size(ORS, 2);

or_struct = [];
  idx = -1;

for i = 1:sz
  if ORS(i).id == id
    or_struct = ORS(i);
    break;
  end
end

return;
