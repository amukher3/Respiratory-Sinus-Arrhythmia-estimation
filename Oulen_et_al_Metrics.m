clearvars -except RSAest RR_series 
close all
%function [PowerOriginal,RSAPower]= DistanceMetricFrequencySpectrum
%Number of users


% rowIdx=1;colIdx=1;
% for FinalBound=80:10:1000
%     
%     for InitialBound=1:2:20
        
NumUsers=32;
NumVideos=40;

for UserIdx=1:NumUsers
    
%String formatting for loading the data   
formatSpec =...
    'C:\\Users\\Abhishek Mukherjee\\Downloads\\RR_series_user%d.mat';

Num=UserIdx;
str=sprintf(formatSpec,Num);
load(str);
 
SamplingFreqn=128;
 
rsaUser=RSAest{1,UserIdx};

%   rsaSigPrime=cell2mat(RSAest(UserIdx)); 
%   TimeSigPrime=cell2mat(RR_series(UserIdx));
%   rsaSig=rsaSigPrime;
%   rsaSig=rsaSig/(max(abs(rsaSig)));
%   TimeSig=TimeSigPrime;
%   TimeSig=TimeSig/max(abs(TimeSig));

 for VidIdx=1:NumVideos
     
 rsaSig=rsaUser(VidIdx,:); 
 %rsaSig=rsaSig/max(abs(rsaSig));
 TimeSig=cell2mat(RR_series(VidIdx));
% TimeSig=TimeSig/max(abs(TimeSig));

% High frequency range: 0.25-0.45hz
HighFreqnCut1=0.20;
HighFreqnCut2=0.45;

% low frequency range: 0.05-0.15hz
LowFreqnCut1=0.05;
LowFreqnCut2=0.15;

%pxx -- Original spectrum
%pyy -- RSA spectrum

[pxx,pyy,pzz,f,yfit] =...
    FindingSpectrumWithRespSig(TimeSig,rsaSig,SamplingFreqn,...
    HighFreqnCut1,HighFreqnCut2);

% High cutoff freqns 
[~,HighCutoff1]=min(abs(f-HighFreqnCut1));
[~,HighCutoff2]=min(abs(f-HighFreqnCut2));

% Low cutoff freqns 
[~,LowCutOff1]=min(abs(f-LowFreqnCut1));
[~,LowCutOff2]=min(abs(f-LowFreqnCut2));

%% Original Tachogram 

%High frequency spectrum for Original Tachogram
HFspectrum.Original=pxx(HighCutoff1:HighCutoff2); 

%Low frequency spectrum for Original Tachogram
LFspectrum.Original=pxx(LowCutOff1:LowCutOff2); 

%High Frequency Power in the Original Tachogram
HFpower.Original(UserIdx,VidIdx)=...
    sum(pxx(HighCutoff1:HighCutoff2)); 

%Low Frequency Power in the Original Tachogram
LFpower.Original(UserIdx,VidIdx)=...
    sum(pxx(LowCutOff1:LowCutOff2)); 

Mx=[]; Ix=[];
%Looking for the High Frequency peak(center frequency) 
%in the Original Tachogram spectrum
[Mx,Ix]=max(HFspectrum.Original);
HFpeak.Original(UserIdx,VidIdx)=...
    f(Ix+HighCutoff1); 

%Looking for the Low Frequency peak(center frequency) 
%in the Original Tachogram spectrum
[Mxprime,Ixprime]=max(LFspectrum.Original);
LFpeak.Original(UserIdx,VidIdx)=...
    f(Ixprime+LowCutOff1); 

%% RSA was estimated using the proposed method..

%Residual Tachogram
pxy=pxx-pyy;

%High frequency spectrum for Residual Tachogram
HFspectrum.Residual=pxy(HighCutoff1:HighCutoff2); 

%Low frequency spectrum for Residual Tachogram
LFspectrum.Residual=pxy(LowCutOff1:LowCutOff2); 

%High Frequency Power in the Residual Tachogram
HFpower.Residual(UserIdx,VidIdx)=...
    sum(pxy(HighCutoff1:HighCutoff2)); 

%Low Frequency Power in the Residual Tachogram
LFpower.Residual(UserIdx,VidIdx)=...
    sum(pxy(LowCutOff1:LowCutOff2)); 

Mx=[];Ix=[];
%Looking for the High Frequency peak(center frequency) 
%in the Residual Tachogram spectrum
[Mx,Ix]=max(HFspectrum.Residual);
HFpeak.Residual(UserIdx,VidIdx)=...
    f(Ix+HighCutoff1); 

Mxprime=[];Ixprime=[];
%Looking for the Low Frequency peak(center frequency) 
%in the Original Tachogram spectrum
[Mxprime,Ixprime]=max(LFspectrum.Residual);
LFpeak.Residual(UserIdx,VidIdx)=...
    f(Ixprime+LowCutOff1); 


