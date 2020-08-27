load('TPU_Windloads_Data_Wide.mat')
dataset = double(Wind_pressure_coefficients);
mu = mean(dataset);
rng(8723)

m = 10; % accuracy of random function
ns = 10; %number of samples
%EXC=[0.001,0.01,0.05,0.1]; %Exceedence probabilities
EXC = 0.001;

Taps = [1:480]; %has to be consecutive
COEF = zeros(length(Taps),1);

for tap=1:length(Taps)
COEF(tap) = Copy_of_Model(dataset(:,tap),m,ns,EXC,mu(tap));
end

% Making contour plots
Start = 1;    %Start tap of top row
END= 40;     %End tap of top row
W=40;       %Total number of taps in each row

X_Cp = [Location_of_measured_points(1,Start:END)];
Z_Cp = [];
Y_Cp = [];

for k = 1:floor(length(Taps)/40)
    Off=(k-1)*W;
    Z_Cp = [Z_Cp; COEF(Off+Start:Off+END)'];
    Y_Cp = [Y_Cp,Location_of_measured_points(2,Off+Start)];
end

close all
figure
contourf(X_Cp,Y_Cp,Z_Cp,20,':') 
caxis([min(COEF) max(COEF)])
colormap jet
colorbar
daspect([1 1 1])
set(findall(gcf,'-property','FontSize'),'FontSize',14)
title(['Contour plot for exceedance probability of ',num2str(EXC)],'FontSize', 16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
function [Values] = Copy_of_Model(Data,m,ns,EXC,mu)
%{
Data - is the time series data for a given tab
m - is this accuracy of the random function
ns - is the number of samples
EXC - is the exceedance probability we want to know pressure coeff for
mu - is the mean of the time series data for the given tab
Values - is the presure coefficients for the given exceedence probability
%}
Didwenegate=1;
if mu<0
    Data=-Data;
    Didwenegate=-1;
end

%Check for GEV
p = gevfit(Data);
%yGEV = gevpdf(Data,p(1),p(2),p(3));

%hold
%histogram(dataset(:,tap),'Normalization','pdf','NumBins',150)
%plot(dataset(:,tap),yGEV,'.y');

%%%%%%%%%%%%%%%%%%%%% Generate C plot
n=length(Data);
END = m + 10; %
%32768
Count=0;
stopcount=1;
C = zeros(END,1);

for k=1:END
    C(k)=corr(Data(1:n-k),Data(k+1:n));
    if C(k)>0
        Count=Count+1*stopcount;
    else
        stopcount=0;
    end
end

C=[1;C];
C(Count+1:END+1)=0;
%Z=(0:1:Count+100)/1000;

%{
figure
plot(Z,C(1:Count+101))
ylabel('C(Z)'); xlabel('Z (s)')
hold
%}
%%%%%%%%%%%%%%%%%%%%% Guess at sigmas

Z=0:0.001:0.001*(m-1);

T=32.768; % T=32.768;

Vk=((2*pi)/T)*(1:m);

VkZ=Vk'*Z;

COS=cos(VkZ);

SIGS=lsqnonneg(COS',C(1:m));

%SigKCos=SIGS(:,1).*COS;
%Totalsigcos(:,1)=sum(SigKCos,1);
%Err=sum((C(1:m)'-Totalsigcos).^2,1); %not s=to sure how to handle error
%CGuess=sum(SIGS.*COS,1);
%plot(Z,CGuess)

%%%%% GEN random normal time function thing
t=0:0.001:T;
SIG=SIGS.^.5;
CT=cos(Vk'*t);
ST=sin(Vk'*t);

A=randn(m,ns); B=randn(m,ns); % Generate Ak and Bk
G = zeros(32769,10);

for k=1:ns
G(:,k)=sum(SIG.* (A(:,k).*CT+B(:,k).*ST));
end

model = zeros(32769,10);
Max = zeros(ns,1);

for k=1:ns
model(:,k)=gevinv(normcdf(G(:,k),0,sum(SIGS)),p(1),p(2),p(3))';
Max(k)=max(model(:,k));
end

[f,x]= ecdf(Max);
IND = sum(f<(1-EXC));
Values =x(IND);
Values=Values*Didwenegate;
end