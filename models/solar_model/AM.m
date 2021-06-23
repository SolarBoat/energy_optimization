function [AM] = AM(latitude, declination, hour_angle)
% AM: Airmass
    %   input: latitude in degrees
    %   input: declination in degrees
    %   input: hour anglr in degrees
    %   output: airmass 
    % https://en.wikipedia.org/wiki/Direct_insolation
    % https://en.wikipedia.org/wiki/Solar_zenith_angle
    % https://en.wikipedia.org/wiki/Air_mass_(solar_energy)
    z = zenith(latitude, declination, hour_angle);
    if z >= 0 && z <= 90
        AM = 1/(cosd(z) + 0.50572*(96.07995-z)^(-1.6364));
    else
        AM = 0;
    end
end

