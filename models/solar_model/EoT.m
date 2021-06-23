function [EoT] = EoT(ordinal_day)
% EoT: Equation of time
%   input: ordial day (number of days since the start of the year
%   output: EoT correction in minutes
%   https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-time
    d = ordinal_day;
    B = wrapTo360(360/365*(d-81));
    EoT = 9.87*sind(2*B)-7.53*cosd(B)-1.5*sind(B);
end

