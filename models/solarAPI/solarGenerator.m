function funcArray = solarGenerator(power, day_of_year, weather)
    addpath('models/solar_model');
    latitude = 47.997791; % Freiburg coordinates
    longitude = 7.842609;
    
    solar_data = [];
    solar_data10 = [];
    solar_data90 = [];
    
    for day = 1:length(weather)
        base_data = arrayfun(@(t) di_full_model(day_of_year + day - 1, 1, t, latitude, longitude), 0:0.5:23.5);
        solar_data = [solar_data, base_data * weather(day)];
        c10 = max(0.035, -0.25 + 3/4 * weather(day));
        solar_data10 = [solar_data10, base_data * c10];
        c90 = (weather(day) + (1 - weather(day)) * 0.5);
        solar_data90 = [solar_data90, base_data * c90];
    end
    
    solar_data = [solar_data, 0, 0];
    solar_data10 = [solar_data10, 0, 0];
    solar_data90 = [solar_data90, 0, 0];
    

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

    funcArray = {@(t1, t2) func(t1, t2, solar_data10), @(t1, t2) func(t1, t2, solar_data), @(t1, t2) func(t1, t2, solar_data90)};
end
