function [LST] = LST(local_time, longitude, timezone, ordinal_day)
% LST: Local Solar Time
%   local_time: local time in hours
%   input: longitude in degrees
%   input: timezone (Local time to UTC difference)
%   input: ordial day (number of days since the start of the year)
%   output: TC-factor in miutes
%   https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-time
%   tested
    LST = local_time + TC(longitude, timezone, ordinal_day)/60;
end

