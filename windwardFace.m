%windwardFace.m
load('TPU_WindLoads_Data_Wide.mat')
dataset = Wind_pressure_coefficients;
close all
m = 5; n = 5;
taps = [1 4 7 10 13 15 121 124 127 130 133 135 241 244 247 250 253 255 ...
    361 364 367 370 373 375 441 444 447 450 453 455];
mu = mean(dataset);
sig = std(dataset);
skew = skewness(dataset);
kurt = kurtosis(dataset);

for c = 1:m*n
    tap = taps(c);
    fx = pdf('normal',dataset(:,tap),mu(tap),sig(tap)); % NORMAL
    subplot(m,n,c)
    histogram(dataset(:,tap),'Normalization','pdf','NumBins',150) % Plot density
    hold on
    %plot(dataset(:,tap),fx,'b.') % Plot normal distribution
    title(['Histogram for tap number ',num2str(tap)])
    xlim([-0.5 1.5])
    ylim([0 4])
    alpha = sqrt(1.645)/sig(tap); u = mu(tap) - 0.577216/alpha;
    syms yGumb(x)
    yGumb = alpha*exp(-alpha*(x-u) - exp(-alpha*(x-u)));
    %fplot(yGumb, [min(dataset(:,tap)),max(dataset(:,tap))],'-r')
    k = mu(tap)^2/sig(tap)^2;
    theta = sig(tap)^2/mu(tap);
    yGamma  = pdf('gamma',dataset(:,tap),k,theta);
    %plot(dataset(:,tap),yGamma,'.g')
    %legend('Data', 'Fitted Normal', 'Fitted Gumbel', 'Fitted Gamma')
    hold off
end