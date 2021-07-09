function [delta] = declination(ordinal_day)
% declination: declination angle
%   input: ordial day (number of days since the start of the year)
%   output: declination angle in degrees
%   https://en.wikipedia.org/wiki/Position_of_the_Sun
    N = ordinal_day;
    delta = wrapTo360(-asind(0.39779*cosd(0.98565*(N+10)+1.914*sind(0.98565*(N-2)))));
end

