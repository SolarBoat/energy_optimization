function [Z] = zenith(latitude, declination, hour_angle)
% ZENITH: Sorlar zenith angle
%   input: latitude in degrees
%   input: declination in degrees
%   input: hour angle in degrees
%   output: TC-factor in miutes
%   https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-time
%   https://en.wikipedia.org/wiki/Solar_zenith_angle
    Z = wrapTo360(acosd(sind(latitude)*sind(declination)+cosd(latitude)*cosd(declination)*cosd(hour_angle)));
end

