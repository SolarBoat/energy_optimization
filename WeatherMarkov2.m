function W = WeatherMarkov2(p10, pe, p90, Nw)
%WEATHERMARKOV Summary of this function goes here
%   Detailed explanation goes here
    W = (1-1/Nw) * eye(3) + (1/Nw) * [2*p10, pe, 0;
                                      p10, pe, p90;
                                      0, pe, 2*p90];
end

