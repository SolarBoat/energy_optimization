
addpath('models/solarAPI')

Psolar = 50 * 0.8; % W
Umax = 32; % W
cp = 2; % W

% motor
cmin = 2;
cm = 4 / ((20 - cmin) ^ (1/3));
L = @(u) - Motor(u, cmin, cm);

T = 24 * 7;
h = 0.5;
dx = 0.5;
Nt = T / h;
Nu = (Umax - cmin) + 2;

tDiscrete = h:h:T;
uDiscrete = [0, linspace(cmin, Umax, Nu - 1)];

b_min = 10; %W
b_max = 250; %W
Ebatteries = unique(round(logspace(log10(b_min), log10(b_max), 25)));
distances = zeros(length(Ebatteries), 1);

%[solar_data, solar] = solarForecast('data1.csv', Psolar);

figure(1)
plot(0, 0, 'xg')
hold on
plot(0, 0, 'xb')
plot(0, 0, 'xr')
xlabel('Battery capacity in Wh')
ylabel('distance in km')
title('Optimal Battery Size')

solar =  solarGenerator(Psolar, 190, [1, 1, 1, 1, 1, 1, 1]);
for b = 1:length(Ebatteries)
    
    x0 = Ebatteries(b) / 2; % Wh [Full of smallest Battery]
    E = @(x) (x-x0)^2 * 0.005;
    Nx = Ebatteries(b) / dx + 1;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
  
    [distance, u, x] = dynamicProgramming(tDiscrete, uDiscrete, Ebatteries(b), dx, x0, L, E, cp, solar, [0.6, 0.2, 0.2], 100000);
    distances(b) = distance;
    disp(['iteration: ', num2str(b), ' battery: ', num2str(Ebatteries(b)), 'W  distance: ', num2str(distance), 'km'])
       
    plot(Ebatteries(b), distance, 'xg')
    drawnow
end

solar =  solarGenerator(Psolar, 190, [1, 1, 0.4, 0.4, 0.4, 0.4, 1]);
for b = 1:length(Ebatteries)
    
    x0 = Ebatteries(b) / 2; % Wh [Full of smallest Battery]
    E = @(x) (x-x0)^2 * 0.005;
    Nx = Ebatteries(b) / dx + 1;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
  
    [distance, u, x] = dynamicProgramming(tDiscrete, uDiscrete, Ebatteries(b), dx, x0, L, E, cp, solar, [0.6, 0.2, 0.2], 100000);
    distances(b) = distance;
    disp(['iteration: ', num2str(b), ' battery: ', num2str(Ebatteries(b)), 'W  distance: ', num2str(distance), 'km'])
       
    plot(Ebatteries(b), distance, 'xb')
    drawnow
end

solar =  solarGenerator(Psolar, 190, [1, 1, 1, 1, 1, 1, 1]* 0.4);
for b = 1:length(Ebatteries)
    
    x0 = Ebatteries(b) / 2; % Wh [Full of smallest Battery]
    E = @(x) (x-x0)^2 * 0.005;
    Nx = Ebatteries(b) / dx + 1;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
  
    [distance, u, x] = dynamicProgramming(tDiscrete, uDiscrete, Ebatteries(b), dx, x0, L, E, cp, solar, [0.6, 0.2, 0.2], 100000);
    distances(b) = distance;
    disp(['iteration: ', num2str(b), ' battery: ', num2str(Ebatteries(b)), 'W  distance: ', num2str(distance), 'km'])
       
    plot(Ebatteries(b), distance, 'xr')
    drawnow
end
hold off

legend('7 sunny days', '4 cloudy days', '7 cloudy days')

