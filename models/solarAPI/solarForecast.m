function [solar_data, funcArray] = solarForecast(filename, power)

    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    solar_data = readtable(filename);

    func = @sIntegral;
    function energy = sIntegral(t1, t2, pvEstimate)
        i1 = floor(2*t1) + 1;
        i2 = floor(2*t2) + 1;
        energy = 0;
        for i = i1:i2-1
            energy = energy + 0.5*(pvEstimate(i) + pvEstimate(i+1))/2;
        end
        energy = energy - mod(t1, 0.5)*(pvEstimate(i1) + (pvEstimate(i1 + 1) - pvEstimate(i1))/0.5*mod(t1, 0.5)/2);
        energy = energy + mod(t2, 0.5)*(pvEstimate(i2) + (pvEstimate(i2 + 1) - pvEstimate(i2))/0.5*mod(t2, 0.5)/2);
        energy = energy * power;
    end

    funcArray = {@(t1, t2) func(t1, t2, solar_data.PvEstimate10), @(t1, t2) func(t1, t2, solar_data.PvEstimate), @(t1, t2) func(t1, t2, solar_data.PvEstimate90)};
end
