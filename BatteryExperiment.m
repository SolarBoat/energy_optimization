
addpath('models/solarAPI')

Psolar = 50 * 0.8; % W
Umax = 32; % W
cp = 2; % W

% motor
cmin = 2;
cm = 4 / ((20 - cmin) ^ (1/3));
L = @(u) - Motor(u, cmin, cm);

T = 24 * 7;
h = 2;
dx = 1;
Nt = T / h;
Nu = (Umax - cmin) + 2;

tDiscrete = h:h:T;

b_min = 10; %W
b_max = 350; %W
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

[solar_data, solar] =  solarGenerator(Psolar, 190, [1, 1, 1, 1, 1, 1, 1]);
Nw = 35 / h;
W = WeatherMarkov(0.2, 0.6, 0.2, Nw);
for b = 1:length(Ebatteries)
    
    x0 = Ebatteries(b) * 0.7; % Wh [Full of smallest Battery]
    E = @(x) (x-x0)^2 * 0.005;
    Nx = Ebatteries(b) / dx + 1;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
  
    [distance, u, x, J, Edistance] = dynamicProgramming(tDiscrete, Umax, Ebatteries(b), dx, x0, 2, L, E, cp, solar, W, 100000);
    distances(b) = Edistance;
    disp(['iteration: ', num2str(b), ' battery: ', num2str(Ebatteries(b)), 'W  distance: ', num2str(distance), 'km'])
       
    plot(Ebatteries(b), Edistance, 'xg')
    drawnow
end

[solar_data, solar] =  solarGenerator(Psolar, 190, [1, 1, 0.4, 0.4, 0.4, 0.4, 1]);
for b = 1:length(Ebatteries)
    
    x0 = Ebatteries(b) *0.7; % Wh [Full of smallest Battery]
    E = @(x) (x-x0)^2 * 0.005;
    Nx = Ebatteries(b) / dx + 1;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
  
    [distance, u, x, J, Edistance] = dynamicProgramming(tDiscrete, Umax, Ebatteries(b), dx, x0, 2, L, E, cp, solar, W, 100000);
    distances(b) = Edistance;
    disp(['iteration: ', num2str(b), ' battery: ', num2str(Ebatteries(b)), 'W  distance: ', num2str(distance), 'km'])
       
    plot(Ebatteries(b), Edistance, 'xb')
    drawnow
end

[solar_data, solar] =  solarGenerator(Psolar, 190, [1, 1, 1, 1, 1, 1, 1]* 0.4);
for b = 1:length(Ebatteries)
    
    x0 = Ebatteries(b) * 0.7; % Wh [Full of smallest Battery]
    E = @(x) (x-x0)^2 * 0.005;
    Nx = Ebatteries(b) / dx + 1;
    xDiscrete = linspace(0, Ebatteries(b), Nx);
  
    [distance, u, x, J, Edistance] = dynamicProgramming(tDiscrete, Umax, Ebatteries(b), dx, x0, 2, L, E, cp, solar, W, 100000);
    distances(b) = Edistance;
    disp(['iteration: ', num2str(b), ' battery: ', num2str(Ebatteries(b)), 'W  distance: ', num2str(distance), 'km'])
       
    plot(Ebatteries(b), Edistance, 'xr')
    drawnow
end
hold off

legend('7 sunny days', '4 cloudy days', '7 cloudy days')

