function [mu_est, sig_est, skew_est, kurt_est,count,n_axis] = est_Moments(ns)
% generates parameter estimates for Gaussian distribution with max sample size
% n and number of sample sets ns
load('TPU_WindLoads_Data_Wide.mat')
u = Wind_pressure_coefficients(:,1:ns);
[n, ns] = size(u);
mu_est = []; sig_est = []; skew_est = []; kurt_est = [];
count = 0;
n_axis = [];
for i = 10:10:n
    count = count + 1;
    for j = 1:ns
        mu_est(count,j) = mean(u(1:i,j));
        sig_est(count,j) = std(u(1:i,j));
        skew_est(count,j) = skewness(u(1:i,j));
        kurt_est(count,j) = kurtosis(u(1:i,j)); 
    end
    n_axis(count) = i;
end
close all
figure
subplot(2,2,1)
plot(n_axis, mu_est,'-')
title(['Mean estimates for sample sizes up to ',num2str(n)])
legend('Tap 1', 'Tap 2', 'Tap 3', 'Tap 4', 'Tap 5')
xlim([1,n]); xlabel('Sample size'); ylabel('Mean estimate;')

subplot(2,2,2)
plot(n_axis, sig_est,'-')
title(['Standard deviation estimates for sample sizes up to ',num2str(n)])
legend('Tap 1', 'Tap 2', 'Tap 3', 'Tap 4', 'Tap 5')
xlim([1,n]); xlabel('Sample size'); ylabel('Standard deviation estimate;')

subplot(2,2,3)
plot(n_axis, skew_est,'-')
title(['Skewness estimates for sample sizes up to ',num2str(n)])
legend('Tap 1', 'Tap 2', 'Tap 3', 'Tap 4', 'Tap 5')
xlim([1,n]); xlabel('Sample size'); ylabel('Skewness estimate;')

subplot(2,2,4)
plot(n_axis, kurt_est,'-')
title(['Kurtosis estimates for sample sizes up to ',num2str(n)])
legend('Tap 1', 'Tap 2', 'Tap 3', 'Tap 4', 'Tap 5')
xlim([1,n]); xlabel('Sample size'); ylabel('Kurtosis estimate;')