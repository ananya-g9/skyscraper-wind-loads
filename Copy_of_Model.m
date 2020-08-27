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
yGEV = gevpdf(Data,p(1),p(2),p(3));

%hold
%histogram(dataset(:,tap),'Normalization','pdf','NumBins',150)
%plot(dataset(:,tap),yGEV,'.y');

%%%%%%%%%%%%%%%%%%%%% Generate C plot
n=length(Data);
END=30000; %
%32768
Count=0;
stopcount=1;

for k=1:END
    C(k)=corr(Data(1:n-k),Data(k+1:n));
    if C(k)>0
        Count=Count+1*stopcount;
    else
        stopcount=0;
    end
end

C=[1,C];
C(Count+1:END+1)=0;
Z=(0:1:Count+100)/1000;

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

SIGS=lsqnonneg(COS',C(1:m)');

SigKCos=SIGS(:,1).*COS;
    
Totalsigcos(:,1)=sum(SigKCos,1);

Err=sum((C(1:m)'-Totalsigcos).^2,1); %not s=to sure how to handle error

CGuess=sum(SIGS.*COS,1);

%plot(Z,CGuess)

%%%%% GEN random normal time function thing
t=0:0.001:T;
SIG=SIGS.^.5;
CT=cos(Vk'*t);
ST=sin(Vk'*t);

A=randn(m,ns); B=randn(m,ns); % Generate Ak and Bk

for k=1:ns
G(:,k)=sum( SIG.* (A(:,k).*CT+B(:,k).*ST));
end

for k=1:ns
model(:,k)=gevinv(normcdf(G(:,k),0,sum(SIGS)),p(1),p(2),p(3))';
Max(k)=max(model(:,k));
end

[f,x]=ecdf(Max);
IND = sum(f<(1-EXC));
Values =x(IND);
Values=Values*Didwenegate;