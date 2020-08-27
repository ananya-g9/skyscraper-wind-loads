load('TPU_WindLoads_Data_Wide.mat');
dataset=Wind_pressure_coefficients;
mu = mean(dataset);
sig = std(dataset);
skew = skewness(dataset);
kurt = kurtosis(dataset);
    
Start=1;    %Start tab of top row
END=40;     %End tab of top row
W=40;       %Total number of tabs in each row
Zmu = []; Zsig = []; Zskew = []; Zkurt = [];
X=[Location_of_measured_points(1,Start:END)];
Y=[];
for k=1:12
    Off=(k-1)*W;
    Zmu=[Zmu;mu(Off+Start:Off+END)];
    Zsig=[Zsig;sig(Off+Start:Off+END)];
    Zskew=[Zskew;skew(Off+Start:Off+END)];
    Zkurt=[Zkurt;kurt(Off+Start:Off+END)];
    Y=[Y,Location_of_measured_points(2,Off+Start)];
end
close all
figure
contourf(X,Y,Zmu,':') % Mean
caxis([min(mu) max(mu)])
colormap autumn
colorbar
daspect([1 1 1])
set(findall(gcf,'-property','FontSize'),'FontSize',14)
title('Contour plot of mean','FontSize',18)

figure
contourf(X,Y,Zsig,':') % Standard deviation
caxis([min(sig) max(sig)])
colormap winter
colorbar
daspect([1 1 1])
set(findall(gcf,'-property','FontSize'),'FontSize',14)
title('Contour plot of SD','FontSize',18)

figure
contourf(X,Y,Zskew,':') % Skew
caxis([min(skew) max(skew)])
colormap spring
colorbar
daspect([1 1 1])
set(findall(gcf,'-property','FontSize'),'FontSize',14)
title('Contour plot of skewness','FontSize',18)

figure
contourf(X,Y,Zkurt,':') % Kurtosis
caxis([min(kurt) max(kurt)])
colormap summer
colorbar
daspect([1 1 1])
set(findall(gcf,'-property','FontSize'),'FontSize',14)
title('Contour plot of kurtosis','FontSize',18)