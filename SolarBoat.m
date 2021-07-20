%% init
addpath('models/solarAPI')

Psolar = 50 * 0.8; % W
Ebattery = 200; % Wh
Umax = 32; % W
x0 = Ebattery / 2; % Wh
cp = 2; % W

% motor
cmin = 2;
cm = 4 / ((20 - cmin) ^ (1/3));
L = @(u) - heaviside(u - cmin) * (cm * (u - cmin) ^ (1/3));
E = @(x) (x-x0)^2 * 0.005;


T = 24 * 7;
h = 0.5;
dx = 0.5;
Nt = T / h;
Nx = Ebattery / dx + 1;
Nu = (Umax - cmin) + 2;

tDiscrete = h:h:T;
xDiscrete = linspace(0, Ebattery, Nx);
uDiscrete = [0, linspace(cmin, Umax, Nu - 1)];

%% With forecast

[solar_data, solar] = solarForecast('data1.csv', Psolar);
[distance, u, x, J] = dynamicProgramming(tDiscrete, uDiscrete, Ebattery, dx, x0, L, E, cp, solar, [0.6, 0.2, 0.2], 100000);



%% Over 7 days

figure(1)
subplot(3, 1, 1)
fill([(0:(length(solar_data.PvEstimate)-1))*h,fliplr(0:(length(solar_data.PvEstimate)-1))*h], [solar_data.PvEstimate10',fliplr(solar_data.PvEstimate90')] * Psolar, 'b', 'EdgeAlpha', 0, 'FaceAlpha', 0.2)
hold on
plot((0:(length(solar_data.PvEstimate)-1))*h, solar_data.PvEstimate * Psolar, 'b')
hold off
xlim([0, tDiscrete(end)])
xlabel('t in h')
ylim([0, Psolar])
ylabel('W')
title("Solar Estimation")

subplot(3, 1, 2)
plot([0, tDiscrete], x)
xlim([0, tDiscrete(end)])
xlabel('t in h')
ylim([0, Ebattery])
ylabel('Wh')
title("Battery Charge")

subplot(3, 1, 3)
plot([0, tDiscrete], [0,u'])
xlim([0, tDiscrete(end)])
xlabel('t in h')
ylim([0, Umax])
ylabel('W')
title("Motor Power")

figure(2)
contourf(J, -500:10:300)
hold on
plot([0, tDiscrete/h], x/dx, 'r', 'LineWidth', 2.0)
ylim([0, Ebattery/dx])
xlim([1, tDiscrete(end)/h])
xlabel('t in h')
ylabel('Wh')
title("Battery Charge")
distance