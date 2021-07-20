
addpath('models/solarAPI')

Psolar = 50 * 0.8; % W
Umax = 32; % W
cp = 2; % W

% motor
cmin = 2;
cm = 4 / ((20 - cmin) ^ (1/3));
L = @(u) - heaviside(u - cmin) * (cm * (u - cmin) ^ (1/3));

T = 24 * 7;
h = 0.5;
dx = 0.5;
Nt = T / h;
Nu = (Umax - cmin) + 2;

tDiscrete = h:h:T;
uDiscrete = [0, linspace(cmin, Umax, Nu - 1)];

b_min = 20; %W
b_max = 300; %W
Ebatteries = unique(round(logspace(log10(b_min), log10(b_max), 30)));
distances = zeros(length(Ebatteries), 1);
x0 = Ebatteries(1); % Wh [Full of smallest Battery]
E = @(x) (x-x0)^2 * 0.005;

[solar_data, solar] = solarForecast('data1.csv', Psolar);

figure(1)
hold on
for b = 1:length(Ebatteries)
    
    Nx = Ebatteries(b) / dx + 1;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
  
    [distance, u, x] = dynamicProgramming(tDiscrete, uDiscrete, Ebatteries(b), dx, x0, L, E, cp, solar, [1], inf);
    distances(b) = distance;
    disp(['iteration: ', num2str(b), ' battery: ', num2str(Ebatteries(b)), 'W  distance: ', num2str(distance), 'km'])
       
    plot([0, tDiscrete], x)
    drawnow
end

figure(2)
plot(Ebatteries, distances)
ylabel('distance in km')
xlabel('Battery capacity in W')