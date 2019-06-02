% Pxx -- Power spectrum of the Tachogram
% Pyy -- Power spectrum of the estiamted RSA
% TimeSig -- Tachogram for a particular user

function [pxx,pyy,f,yfit]=...
    FindingSpectrum(TimeSig,SamplingFreqn)


%%% Building the dictionary and performing MP %%%

% Time bins for the time signal
t=1:1:length(TimeSig);

%DecmtFact=10:5:50;
%DecmtFact=35:5:80;
%DecmtFact=35:1:50;
%DecmtFact=35:0.5:50;
%DecmtFact=50:0.5:52;
%DecmtFact=20:2:62;
%DecmtFact=20:2:60;
%DecmtFact=40:5:50;

%Decimating Factor -- decides the amount of frequency decimation..
%increasing the bound moves the CF peak position to a higher value.

%Increasing the final bound affects the HF power more 
%
FinalBound=150;
InitialBound=1;

%Amount of Decimation in the dictionary
DecmtFact=InitialBound:1:FinalBound; 

Amp=0.5:0.5:10;

%%%  Buliding the dictionary %%
Count=1;

for j=1:length(DecmtFact)
%     for k=1:length(Amp)
        
    rsaDict(:,Count)=...
        1*(sin(t/DecmtFact(j)));
    Count=Count+1;
    
%     end
end

[yfit,r,coeff,iopt,qual]=wmpalg('OMP',TimeSig,rsaDict);

%yfit=r;
%%% DownSampling the RR series %%%
% Needed only if we want to downsample to a lower
% Frequency than the original frequency

% DownSamFreq=4;
% TimeSig2=downsample(TimeSig,round(SamplingFreqn/DownSamFreq));


%yfit is the estimated RSA. 
% plot(yfit); 
% figure

% frequency bins
f=0:0.001:1; 

% Power spectrum for the  estimated RSA
pyy=pwelch(yfit,[],[],f,SamplingFreqn);

% plot(f,pyy,'*');
% hold

% % Definining the BPF object
% bpFilt = designfilt('bandpassfir','FilterOrder',200, ...
% 'CutoffFrequency1',0.05,'CutoffFrequency2',0.7,...
% 'SampleRate',SamplingFreqn);
% 
% % Performing filtering 
% dataOut=filter(bpFilt,TimeSig);

% Power spectrum of the original tachigram
pxx=pwelch(TimeSig,[],[],f,SamplingFreqn);


end

% plot(f,pxx,'*');
% legend('Spectrum of the RSA component','Spectrum of the Original Tachogram');
% xlim([0.15 1])
% xlabel('Frequency in Hz');
% ylabel('Power in S^2/Hz');