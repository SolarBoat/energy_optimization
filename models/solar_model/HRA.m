function [HRA] = HRA(local_time, longitude, timezone, ordinal_day)
% HRA: Hour Angle
%   input: local time in hours
%   input: longitude in degrees
%   input: timezone (Local time to UTC difference)
%   input: ordial day (number of days since the start of the year)
%   output: TC-factor in miutes
%   https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-time
    HRA = wrapTo360(15*(LST(local_time, longitude, timezone, ordinal_day) - 12));
end

