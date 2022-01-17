


function [pxx,pyy,f,yfit]=...
    FindingSpectrum(TimeSig,SamplingFreqn,...
    HighFreqnCut1,HighFreqnCut2)

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
% TimeSig -- HR series for a particular window


%%% Building the dictionary and performing MP %%%

% Time bins for the time signal
t=1:1:length(TimeSig);

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
FinalBound=SamplingFreqn*HighFreqnCut2;
InitialBound=SamplingFreqn*HighFreqnCut1;

% Amount of frequency decimation from the original signal
% to build the dictionary%
DecmtFact=InitialBound:.1:FinalBound;

%Phase shifts at a particualr frequency%
PhaseShift=0:pi/100:2*pi;

%Amplitude scaling:
ampShift = 0.1:0.1:1;

%%Pre-allocating the dictionary
rsaDict = zeros(length(TimeSig), length(PhaseShift)*length(DecmtFact));

%%  Buliding the dictionary %%%

Count=1;

for amp=1:length(ampShift)

for j=1:length(DecmtFact)

    for PhaseIdx=1:length(PhaseShift)
        
    rsaDict(:,Count)=...
    amp*cos(t/DecmtFact(j)+PhaseShift(PhaseIdx)) + 0.1;

    
     Count=Count+1;
    
     end
 end

[yfit,~,~,~,~]=wmpalg('OMP',TimeSig,rsaDict);

% frequency bins
f=0:0.01:1; 

% Power spectrum for the  estimated RSA
pyy=pwelch(yfit,[],[],f,SamplingFreqn);
close;
plot(f,pyy,'*');
hold

% Definining the BPF object
bpFilt = designfilt('bandpassfir','FilterOrder',200, ...
'CutoffFrequency1',0.03,'CutoffFrequency2',0.7,...
'SampleRate',SamplingFreqn);

%Performing filtering as a pre-processing step
% as suggested in the literature...
dataOut=filter(bpFilt,TimeSig);

% Power spectrum of the original tachigram
% the time window of the original HR 
% series.
pxx=pwelch(TimeSig,[],[],f,SamplingFreqn);

 plot(f,pxx,'--');
 legend('Spectrum of the RSA component','Spectrum of the Original Tachogram');
 xlim([0.15 1])
 ylim([0,2.5e-2])
 xlabel('Frequency in Hz');
 ylabel('Power in S^2/Hz');

end


end

% plot(f,pxx,'*');



