dt = datetime('now');

ct = dt.Hour + dt.Minute/60;
ordinal_day = day(dt,'dayofyear');


time_zone = 1; % Germany UTC+1
local_time = linspace(0, 24, 500);
latitude = 47.997791; % Freiburg coordinates
longitude = 7.842609;


di = arrayfun(@(t) di_full_model(ordinal_day, time_zone, t, latitude, longitude), local_time);
ct_di = di_full_model(ordinal_day, time_zone, ct, latitude, longitude);

plot(local_time, di); hold on;
plot(ct, ct_di, 'r.', 'Markersize', 15);
legend('radiation curve', 'current radiation')
xlabel('time [hours]')
ylabel('direct radiation [kW/m^2]')
xlim([0, 24])
ylim([0, 1])