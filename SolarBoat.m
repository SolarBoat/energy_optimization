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
[distance, u, x] = dynamicProgramming(tDiscrete, uDiscrete, Ebattery, dx, x0, L, E, cp, solar, [0.6, 0.2, 0.2], 100000);


%% Over 7 days

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

distance

%% Battery Experiment

Ebatteries = 5:5:600;
distances = zeros(length(Ebatteries), 1);

[solar_data, solar] = solarForecast('data.csv', Psolar);
for b = 1:length(Ebatteries)
    
    Psolar = 50 * 0.8; % W
    Umax = 32; % W
    x0 = Ebatteries(b) / 2; % Wh
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
    Nx = Ebatteries(b) / dx + 1;
    Nu = (Umax - cmin) + 2;

    tDiscrete = h:h:T;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
    uDiscrete = [0, linspace(cmin, Umax, Nu - 1)];
    
    [distance, u, x] = dynamicProgramming(tDiscrete, uDiscrete, Ebatteries(b), dx, x0, L, E, cp, solar, [0.6, 0.2, 0.2], inf);
    distance
    distances(b) = distance;
end

plot(Ebatteries, distances)


%%
solar = solarGenerator(Psolar, 240, [1, 1, 1, 1, 1, 1, 1] * 0.8);