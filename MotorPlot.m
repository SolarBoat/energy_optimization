cmin = 2;
cm = 4 / ((20 - cmin) ^ (1/3));
L = @(u) Motor(u, cmin, cm);
power = linspace(0, 32, 1000);
speed = arrayfun(L, power);
plot(speed, power)
xlim([0, 4.5])
xlabel('speed in km/h')
ylim([0, 30])
ylabel('power in W')
title('Motor power consumption')