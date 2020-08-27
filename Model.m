load('TPU_WindLoads_Data_Wide.mat')
dataset = double(Wind_pressure_coefficients);
tap=16;

mu = mean(dataset);
Didwenegate=1;

if mu(tap)<0
    dataset=-dataset;
    Didwenegate=-1;
end

%mu = mean(dataset);
%sig = std(dataset);
%skew = skewness(dataset);
%kurt = kurtosis(dataset);

%Check for GEV
p = gevfit(dataset(:,tap));
yGEV = gevpdf(dataset(:,tap),p(1),p(2),p(3));

%hold
%histogram(dataset(:,tap),'Normalization','pdf','NumBins',150)
%plot(dataset(:,tap),yGEV,'.y');

%%%%%%%%%%%%%%%%%%%%% Generate C plot

n=length(dataset(:,tap));
ehhh=300;
%32768

Tstep=1; %ms

kk=ehhh/Tstep;

Count=0;
stopcount=1;

for k=1:kk
   
    C(k)=corr(dataset(1:n-Tstep*k,tap),dataset(Tstep*k+1:n,tap));
    
    if C(k)>0
        Count=Count+1*stopcount;
    else
        stopcount=0;
    end
    
end

C=[1,C];

Z=(0:Tstep:Count+100)/1000;

figure
plot(Z,C(1:Count+101))
hold

HMM=1000; %What do you want m to be?   1000 is decent, computations 
%for lsqnonneg ~n^2 so time is increase significantly

Ninto=ceil(HMM/Count)-1;

intoC=[];


for k=1:ehhh

    intoXvals=(1:Ninto)/(Ninto+1);
    
    Slope=(C(k+1)-C(k));
    
    intoYvals=Slope*intoXvals+C(k);
    
    intoC=[intoC,C(k),intoYvals];
    
end

intoC=[intoC,C(ehhh+1)];

intoTimestep=(1/(Ninto+1))/1000;

%plot(0:intoTimestep:max(Z),.01+intoC)

%%%%%%%%%%%%%%%%%%%%% Guess at sigmas

m=Count*(Ninto+1);

intoZ=0:intoTimestep:intoTimestep*(m-1);

T=32.768; %ms T=32.768;

Vk=((2*pi)/T)*(1:m);


VkZ=Vk'*intoZ;

COS=cos(VkZ);


SIGS=lsqnonneg(COS',intoC(1:m)');

SigKCos=SIGS(:,1).*COS;
    
Totalsigcos(:,1)=sum(SigKCos,1);

Err=sum(intoC(1:m)'-Totalsigcos,1);

CGuess=sum(SIGS.*COS,1);

plot(intoZ,CGuess)

%%%%% GEN random normal time funciton thing

t=0:0.001:T;

SIG=SIGS.^.5;

CT=cos(Vk'*t);

ST=sin(Vk'*t);

ns=1;

for i=1:ns
    
    G(i,:)=zeros(1,T*1000+1);
    
    for k=1:m
        A=randn(1,1);
        B=randn(1,1);
        G(i,:)=G(i,:)+SIG(k)*(A*CT(k,:)+B*ST(k,:));
    end
end

%figure
%plot(t,G(1,:))


model=gevinv(normcdf(G,0,sum(SIGS)),p(1),p(2),p(3))';

VVVAAAARRR=mean(var(G));

%sum(SIGS)

figure
plot(t,model(:,1))

figure
plot(dataset(:,tap),yGEV,'.r');
hold

histogram(model(:,1),'Normalization','pdf','NumBins',150)
p1 = gevfit(model(:,1));
modelGEV = gevpdf(model(:,1),p1(1),p1(2),p1(3));
plot(model(:,1),modelGEV,'.b');

%}
