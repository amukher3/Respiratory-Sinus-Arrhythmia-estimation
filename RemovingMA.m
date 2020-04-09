function [InterIBI,ResamFreqn]= RemovingMA(BVP,ACC)
[BVPWindow,ACCWindow,SamplingFreqn] = MakingTimeWindows(BVP,ACC); 
mu = 0.1; %step size

% defining the filter characteristics
lms = dsp.LMSFilter(70,'StepSize',mu,'Method',...
'Normalized LMS','WeightsOutputPort',true); 

% bandpass range
fpass=[0.3,4]; 

%Num of BVP windows
NumWindows=size(BVPWindow,2); 

for iPrime=1:NumWindows
    
% BVP signal is used as the reference signal d(n)
    dTemp(:,iPrime)=BVPWindow(:,iPrime); 
    
% ACC signal is used as the input 
    x(:,iPrime)=ACCWindow(:,iPrime); 
    
% performing Bandpass filtering
    d(:,iPrime)=bandpass(dTemp(:,iPrime),fpass,SamplingFreqn,...
       'ImpulseResponse','iir');
   
% performing LMS filtering   
   [y(:,iPrime),e(:,iPrime),w(:,iPrime)]=lms(x(:,iPrime),d(:,iPrime));
   
% The error signal e(n) is the MA free PPG(BVP) signal according to 
% Fallet et al. 
 Window(:,iPrime)=e(:,iPrime);
 
% Locating the Peaks in the PPG signal
% 25 samples choosen as the minimum peak distance
% keeping in mind a sampling Frequency of 64Hz.
[~,Idx]=findpeaks(Window(:,iPrime),'MinPeakdistance',25);

% difference in between the peaks of the PPG 
   for i=1:length(Idx)-1
   diff(i)=Idx(i+1)-Idx(i);
   end
   IBIinterval{iPrime}=diff./SamplingFreqn;
   
% Average IBI for every window    
AvgIBIinterval(iPrime)=mean(IBIinterval{iPrime});
   
   %ans=interp(AvgIBIinterval,round(length(BVP)/length(AvgIBIinterval)));
   %pspectrum(ans,SamplingFreqn,'FrequencyResolution',0.1,'FrequencyLimits',[0,1]);

%    hold
%    GroundIBI=interp(IBI(:,2),round(length(AvgIBIinterval)...
%    /length(IBI(:,2)))); 
%    plot(GroundIBI)
   %clear diff;
end 
   tempFact=round(length(BVP)/length(AvgIBIinterval));
   
%Sampling frequency of the Average IBI intervals.
AvgSamFreqn=SamplingFreqn/tempFact; 

%Resampling the RR intervals to 2 Hz 
ResamFreqn=2; 

%The factor by which the AvgIBIinterval needs to be resampled   
ResamplingFact=ResamFreqn/AvgSamFreqn; 

 if(ResamplingFact>1)
   InterIBI=interp(AvgIBIinterval,ResamplingFact);
   else
     InterIBI=downsample(AvgIBIinterval,ResamplingFact);
 end
  %  plot(InterIBI);
end
%    figure;
%    pspectrum(AvgIBIinterval,ResamFreqn,'FrequencyResolution',0.01,'FrequencyLimits',[0,1]);
%    xlim([0.15 1])