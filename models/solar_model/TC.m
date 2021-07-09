function [TC] = TC(longitude, timezone, ordinal_day)
% TC: Time Correction Factor
%   input: longitude in degrees
%   input: timezone (Local time to UTC difference)
%   input: ordial day (number of days since the start of the year)
%   output: TC-factor in miutes
%   https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-time
    TC = 4*(wrapTo360(longitude-LSTM(timezone)))+EoT(ordinal_day);
end