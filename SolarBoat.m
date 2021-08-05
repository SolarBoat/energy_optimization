%% init
addpath('models/solarAPI')

Psolar = 50 * 0.8; % W
Ebattery = 200; % Wh
Umax = 32; % W
b0 = Ebattery * 0.7; % Wh
w0 = 2;
cp = 2; % W

% motor
cmin = 2;
cm = 4 / ((20 - cmin) ^ (1/3));
L = @(u) - Motor(u, cmin, cm);
E = @(b) (b-b0)^2 * 0.005;

T = 24 * 7;
h = 1;
db = 0.5;
Nt = T / h;
Nx = Ebattery / db + 1;
Nu = (Umax - cmin) + 2;

tDiscrete = h:h:T;
xDiscrete = linspace(0, Ebattery, Nx);

[solar_data, solar] = solarForecast('data1.csv', Psolar);
%[solar_data, solar] = solarGenerator(Psolar, 190, [1, 0.1, 1, 1, 1, 1, 1]);
Nw = 35 / h;
W = eye(3); %WeatherMarkov(0.2, 0.6, 0.2, Nw);

[distance, u, b, J] = dynamicProgramming(tDiscrete, Umax, Ebattery, db, b0, w0, L, E, cp, solar, W, 10000);

distance

figure(1)
subplot(3, 1, 1)
fill([(0:(length(solar_data.PvEstimate)-1))*0.5,fliplr(0:(length(solar_data.PvEstimate)-1))*0.5], [solar_data.PvEstimate10',fliplr(solar_data.PvEstimate90')] * Psolar, 'b', 'EdgeAlpha', 0, 'FaceAlpha', 0.2)
hold on
plot((0:(length(solar_data.PvEstimate)-1))*0.5, solar_data.PvEstimate * Psolar, 'b')
hold off
xlim([0, tDiscrete(end)])
xlabel('t in h')
ylim([0, Psolar])
ylabel('W')
title("Solar Estimation s")

subplot(3, 1, 2)
plot([0, tDiscrete], b)
xlim([0, tDiscrete(end)])
xlabel('t in h')
ylim([0, Ebattery])
ylabel('Wh')
title("Battery Charge x")

subplot(3, 1, 3)
plot([0, tDiscrete], [0,u'])
xlim([0, tDiscrete(end)])
xlabel('t in h')
ylim([0, Umax])
ylabel('W')
title("Motor Power u")

figure(2)
contourf(squeeze(J(:, w0, :)), -500:10:300)
hold on
plot([0, tDiscrete/h], b/db, 'r', 'LineWidth', 2.0)
ylim([0, Ebattery/db])
xlim([1, tDiscrete(end)/h])
xlabel('t in h')
ylabel('Wh')
title("Cost Function J")
colorbar