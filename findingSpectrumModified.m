

function [pxx,pyy,f,yfit]=...
    findingSpectrumModified(timeSig,samplingFreqn,...
    lowFreqnCut1,lowFreqnCut2)

close all

%#######################################################
%#######################################################

% This function computes the RSA estimte for a given HR
% time series. It uses the technique of Matching pursuit 
% to fit a bunch of sinusoids to extract the Respiratory
% component affecting the Tachogram. Since the respiratory 
% component affecting the tachogram is just a linear 
% addition it does well in extracting the respiratory
% component. 

% The dictionary consists of a bunch of sinusoids of 
% varying frequency ranges within the allowable range.
% Phase shifts from 0 to 2pi are given to every sinsusoid
% at a particular frequency to capture the phase
% misalignment. 

%########################################################
%########################################################



%########################################################
%########################################################

% N.B: Other methods of removing the respiraroty component
% can also be used. For example, a simple low pass filter 
% can remove the High Frequency component as well. 

%##########################################################
%##########################################################



% Pxx -- Power spectrum of the Tachogram
% Pyy -- Power spectrum of the estiamted RSA
% timeSig -- HR series for a particular window


%%% Building the dictionary and performing MP %%%

% Time bins for the time signal
t=1:1:length(timeSig);

%##################################################
% Bounds for the frerquency decimation
% calculated on the basis of the sampling freqn,
% the length of the timeSignal
% and the Freqn ranges.
% For example, if 'n'is the number of samples in 
% the signal at 'f' Hz then we can calculate the 
% amount of decimation needed to make it lie between 
% the allowable frequency ranges generally considered
% for the respiratory component. 
%###################################################

%Bounds for the amount of decimation needed
%to get it to the upper bound. 
finalBound=samplingFreqn*lowFreqnCut2;
initialBound=samplingFreqn*lowFreqnCut1;

% Amount of frequency decimation from the original signal
% to build the dictionary%
decmtFact=initialBound:1:finalBound;

%Phase shifts at a particualr frequency%
phaseShift=0:pi/5:2*pi;

%Amplitude scaling:
ampShift = 0.1:0.3:1;

%%Pre-allocating the dictionary
rsaDict = zeros(length(timeSig), length(phaseShift)*length(decmtFact));

%%  Buliding the dictionary %%%

count=1;

for amp=1:length(ampShift)

for j=1:length(decmtFact)

    for phaseIdx=1:length(phaseShift)
        
    rsaDict(:,count) =...
    amp*cos(t/decmtFact(j)+phaseShift(phaseIdx)) + wgn(1,length(timeSig),0.01)
    +(amp/2)*cos(t/(100*decmtFact(j))+phaseShift(phaseIdx));

     count=count+1;
    
     end
 end

[yfit,~,~,~,~]=wmpalg('OMP',timeSig,rsaDict);

% frequency bins
f=0:0.01:1; 

% Power spectrum for the  estimated RSA
%                                                  
pyy=pwelch(yfit,[],[],f,samplingFreqn);
figure;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
plot(f,pyy,'*');
hold

% Definining the BPF object
bpFilt = designfilt('bandpassfir','FilterOrder',200, ...
'CutoffFrequency1',0.03,'CutoffFrequency2',0.7,...
'SampleRate',samplingFreqn);                                 

%%Performing filtering as a pre-processing step
% as suggested in the literature...
%%dataOut=filter(bpFilt,TimeSig);

% Power spectrum of the original tachigram
% the time window of the original HR 
% series.
pxx=pwelch(timeSig,[],[],f,samplingFreqn);

plot(f,pxx,'--');
legend('Spectrum of the RSA component','Spectrum of the Original Tachogram');
xlim([0.15 1])
ylim([0,2.5e-2])
xlabel('Frequency in Hz');
ylabel('Power in S^2/Hz');

end


end




