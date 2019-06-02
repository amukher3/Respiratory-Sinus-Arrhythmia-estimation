
function [PowerRatio,NormalizedPowerRatio,HFnu,LFnu,pxx,pyy,f,yfit]=...
    ExtractingFreqnDomainFeatures(CurWindow,SamplingFreqn);

%%% Extracting Features
 
%    %RR series training data
%    RRseriesPrime=cell2mat(RR_series(i));
     
%For the PSD's of the time signals
%pxx --- PSD of the original Tachogram
%pyy --- PSD of the estimated RSA
   
[pxx,pyy,f,yfit]=FindingSpectrum(CurWindow,SamplingFreqn);
   
%% From Original Tachogram 

%%% Low Frequency attributes %%%

   % Low frequency range: 0.05-0.25 hz
   LowFreqnCut1=0.05;
   LowFreqnCut2=0.15;
   
   % For Original Tachogram
   [~,LowCutoff1]=min(abs(f-LowFreqnCut1));
   [~,LowCutoff2]=min(abs(f-LowFreqnCut2));
   
   %Low frequency spectrum for Original Tachogram
   SpectrumLow.Original=pxx(LowCutoff1:LowCutoff2); 
   
   %Low Frequency Power in the Original Tachogram
   LowFreqPower.Original=sum(SpectrumLow.Original); 
   
%%% High frequency attributes %%%

   %High Frequency power in the Original Tachogram
   %High frequency range: 0.25-0.45hz
   
   HighFreqnCut1=0.20;
   HighFreqnCut2=0.50;
   
   % For Original Tachogram
   [~,HighCutoff1]=min(abs(f-HighFreqnCut1));
   [~,HighCutoff2]=min(abs(f-HighFreqnCut2));

   %High frequency spectrum for Original Tachogram
   SpectrumHigh.Original=pxx(HighCutoff1:HighCutoff2); 

   %High Frequency Power in the Original Tachogram
   HighFreqPower.Original=sum(SpectrumHigh.Original); 

   %Total Power
   TotalPower.Original=HighFreqPower.Original+...
       LowFreqPower.Original;
   
   %Power ratio
   PowerRatio.Original=LowFreqPower.Original/...
       HighFreqPower.Original;
   
   %NormalizedPowerRatio
   NormalizedPowerRatio.Original= PowerRatio.Original/...
       TotalPower.Original;
   
   %HighFrequencyNormalizedPowerRatio
   HFnu.Original = HighFreqPower.Original/...
       TotalPower.Original;
   
   %LowFrequencyNormalizedPowerRatio
   LFnu.Original = LowFreqPower.Original/...
       TotalPower.Original;
   
%% From Residual Tachogram 

%%%  Residual Spectrum
     pxy=(pxx-pyy); 
    % pxy(pxy<=0)=1e-8;  
   
%%% Low Frequency attributes %%%

   %Low frequency spectrum for Residual Tachogram
   SpectrumLow.Residual=pxy(LowCutoff1:LowCutoff2); 
   
   %Low Frequency Power in the Residual Tachogram
   LowFreqPower.Residual=sum(SpectrumLow.Residual); 
   
%%% High frequency attributes %%%

   %High frequency spectrum for Residual Tachogram
   SpectrumHigh.Residual=pxy(HighCutoff1:HighCutoff2); 

   %High Frequency Power in the Residual Tachogram
   HighFreqPower.Residual=sum(SpectrumHigh.Residual); 

   %Total Power
   TotalPower.Residual= HighFreqPower.Residual+...
       LowFreqPower.Residual;
   
   %Power ratio
   PowerRatio.Residual=...
       LowFreqPower.Residual/HighFreqPower.Residual;
   
   %NormalizedPowerRatio
   NormalizedPowerRatio.Residual= PowerRatio.Residual/...
       TotalPower.Residual;
   
   %HighFrequencyNormalizedPowerRatio
   HFnu.Residual = HighFreqPower.Residual/...
       TotalPower.Residual;
   
   %LowFrequencyNormalizedPowerRatio
   LFnu.Residual = LowFreqPower.Residual/...
       TotalPower.Residual;
   
   
   
 end
   
   
   
   
   
   
  
   
   
    
    
    
    
    
    
    
    
