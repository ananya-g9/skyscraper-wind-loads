%contourplots.m
load('TPU_WindLoads_Data_Wide.mat')
dataset = Wind_pressure_coefficients;
[ns,n] = size(dataset);

mu = mean(dataset);
sig = std(dataset);
skew = skewness(dataset);
kurt = kurtosis(dataset);
r = 0; 
front_taps = []; right_taps = []; 
x_front = linspace(0,0.3); x_right = []; y_front = []; y_right = [];
for i = 1:12
   front_taps = [front_taps; (20*r+1):(20*r+15)]; % front side
   x_front = []
   right_taps = [right_taps; (20*r+16):(20*r+20)]; % right side
   r = r+1;
end
xy_front = []
% Mean contour plots
close all
figure
