addpath('models/solarAPI')

Psolar = 50; % W
Ebattery = 200; % Wh
Umax = 40; % W
x0 = Ebattery / 2; % Wh
cp = 2; % W

% motor
cmin = 4;
cm = 1 / sqrt(10);
L = @(u) - heaviside(u - cmin) * (cm * sqrt(u - cmin));
E = @(x) (x-x0)^2 * 0.001;


T = 24 * 6;
h = 0.5;
Nt = T / h;
Nx = 201;
Nu = 21;





solar = solarForecast('data.csv', Psolar);



tDiscrete = h:h:T;
xDiscrete = linspace(0, Ebattery, Nx);
uDiscrete = linspace(0, Umax, Nu);

[distance, u, x] = dynamicProgramming(tDiscrete, xDiscrete, uDiscrete, x0, L, E, cp, solar, [1]);

distance

hold on
plot(x)


plot(u)
hold off