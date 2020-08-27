% Est_simplified.m
% Estimates mean, std, skewness, kurtosis of a given dataset where number
% of rows is number of samples per pressure tap and number of columns is
% the number of pressure taps
load('TPU_WindLoads_Data_Wide.mat')
dataset = Wind_pressure_coefficients;
tap=1;
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
plot(dataset(:,tap),fx,'.b') % Plot normal distribution
title(['Tap number ',num2str(tap)],'FontSize',20)

%Check for GEV
p = gevfit(dataset(:,tap));
yGEV = gevpdf(dataset(:,tap),p(1),p(2),p(3));
plot(dataset(:,tap),yGEV,'.y')

%Check for gamma
k = mu(tap)^2/sig(tap)^2;
theta = sig(tap)^2/mu(tap);
yGamma  = pdf('gamma',dataset(:,tap),k,theta);
plot(dataset(:,tap),yGamma,'.g')
legend('Data','Normal','GEV','Gamma','FontSize',16)
hold off

%%%% BEGIN Q-Q PLOTS
%%normal
figure
qqplot(dataset(:,tap))
title('Q-Q plot for Normal distribution','FontSize',20)
%%GEV
figure
qqplot(dataset(:,tap),fitdist(dataset(:,tap),'GeneralizedExtremeValue'))
title('Q-Q plot for GEV distribution','FontSize',20)
%%Gamma
figure
pd=fitdist(dataset(:,tap),'Gamma');
qqplot(dataset(:,tap),pd)