
tt=linspace(0,24-1/12,288);

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
plot([pm(26) pm(26) pm(33) pm(33) pm(26)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');
plot([pm(43) pm(43) pm(58) pm(58) pm(43)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');

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
plot([pm(26) pm(26) pm(33) pm(33) pm(26)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');
plot([pm(43) pm(43) pm(58) pm(58) pm(43)], [tt(192) tt(228) tt(228) tt(192) tt(192)], 'w');
plot([pm(71) pm(71) pm(97) pm(97) pm(71)], [tt(180) tt(216) tt(216) tt(180) tt(180)], 'w');

