function [LSTM] = LSTM(timezone)
% LSTM: Local Standard Time Meridian
%   input: timezone (Local time to UTC difference)
%   output: LSTM in degrees
%   https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-time
    LSTM = wrapTo360(15*timezone);
end

