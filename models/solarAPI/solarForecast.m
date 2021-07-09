function func = solarForecast(filename)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
solar_data = readtable(filename);
func = @sIntegral;
    function energy = sIntegral(t1, t2)
        i1 = floor(2*t1) + 1;
        i2 = floor(2*t2) + 1;
        energy = 0;
        for i = i1:i2-1
            energy = energy + 0.5*(solar_data.PvEstimate(i) + solar_data.PvEstimate(i+1))/2;
        end
        energy = energy - mod(t1, 0.5)*(solar_data.PvEstimate(i1) + (solar_data.PvEstimate(i1 + 1) - solar_data.PvEstimate(i1))/0.5*mod(t1, 0.5)/2);
        energy = energy + mod(t2, 0.5)*(solar_data.PvEstimate(i1) + (solar_data.PvEstimate(i1 + 1) - solar_data.PvEstimate(i1))/0.5*mod(t2, 0.5)/2);
    end
end

