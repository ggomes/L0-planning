
tt=linspace(0,24-1/12,288);

% Extracting link IDs
link_id = xlsread(xlsx_file, 'GP_Speed', sprintf('a%d:e%d', range(1), range(2)));
gp_id = link_id(:, 1)'; % GP link IDs
pm = -link_id(:, 2)'; % postmiles
llen = link_id(:, 3)'; % link lengths in miles
ffspeeds = link_id(:, 5)'; % free flow speeds

figure(1);
hold on;
pcolor(pm, tt, HOV_F');
shading flat;
colorbar;
axis([pm(1), pm(end), 0, 24]);
xlabel('Abs. postmile');
ylabel('Time');
title('HOV Flow');

figure(2);
hold on;
pcolor(pm, tt, -HOV_V');
shading flat;
colorbar;
axis([pm(1), pm(end), 0, 24]);
xlabel('Abs. postmile');
ylabel('Time');
title('HOV Speed');
grid on;

%plot([pm(26) pm(26) pm(33) pm(33) pm(26)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');
%plot([pm(43) pm(43) pm(58) pm(58) pm(43)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');

plot([pm(29) pm(29) pm(50) pm(50) pm(29)], [tt(72) tt(108) tt(108) tt(72) tt(72)], 'w');
plot([pm(69) pm(69) pm(78) pm(78) pm(69)], [tt(79) tt(110) tt(110) tt(79) tt(79)], 'w');
plot([pm(69) pm(69) pm(78) pm(78) pm(69)], [tt(186) tt(220) tt(220) tt(186) tt(186)], 'w');
plot([pm(78) pm(78) pm(83) pm(83) pm(78)], [tt(83) tt(105) tt(105) tt(83) tt(83)], 'w');



figure(3);
hold on;
pcolor(pm, tt, GP_F');
shading flat;
colorbar;
axis([pm(1), pm(end), 0, 24]);
xlabel('Abs. postmile');
ylabel('Time');
title('GP Flow');

figure(4);
hold on;
pcolor(pm, tt, -GP_V');
shading flat;
colorbar;
axis([pm(1), pm(end), 0, 24]);
xlabel('Abs. postmile');
ylabel('Time');
title('GP Speed');
grid on;
%plot([pm(26) pm(26) pm(33) pm(33) pm(26)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');
%plot([pm(43) pm(43) pm(58) pm(58) pm(43)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');
%plot([pm(71) pm(71) pm(97) pm(97) pm(71)], [tt(180) tt(216) tt(216) tt(180) tt(180)], 'w');

plot([pm(29) pm(29) pm(50) pm(50) pm(29)], [tt(72) tt(108) tt(108) tt(72) tt(72)], 'w');
plot([pm(69) pm(69) pm(78) pm(78) pm(69)], [tt(79) tt(110) tt(110) tt(79) tt(79)], 'w');
plot([pm(69) pm(69) pm(78) pm(78) pm(69)], [tt(186) tt(220) tt(220) tt(186) tt(186)], 'w');
plot([pm(78) pm(78) pm(83) pm(83) pm(78)], [tt(83) tt(105) tt(105) tt(83) tt(83)], 'w');

