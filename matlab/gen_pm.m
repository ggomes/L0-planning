clear
close all

init_config;

pm = xlsread(xlsx_file, 'Configuration', sprintf('d%d:d%d', range(1), range(2)))';
llen = xlsread(xlsx_file, 'Configuration', sprintf('e%d:e%d', range(1), range(2)))';


sz = range(2) - range(1) + 1;

for i = 2:sz
  pm(i) = pm(i-1) + pm_dir*llen(i-1); 
end

pm = pm';

xlswrite(xlsx_file, pm, 'Configuration', sprintf('d%d:d%d', range(1), range(2)));

return;
