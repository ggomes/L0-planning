function [] = extract_simulation_data(ptr,data_file,range)

% Extracting link IDs
link_id = xlsread(data_file, 'GP_Speeds', sprintf('a%d:f%d', range(1), range(2)));
gp_id = link_id(:, 1)'; % GP link IDs
hov_id = link_id(:, 2)'; % HOV link IDs
pm = link_id(:, 3)'; % postmiles
llen = link_id(:, 4)'; % link lengths in miles
ffspeeds = link_id(:, 6)'; % free flow speeds
gp_cap = xlsread(data_file, 'GP_Flows', sprintf('f%d:f%d', range(1), range(2)));
hov_cap = xlsread(data_file, 'HOV_Flows', sprintf('f%d:f%d', range(1), range(2)));
gp_cap = gp_cap';
hov_cap = hov_cap';


link_id = ptr.scenario_ptr.link_id_begin_end(:, 1)';

% initialization
m = size(gp_id, 2);
GP_V = zeros(m, 288);
GP_F = zeros(m, 288);
HOV_V = zeros(m, 288);
HOV_F = zeros(m, 288);


% data extraction
fprintf('Extracting simulation data - speeds and flows...\n');
for i = 1:m
  idx = find(link_id == gp_id(i));
  den = ptr.density_veh{1}(2:289, idx) + ptr.density_veh{2}(2:289, idx);
  den = den' ./ (llen(i)*ones(1, 288));
  outflow = ptr.outflow_veh{1}(:, idx) + ptr.outflow_veh{2}(:, idx);
  outflow = 12*outflow';
  V = outflow ./ den;
  V = max([V; zeros(1, 288)]);
  V = min([V; ffspeeds(i)*ones(1, 288)]);
  GP_V(i, :) = V;
  inflow = ptr.inflow_veh{1}(:, idx) + ptr.inflow_veh{2}(:, idx);
  inflow = 12*inflow';
  inflow = min([inflow; gp_cap(i)*ones(1, 288)]);
  GP_F(i, :) = inflow;

  if hov_id(i) ~= 0
    idx = find(link_id == hov_id(i));
    den = ptr.density_veh{1}(2:289, idx) + ptr.density_veh{2}(2:289, idx);
    den = den' ./ (llen(i)*ones(1, 288));
    outflow = ptr.outflow_veh{1}(:, idx) + ptr.outflow_veh{2}(:, idx);
    outflow = 12*outflow';
    V = outflow ./ den;
    V = max([V; zeros(1, 288)]);
    V = min([V; ffspeeds(i)*ones(1, 288)]);
    HOV_V(i, :) = V;
    inflow = ptr.inflow_veh{1}(:, idx) + ptr.inflow_veh{2}(:, idx);
    inflow = 12*inflow';
    inflow = min([inflow; hov_cap(i)*ones(1, 288)]);
    HOV_F(i, :) = inflow;
  end

end

GP_V = round(GP_V);
GP_F = round(GP_F);
HOV_V = round(HOV_V);
HOV_F = round(HOV_F);


GP_V(1, :) = zeros(1, 288);
GP_F(1, :) = zeros(1, 288);



% write data to spreadsheet
xlswrite(data_file, HOV_V, 'HOV_Speeds', sprintf('j%d:kk%d', range(1), range(2)))
xlswrite(data_file, GP_V, 'GP_Speeds', sprintf('j%d:kk%d', range(1), range(2)))
xlswrite(data_file, HOV_F, 'HOV_Flows', sprintf('j%d:kk%d', range(1), range(2)))
xlswrite(data_file, GP_F, 'GP_Flows', sprintf('j%d:kk%d', range(1), range(2)))
