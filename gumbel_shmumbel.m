%gumbel_shmumbel.m
rng default;  % For reproducibility
load('TPU_WindLoads_Data_Wide.mat')
dataset = Wind_pressure_coefficients(:,357);
%xMaxima = max(randn(1000,500), [], 2);
xMaxima = dataset;
paramEstsMaxima = evfit(-xMaxima);
y = linspace(1.5,5,1001);
histogram(xMaxima,1.75:.25:4.75);
p = evpdf(-y,paramEstsMaxima(1),paramEstsMaxima(2));
line(y,.25*length(xMaxima)*p,'color','r')