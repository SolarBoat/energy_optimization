clear variables
close all
clc

addpath('C:\Users\lukas\Documents\CasADi')
import casadi.*

dt = datetime('now');

lt_0 = dt.Hour + dt.Minute/60;
ordinal_day = day(dt,'dayofyear');


time_zone = 1; % Germany UTC+1
local_time = linspace(lt_0, lt_0+48, 500);
latitude = 47.997791; % Freiburg coordinates
longitude = 7.842609;

di = arrayfun(@(t) di_full_model(ordinal_day, time_zone, t, latitude, longitude), local_time);

plot(local_time, di)
