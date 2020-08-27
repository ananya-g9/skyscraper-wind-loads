function [mu, sig, skew, kurt] = Est_parameters(tap)
% Estimates mean, std, skewness, kurtosis of a given dataset where number
% of rows is number of samples per pressure tap and number of columns is
% the number of pressure taps
load('TPU_WindLoads_Data_Wide.mat')
dataset = - Wind_pressure_coefficients;
[ns,n] = size(dataset);

mu = mean(dataset);
sig = std(dataset);
skew = skewness(dataset);
kurt = kurtosis(dataset);

% Check how normal distribution is
phi = cdf('normal',dataset(:,tap),mu(tap),sig(tap));
fx = pdf('normal',dataset(:,tap),mu(tap),sig(tap));
close all
figure
hold on
histogram(dataset(:,tap),'Normalization','pdf','NumBins',150) % Plot density
plot(dataset(:,tap),fx,'b.') % Plot normal distribution
title(['Histogram for tap number ',num2str(tap)],'FontSize', 16)

% Check for Gumbel distribution
alpha = sqrt(1.645)/sig(tap); u = mu(tap) - 0.577216/alpha;
syms yGumb(x)
yGumb = alpha*exp(-alpha*(x-u) - exp(-alpha*(x-u)));
fplot(yGumb, [min(dataset(:,tap)),max(dataset(:,tap))],'-r') % Plot Gumbel

alpha2 = sqrt(1.645)/sig(tap); u2 = mu(tap) - 0.577216/alpha2;
yGumb2 = evpdf(dataset(:,tap),u2,1/alpha2);
plot(dataset(:,tap),yGumb2,'.c') % Plot min Gumb

p = gevfit(dataset(:,tap));
yGEV = gevpdf(dataset(:,tap),p(1),p(2),p(3));
plot(dataset(:,tap),yGEV,'.y')

%Check for gamma
k = mu(tap)^2/sig(tap)^2;
theta = sig(tap)^2/mu(tap);
yGamma  = pdf('gamma',dataset(:,tap),k,theta);
plot(dataset(:,tap),yGamma,'.g')

%Check for 

legend('Data', 'Fitted Normal', 'Fitted Gumbel','Fitted Min Gumbel','Fitted GEV','Fitted Gamma','FontSize',12,'Location','best')
hold off
