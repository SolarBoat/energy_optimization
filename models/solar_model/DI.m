function [DI] = DI(AM)
% DI: Direct Insulation
%   input: Airmass
%   https://www.pveducation.org/pvcdrom/properties-of-sunlight/calculation-of-solar-insolation
    if AM == 0
        DI = 0;
    else
        DI = 1.353*0.7^(AM^0.678);
    end
end