%% Residual spectrum estimated using the respiratory belt data 
%%% using the LMS filter 

%Residual spectrum
pxz=pxx-pzz;

%High frequency spectrum for Residual Tachogram
HFspectrum.Respiratory=pxz(HighCutoff1:HighCutoff2); 

%Low frequency spectrum for Residual Tachogram
LFspectrum.Respiratory=pxz(LowCutOff1:LowCutOff2); 

%High Frequency Power in the Residual Tachogram
HFpower.Respiratory(UserIdx,VidIdx)=...
    sum(pxz(HighCutoff1:HighCutoff2)); 

%Low Frequency Power in the Residual Tachogram
LFpower.Respiratory(UserIdx,VidIdx)=...
    sum(pxz(LowCutOff1:LowCutOff2)); 

Mx=[];Ix=[];
%Looking for the High Frequency peak(center frequency) 
%in the Residual Tachogram spectrum
[Mx,Ix]=max(HFspectrum.Respiratory);
HFpeak.Respiratory(UserIdx,VidIdx)=f(Ix+HighCutoff1);

Mxprime=[];Ixprime=[];
%Looking for the Low Frequency peak(center frequency) 
%in the Original Tachogram spectrum
[Mxprime,Ixprime]=max(LFspectrum.Respiratory);
LFpeak.Respiratory(UserIdx,VidIdx)=f(Ixprime+LowCutOff1); 

%% Between the original spectrum and the residual spectrum 
% RSA was estimated using the proposed method
% knowledge based dictionary

% Distance between the center frequencies in the LF spectrum
% Distance between the original and the estimated spectrum..

Dist.Residual.LF(UserIdx,VidIdx)=...
    abs(LFpeak.Residual(UserIdx,VidIdx)-...
    LFpeak.Original(UserIdx,VidIdx))/SamplingFreqn;

meanDist.Residual.LF(UserIdx)=...
    mean(Dist.Residual.LF(UserIdx,VidIdx),2);


% Distance between the center frequencies in the HF spectrum
% Distance between the original and the estimated spectrum..

Dist.Residual.HF(UserIdx,VidIdx)=...
    abs(HFpeak.Residual(UserIdx,VidIdx)-...
    HFpeak.Original(UserIdx,VidIdx));

meanDist.Residual.HF(UserIdx)=...
    mean(Dist.Residual.HF(UserIdx,VidIdx),2);

%% Between the original spectrum and the residual spectrum
% RSA was estimated using LMS filtering 
% Reference signal was the respiratory belt data

% Distance between the center frequencies in the LF spectrum
% Distance between the original and the estimated spectrum..

Dist.Respiratory.LF(UserIdx,VidIdx)=...
    abs(LFpeak.Respiratory(UserIdx,VidIdx)-...
    LFpeak.Original(UserIdx,VidIdx));

meanDist.Respiratory.LF(UserIdx)=...
    mean(Dist.Respiratory.LF(UserIdx,VidIdx),2);

% Distance between the center frequencies in the HF spectrum
% Distance between the original and the estimated spectrum..

Dist.Respiratory.HF(UserIdx,VidIdx)=...
    abs(HFpeak.Respiratory(UserIdx,VidIdx)-...
    HFpeak.Original(UserIdx,VidIdx));

meanDist.Respiratory.HF(UserIdx)=...
    mean(Dist.Respiratory.HF(UserIdx,VidIdx),2);


% clearvars -except Dist NumVideos RR_series MeanDist RSAPower...
% PowerOriginal NumUsers UserIdx FreqPeakEstimated FreqPeakOriginal...
%  SamplingFreqn rsaUser TimeSig RSAestimate rsaSig respPower MeanDistPrime...
% FreqPeakEstimatedresp 

end
end

%% Calculating the mean scores %%%

%******************* LF peaks ******************%

%Across users%
%------------------------------------------%
CF.LF.Original.Users=...
    mean(mean(LFpeak.Original,2));
stdCF.LF.Original.Users=...
    std(mean(LFpeak.Original,2));
%------------------------------------------%
CF.LF.Residual.Users=...
    mean(mean(LFpeak.Residual,2));
stdCF.LF.Residual.Users=...
    std(mean(LFpeak.Residual,2));
%------------------------------------------%
CF.LF.Respiratory.Users=...
    mean(mean(LFpeak.Respiratory,2));
stdCF.LF.Respiratory.Users=...
    std(mean(LFpeak.Respiratory,2));
%------------------------------------------%

%Across videos%
%-------------------------------------------%
CF.LF.Original.Videos=...
    mean(mean(LFpeak.Original,1));
stdCF.LF.Original.Videos=...
    std(mean(LFpeak.Original,1));
%-------------------------------------------%
CF.LF.Residual.Videos=...
    mean(mean(LFpeak.Residual,1));
