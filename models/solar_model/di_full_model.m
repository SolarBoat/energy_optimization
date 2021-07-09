function [di] = di_full_model(ordinal_day, time_zone, local_time, latitude, longitude)
    hour_angle = HRA(local_time, longitude, time_zone, ordinal_day);
    dec = declination(ordinal_day);
    am = AM(latitude, dec, hour_angle);
    di = DI(am);
end

