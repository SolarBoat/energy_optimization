function W = WeatherMarkov(p10, pe, p90, Nw)
%WEATHERMARKOV Summary of this function goes here
%   Detailed explanation goes here
    W = (1-1/Nw) * eye(3) + (1/Nw) * [p10, pe, p90;
                                      p10, pe, p90;
                                      p10, pe, p90];
end

