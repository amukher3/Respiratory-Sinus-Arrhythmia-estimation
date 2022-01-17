%#####################################
%#####################################
%ToDo: Find Spectrum of Simulated Data
%Derive IBI using some distribution
%where the R-R interval is drawn 
%from some distribution.
%compare the results with the DEAP
%dataset. 

%Poisson's distribution is probably
%the most suited distribution here
%for drawing the R-R intervals.
%Use the physiological bounds to approx.
%the distribution parameters.
%####################################
%####################################

%lengthTimeSig --> length of the time signal in samples
%bound1 ---> lower bound of the R-R intervals
%bound2 ---> higher bound of the R-R intervals

function [pxx,pyy] = ...
    findingSpectrumSimulatedData()

clear all
close all

%Wait bar
wBar = waitbar(1,'Percentage Completed...');
pause(1)

bound1 = 0.6 % as time in seconds
bound2 = 1.2 % as time in seconds

%length of the time Signal
lengthTimeSignal = 2000; 

%sampling freqn taken as the general freqn in literature
samplingFreqn = 128; 

%Assumed white Gaussian noise variance
noiseVariance = 0.01

%lower cut-off freqns
lowerCutFreqn1 = 0.05 % in Hertz
lowerCutFreqn2 = 0.40 % in Hertz

%calculates the R-R intervals
[rrIntervals] = computingRRIntervals(bound1,bound2,lengthTimeSignal)

%Computes the fitted time series using MP or OMP
[yfit] = findingFittedSeries(lowerCutFreqn1,lowerCutFreqn2,samplingFreqn,...
                        noiseVariance,rrIntervals,lengthTimeSignal)

%Plotting the original IBI time series
figure;
plot(1:length(rrIntervals),rrIntervals)
legend('Original R-R time series')

%plotting the fitted Time Series
figure;
plot(1:length(yfit),yfit)
legend('Fitted IBI time Series')

end


function plottingSpectrums(rrIntervals,yfit,samplingFreqn)

% Normalized frequency bins
f=0:0.01:1; 

%calculating the spectrum of the fitted IBI time series:
pyy=pwelch(yfit,[],[],f,samplingFreqn);

%calculating the spectrum of the original IBI time series:
pxx=pwelch(rrIntervals,[],[],f,samplingFreqn);

%plotting the spectrums
figure;
plot(f,pyy,'*');
hold
plot(f,pxx,'--');
legend('Spectrum of the RSA component','Spectrum of the Original Tachogram');
xlim([0 0.6])
ylim([0, 1])
xlabel('Frequency in Hz');
ylabel('Power in S^2/Hz');

end



function [rrIntervals]=...
computingRRIntervals(bound1,bound2,lengthTimeSignal)

upperRateInterval = (bound1+bound2)/2
lowerRateInterval = (bound2-bound1)/2

%pre-allocating the size for R-R intervals
rrIntervals = zeros(1,lengthTimeSignal);


for t=1:lengthTimeSignal

%The rate parameter is drawn from a uniform distribution
%between upperRateInterval and lowerRateInterval
%It can be assumed that the this is a prior on the
%rate parameter of the poisson's distribution.
lambda = unifrnd(lowerRateInterval,upperRateInterval)


%Generally, for poisson distribution we need to
%specify the num.of events parameter(k) i.e
%k=0,1,2....for a certain 'lambda' since the 
%value of lambda can lie between 0.3s to 0.9s
%we can safely say that the value of k between
%these two values will be very close to 1 if not 1.
%N.B: IBI is between 0.6s to 1.2s i.e to
k = unifrnd(0.99,1)

%Drawing from poisscdf
rrIntervals(t) = poisscdf(k,lambda);

end

end



function [rrIntervals,yfit] = ...
    findingFittedSeries(lowerCutFreqn1,lowerCutFreqn2,samplingFreqn,...
                        noiseVariance,rrIntervals,lengthTimeSignal)

%Bounds for the amount of decimation needed
%to get it to the upper bound. 
lowerBound = lowerCutFreqn1*samplingFreqn;
higherBound = lowerCutFreqn2*samplingFreqn;

%Amount of frequency decimation from the original signal
%to build the dictionary%
decmtFact = lowerBound:1:higherBound;

%Phase shifts at a particualr frequency%
phaseShifts=0:pi/5:2*pi;

%Amplitude scaling:
ampShifts = 0.1:0.3:1;

%Pre-allocating the dictionary
rsaDict = zeros(lengthTimeSignal, length(phaseShifts)*length(decmtFact));

%Buliding the dictionary 
count = 1;

%Fitted time singal index points
t = 1:1:lengthTimeSignal

for amp=1:length(ampShifts)

for j=1:length(decmtFact)

    for phaseIdx=1:length(phaseShifts)
        
    rsaDict(:,count) = ...
    amp*cos(t/decmtFact(j)+ phaseShifts(phaseIdx)) + ...
    (amp/2)*cos(t/(100*decmtFact(j))+ phaseShifts(phaseIdx));

     count = count+1;
    
     end
end

 %Band-passing the IBI time series:
 % Definining the BPF object
 bpFilt = designfilt('bandpassfir','FilterOrder',200, ...
 'CutoffFrequency1',0.01,'CutoffFrequency2',0.5,...
'SampleRate',samplingFreqn);                                 

%%Performing filtering as a pre-processing step
%as suggested in the literature...
dataOut=filter(bpFilt,rrIntervals);

 %Doing Matching Pursuit
[yfit,~,~,~,~]=wmpalg('OMP',dataOut,rsaDict);

%Calling the function to plot
%the spectrums
plottingSpectrums(rrIntervals,yfit,samplingFreqn)


end

end