stdCF.LF.Residual.Videos=...
    std(mean(LFpeak.Residual,1));
%-------------------------------------------%
CF.LF.Respiratory.Videos=...
    mean(mean(LFpeak.Respiratory,1));
stdCF.LF.Respiratory.Videos=...
    std(mean(LFpeak.Respiratory,1));
%-------------------------------------------%


%******************* HF peaks ******************%

%Across users%
%------------------------------------------%
CF.HF.Original.Users=...
    mean(mean(HFpeak.Original,2));
stdCF.HF.Original.Users=...
    std(mean(HFpeak.Original,2));
%------------------------------------------%
CF.HF.Residual.Users=...
    mean(mean(HFpeak.Residual,2));
stdCF.HF.Residual.Users=...
    std(mean(HFpeak.Residual,2));
%------------------------------------------%
CF.HF.Respiratory.Users=...
    mean(mean(HFpeak.Respiratory,2));
stdCF.HF.Respiratory.Users=...
    std(mean(HFpeak.Respiratory,2));
%------------------------------------------%

%Across videos%
%------------------------------------------%
CF.HF.Original.Videos=...
    mean(mean(HFpeak.Original,1));
stdCF.HF.Original.Videos=...
    std(mean(HFpeak.Original,1));
%-------------------------------------------%
CF.HF.Residual.Videos=...
    mean(mean(HFpeak.Residual,1));
stdCF.HF.Residual.Videos=...
    std(mean(HFpeak.Residual,1));
%-------------------------------------------%
CF.HF.Respiratory.Videos=...
    mean(mean(HFpeak.Respiratory,1));
stdCF.HF.Respiratory.Videos=...
    std(mean(HFpeak.Respiratory,1));
%-------------------------------------------%

%##############################################################
%################### Power calculations #######################
%##############################################################

%%%%%%%%%%%%%% LF power calculations %%%%%%%%%%%%%%
% Average across all users and all videos %

Power.LF.Baseline = mean(mean(LFpower.Original));

stdPower.LF.Baseline=...
    std(mean(LFpower.Original));
%--------------------------------------------------%
Power.LF.Residual = mean(mean(LFpower.Residual));

stdPower.LF.Residual =...
    std(mean(LFpower.Residual));
%--------------------------------------------------%
Power.LF.Respiratory = mean(mean(LFpower.Respiratory));

stdPower.LF.Respiratory =...
    std(mean(LFpower.Respiratory));

%%%%%%%%%%%%%% HF power calculations %%%%%%%%%%%%%%
% average across all users and all videos %

Power.HF.Baseline = mean(mean(HFpower.Original));

stdPower.HF.Baseline=...
    std(mean(HFpower.Original));
%--------------------------------------------------%
Power.HF.Residual = mean(mean(HFpower.Residual));

stdPower.HF.Residual =...
    std(mean(HFpower.Residual));
%--------------------------------------------------%
Power.HF.Respiratory = mean(mean(HFpower.Respiratory));

stdPower.HF.Respiratory =...
    std(mean(HFpower.Respiratory));
%----------------------------------------------------%

%##############################################################
%################### Wilcoxon Signed Rank tests ###############
%##############################################################

%*********************For low power***************************%

OriginalPowerVect.LF = LFpower.Original(:);
RespiratoryPowerVect.LF = LFpower.Respiratory(:);
ResidualPowerVect.LF = LFpower.Residual(:);

%between original and respiratory data
pVal1=signrank(OriginalPowerVect.LF,RespiratoryPowerVect.LF);

%between original and rsa data
pVal2=signrank(OriginalPowerVect.LF,ResidualPowerVect.LF);

%*********************For high power***************************%

OriginalPowerVect.HF = HFpower.Original(:);
RespiratoryPowerVect.HF = HFpower.Respiratory(:);
ResidualPowerVect.HF = HFpower.Residual(:);

%between original and respiratory data
pValprime1=signrank(OriginalPowerVect.HF,RespiratoryPowerVect.HF);

%between original and rsa data
pValprime2=signrank(OriginalPowerVect.HF,ResidualPowerVect.HF);


%Average mean distance between the peaks HF component%

AvgDist.Respiratory=mean(meanDist.Respiratory.HF)

AvgDist.Residual=mean(meanDist.Residual.HF)

%Power deviance %

PowerDev.HF=...
    Power.HF.Baseline-Power.HF.Residual

PowerDev.LF=...
    Power.LF.Baseline-Power.LF.Residual

 %rowIdx=rowIdx+1;

%     end
%     
%  colIdx=colIdx+1;
%  
% end
% 
% [M,I]=max(PowerDev.HF(:));
% [I_row,I_col]=ind2sub(size(PowerDev.HF),I);
% 
% [Mprime,I]=min(PowerDev.LF(:));
% [I_rowPrime,I_colPrime]=ind2sub(size(PowerDev.LF),I);

