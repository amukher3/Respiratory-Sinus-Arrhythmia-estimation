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

function [rrIntervals] = ...
    simulatingRRIntervals()

clear all

%Getting the parameter values
[bound1,bound2,lengthTimeSignal, ~, ~, ~, ~] = settingTheParameters()

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
%Plotting the original IBI time series
figure;
plot(1:length(rrIntervals),rrIntervals)
legend('Original R-R time series')

end

