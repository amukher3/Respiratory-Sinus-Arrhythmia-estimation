%%% Creating Feature Matrix for the Windows

function [PowerRatioMat,NPRmat,HFnuMat,LFnuMat,SDNNmat,AVNNmat,...
CVmat,SDSDmat,RMSSDDmat,SDRRmat,ArousalWinLabel,...
ValenceWinLabel]=...
CreatingFeatureMatrix(NumUsers,NumVideos,WindowDuration,...
OverlapDuration,SamplingFreqn,participantratings);


% For getting the Valence-Arousal class labels
% for every video and every user.
[ArousalLabels,ValenceLabels]= ExtractingRatings(participantratings);


for UserIdx=1:NumUsers
     
%String formatting for loading the data   
formatSpec = 'C:\\Users\\amukher3\\Downloads\\RR_series_user%d.mat';

Num=UserIdx; % user index

str=sprintf(formatSpec,Num);

load(str); %loading the data

NumVideos=length(RR_series); %Number of videos

for VidIdx=1:NumVideos
    
TimeSig=cell2mat(RR_series(VidIdx));

[temp]=...
MakingTimeWindows(TimeSig,WindowDuration,OverlapDuration,SamplingFreqn); 

% Rows of the cell correspond to the videos.
% Columns of the cell correspond to the users.
% elements within a cell are windows.

WindowedSignal{VidIdx,UserIdx}=temp;

tempVid=WindowedSignal{VidIdx,UserIdx};
NumWindows=size(tempVid,2); 

for WinIdx=1:NumWindows
    
CurWindow=tempVid(:,WinIdx);

%%% For freqn domain features..
[PowerRatio,NormalizedPowerRatio,HFnu,LFnu]=...
ExtractingFreqnDomainFeatures(CurWindow,SamplingFreqn);

%%% For time domain features ...
[SDNN,AVNN,CV,SDSD,RMSSDD,SDRR] = ...
ExtractingTimeDomainFeatures(CurWindow,SamplingFreqn);
 
%% For Orginal Tachogram  %%  

%%% Every column corresponds to a particular user...
%%% Every row corresponds to a video...

    % Matrix for Power Ratio
    PowerRatioMat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        PowerRatio.Original;
    
    % Matrix for NormalizedPowerRatio
    NPRmat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        NormalizedPowerRatio.Original;
    
    %Matrix for Normalized High Frequency Power
    HFnuMat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        HFnu.Original;
    
    %Matrix for Normalized Low Frequency Power
    LFnuMat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        LFnu.Original;
    
    %Matrix for Std. dev between NN intervals
    SDNNmat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        SDNN.Original;
    
    % Matrix for average value of a NN interval
    AVNNmat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        AVNN.Original;
    
    % Matrix for Coeff of variation
    CVmat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        CV.Original;
    
    %Matrix for SDSD
    SDSDmat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        SDSD.Original;
    
    % Matrix for Root mean square between 
    RMSSDDmat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        RMSSDD.Original;
    
    %Matrix for SDRR
    SDRRmat.Original{VidIdx,UserIdx}(1,WinIdx)=...
        SDRR.Original;
    
%% For Residual Tachogram %%

    %Matrix for Power Ratio
    PowerRatioMat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        PowerRatio.Residual;
    
    %Matrix for NormalizedPowerRatio
    NPRmat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        NormalizedPowerRatio.Residual;
    
    %Matrix for Normalized High Frequency Power
    HFnuMat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        HFnu.Residual;
    
    %Matrix for Normalized Low Frequency Power
    LFnuMat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        LFnu.Residual;
    
    %Matrix for Std. dev between NN intervals
    SDNNmat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        SDNN.Residual;
    
    % Matrix for average value of a NN interval
    AVNNmat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        AVNN.Residual;
    
    % Matrix for Coeff of variation
    CVmat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        CV.Residual;
    
    %Matrix for SDSD
    SDSDmat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        SDSD.Residual;
    
    %Matrix for Root mean square between 
    RMSSDDmat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        RMSSDD.Residual;
    
    %Matrix for SDRR
    SDRRmat.Residual{VidIdx,UserIdx}(1,WinIdx)=...
        SDRR.Residual; 
    
%%% Arousal and Valence labels for the Windows %%%

   % Arousal labels for the windows
   ArousalWinLabel{VidIdx,UserIdx}(1,WinIdx)=ArousalLabels(VidIdx,UserIdx);
   
   % Valence labels for the windows
   ValenceWinLabel{VidIdx,UserIdx}(1,WinIdx)=ValenceLabels(VidIdx,UserIdx);
 
end    

end
     
end
end