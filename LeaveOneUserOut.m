
 
%%% Every column corresponds to a particular user...
%%% Every row corresponds to a video...
%%% LoU ----- Leave one User
%%% LoV ------ Leave one Video
%%% UserLeaveIdx --- The user index to be left out
%%% VidLeaveIdx --- The videoindex to be left out.

%%% Every cell of the matrix corresponds to the...
%%% feature matrix for a particular user/video index left ...
%%% out

%%% This function generates the Trainng matrix for
%%% the leave one out scheme..
%%% ---- TrainMat is the final matrix ----

% [PowerRatioMat,NPRmat,HFnuMat,LFnuMat,SDNNmat,AVNNmat,...
%  CVmat,SDSDmat,RMSSDDmat,SDRRmat,ArousalWinLabel,...
%  ValenceWinLabel,NumWindows]=...
%  CreatingFeatureMatrix(NumUsers,NumVideos,WindowDuration,...
%  OverlapDuration,SamplingFreqn,participantratings);



function [TrainLabels,TestLabels,TrainMat,TestMat,NumWindows]=...
ModelForLeaveOneOut(UserLeaveIdx,NumUsers,NumVideos,...
WindowDuration,OverlapDuration,...
SamplingFreqn,participantratings,PowerRatioMat,NPRmat,...
HFnuMat,LFnuMat,SDNNmat,AVNNmat,CVmat,...
SDSDmat,RMSSDDmat,SDRRmat,ArousalWinLabel,...
ValenceWinLabel,NumWindows);


%% Leave one Subject Out Validation %%

% 
% NumVideos=40;
% NumUsers=32;
% NumWindows=11;
% NumPredictors=10;
% UserLeaveIdx=1;

[ArousalMat,ValenceMat,ArousalRatings,ValenceRatings]= ...
ExtractingRatings(participantratings);

tempCount=1;

 for UserIdx=setdiff(1:NumUsers,UserLeaveIdx)
     
 %%For original Tachogram%%
     
     VectNPR.LoU.Original=...
         NPRmat.Original(:,UserIdx);
     
     VectPowerRatio.LoU.Original=...
         PowerRatioMat.Original(:,UserIdx);
     
     VectHFnu.LoU.Original=...
         HFnuMat.Original(:,UserIdx);
     
     VectLFnu.LoU.Original=...
         LFnuMat.Original(:,UserIdx);
     
     VectSDNN.LoU.Original=...
         SDNNmat.Original(:,UserIdx);
     
     VectAVNN.LoU.Original=...
         AVNNmat.Original(:,UserIdx);
     
     VectCV.LoU.Original=...
         CVmat.Original(:,UserIdx);
     
     VectSDSD.LoU.Original=...
         SDSDmat.Original(:,UserIdx);
     
     VectRMSSDD.LoU.Original=...
         RMSSDDmat.Original(:,UserIdx);
     
     VectSDRR.LoU.Original=...
         SDRRmat.Original(:,UserIdx);
     
%%% FeatureMatrix for the Original Tachogram %%%
     
     FeatureMat.LoU.Original{tempCount}=...
     [VectNPR.LoU.Original,VectPowerRatio.LoU.Original,...
     VectHFnu.LoU.Original,VectLFnu.LoU.Original,...
     VectSDNN.LoU.Original,VectAVNN.LoU.Original,VectCV.LoU.Original,...
     VectSDSD.LoU.Original,VectRMSSDD.LoU.Original,VectSDRR.LoU.Original];
       
%%%----------------- For Residual Tachogram ----------------------------%%%
     
     VectNPR.LoU.Residual=...
         NPRmat.Residual(:,UserIdx);
     
     VectPowerRatio.LoU.Residual=...
         PowerRatioMat.Residual(:,UserIdx);
     
     VectHFnu.LoU.Residual=...
         HFnuMat.Residual(:,UserIdx);
     
     VectLFnu.LoU.Residual=...
         LFnuMat.Residual(:,UserIdx);
     
     VectSDNN.LoU.Residual=...
         SDNNmat.Residual(:,UserIdx);
     
     VectAVNN.LoU.Residual=...
         AVNNmat.Residual(:,UserIdx);
     
     VectCV.LoU.Residual=...
         CVmat.Residual(:,UserIdx);
     
     VectSDSD.LoU.Residual=...
         SDSDmat.Residual(:,UserIdx);
     
     VectRMSSDD.LoU.Residual=...
         RMSSDDmat.Residual(:,UserIdx);
     
     VectSDRR.LoU.Residual=...
         SDRRmat.Residual(:,UserIdx);
     
     
     %%% FeatureMatrix for the Residual Tachogram %%%
     
     FeatureMat.LoU.Residual{tempCount}=...
        [VectNPR.LoU.Residual,VectPowerRatio.LoU.Residual,...
        VectHFnu.LoU.Residual,VectLFnu.LoU.Residual,...
        VectSDNN.LoU.Residual,VectAVNN.LoU.Residual,VectCV.LoU.Residual,...
        VectSDSD.LoU.Residual,VectRMSSDD.LoU.Residual,VectSDRR.LoU.Residual];

tempCount=tempCount+1;

 end
 
 
 
%Number of left users 
UsersLeft=size(FeatureMat.LoU.Original,2);
 
%Num of Predictors(Features)
NumPredictors= size(FeatureMat.LoU.Original{1,1},2);

%####################################################################
%###################### Original Tachogram ########################## 
%####################################################################

stPos=1;
enPosPrime=0;
tempMat1=[];
tempPrimeMat=[];
tempDoublePrimeMat=[];


for UserIdx=1:UsersLeft
    
 tempPrimeMat=...
     FeatureMat.LoU.Original{1,UserIdx};
 
 tempDoublePrimeMat=...
     FeatureMat.LoU.Residual{1,UserIdx};
   
  for VidIdx=1:NumVideos
        
         for WinIdx=1:NumWindows
            
               for PredIdx=1:NumPredictors
                 
              tempMat1(WinIdx,PredIdx)=...
              tempPrimeMat{VidIdx,PredIdx}(1,WinIdx);
          
          tempMat2(WinIdx,PredIdx)=...
              tempDoublePrimeMat{VidIdx,PredIdx}(1,WinIdx);
         
               end
             
         end
        
    enPos= size(tempMat1,1)*VidIdx + enPosPrime;
    
    TrainMat.Original(stPos:enPos,:)=tempMat1;
    
    stPos = enPos+1;
        
  end

  enPosPrime=enPos;
  
end

 
%####################################################################
%###################### Residual Tachogram ########################## 
%####################################################################

stPos=1;
enPosPrime=0;
tempMat1=[];
tempPrimeMat=[];

for UserIdx=1:UsersLeft
    
 tempPrimeMat=FeatureMat.LoU.Residual{1,UserIdx};
   
  for VidIdx=1:NumVideos
        
         for WinIdx=1:NumWindows
            
               for PredIdx=1:NumPredictors
                 
              tempMat1(WinIdx,PredIdx)=...
              tempPrimeMat{VidIdx,PredIdx}(1,WinIdx);
         
               end
             
         end
        
    enPos= size(tempMat1,1)*VidIdx + enPosPrime;
    
    TrainMat.Residual(stPos:enPos,:)=tempMat1;
    
    stPos = enPos+1;
        
  end

  enPosPrime=enPos;
  
end

%#######################################################################
%################### PREPARING THE LABELS FOR TRAINING #################
%#######################################################################

tempCount=1;

for UserIdx=1:UsersLeft
        
        for VidIdx=1:NumVideos
            
             for WinIdx=1:NumWindows
                 
             TrainLabels.Arousal(tempCount,1)=...
             ArousalWinLabel{VidIdx,UserIdx}(1,WinIdx);
         
             TrainLabels.Valence(tempCount,1)=...
             ValenceWinLabel{VidIdx,UserIdx}(1,WinIdx);
         
             tempCount=tempCount+1;
             
             end
             
        end
        
        
end
 
 %%
%##########################################################################     
%########### PREPARING THE FEATURE MATRIX FOR THE LEFT OUT USER ###########
%##########################################################################
 
 
 
 %######################## FOR ORIGINAL TACHOGRAM ########################
 
     
     testNPR.LoU.Original=...
         NPRmat.Original(:,UserLeaveIdx);
     
     testPowerRatio.LoU.Original=...
         PowerRatioMat.Original(:,UserLeaveIdx);
     
     testHFnu.LoU.Original=...
         HFnuMat.Original(:,UserLeaveIdx);
     
     testLFnu.LoU.Original=...
         LFnuMat.Original(:,UserLeaveIdx);
     
     testSDNN.LoU.Original=...
         SDNNmat.Original(:,UserLeaveIdx);
     
     testAVNN.LoU.Original=...
         AVNNmat.Original(:,UserLeaveIdx);
     
     testCV.LoU.Original=...
         CVmat.Original(:,UserLeaveIdx);
     
     testSDSD.LoU.Original=...
         SDSDmat.Original(:,UserLeaveIdx);
     
     testRMSSDD.LoU.Original=...
         RMSSDDmat.Original(:,UserLeaveIdx);
     
     testSDRR.LoU.Original=...
         SDRRmat.Original(:,UserLeaveIdx);
     

     
     testFeatureMat.LoU.Original=...
     [testNPR.LoU.Original,testPowerRatio.LoU.Original,...
     testHFnu.LoU.Original,testLFnu.LoU.Original,...
     testSDNN.LoU.Original,testAVNN.LoU.Original,testCV.LoU.Original,...
     testSDSD.LoU.Original,testRMSSDD.LoU.Original,testSDRR.LoU.Original];
 
  %%% In Matrix form %%%
  
    stPos=1; 
    tempMat1=[];
    
    tempLabelsArousal= ArousalWinLabel(:,UserLeaveIdx);
    tempLabelsValence = ValenceWinLabel(:,UserLeaveIdx);
    
    for VidIdx=1:NumVideos
        
        for WinIdx=1:NumWindows
            
             for PredIdx=1:NumPredictors
                 
             tempMat1(WinIdx,PredIdx)=...
             testFeatureMat.LoU.Original{VidIdx,PredIdx}(1,WinIdx);
         
             end
             
        end
        
        % Feature Matrix for Test 
        % Original Tachogram
        
        enPos= size(tempMat1,1)*VidIdx;
        TestMat.Original(stPos:enPos,:)=tempMat1;
        stPos=enPos+1;
        
    end
  
%######################## FOR RESIDUAL TACHOGRAM ########################
 
     testNPR.LoU.Residual=...
         NPRmat.Residual(:,UserLeaveIdx);
     
     testPowerRatio.LoU.Residual=...
         PowerRatioMat.Residual(:,UserLeaveIdx);
     
     testHFnu.LoU.Residual=...
         HFnuMat.Residual(:,UserLeaveIdx);
     
     testLFnu.LoU.Residual=...
         LFnuMat.Residual(:,UserLeaveIdx);
     
     testSDNN.LoU.Residual=...
         SDNNmat.Residual(:,UserLeaveIdx);
     
     testAVNN.LoU.Residual=...
         AVNNmat.Residual(:,UserLeaveIdx);
     
     testCV.LoU.Residual=...
         CVmat.Residual(:,UserLeaveIdx);
     
     testSDSD.LoU.Residual=...
         SDSDmat.Residual(:,UserLeaveIdx);
     
     testRMSSDD.LoU.Residual=...
         RMSSDDmat.Residual(:,UserLeaveIdx);
     
     testSDRR.LoU.Residual=...
         SDRRmat.Residual(:,UserLeaveIdx);
     

     
     testFeatureMat.LoU.Residual=...
     [testNPR.LoU.Residual,testPowerRatio.LoU.Residual,...
     testHFnu.LoU.Residual,testLFnu.LoU.Residual,...
     testSDNN.LoU.Residual,testAVNN.LoU.Residual,testCV.LoU.Residual,...
     testSDSD.LoU.Residual,testRMSSDD.LoU.Residual,testSDRR.LoU.Residual];
 

 %%% In Matrix form %%%

 stPos=1; 
 tempMat1=[];
    
    for VidIdx=1:NumVideos
        
        for WinIdx=1:NumWindows
            
             for PredIdx=1:NumPredictors
                 
             tempMat1(WinIdx,PredIdx)=...
             testFeatureMat.LoU.Residual{VidIdx,PredIdx}(1,WinIdx);
         
             end
             
        end
        
      enPos= size(tempMat1,1)*VidIdx;
        
     % Feature Matrix for test 
     % Residual Tachogram
     TestMat.Residual(stPos:enPos,:)=...
            tempMat1;
        
        stPos=enPos+1;
        
    end
    
 %######################################################################   
 %######### PREPARING THE LABELS FOR THE LEFT OUT USER #################
 %######################################################################
    
    
 tempCount=1;
 for VidIdx=1:NumVideos
            
             for WinIdx=1:NumWindows
                 
             TestLabels.Arousal(tempCount,1)=...
             ArousalWinLabel{VidIdx,UserLeaveIdx}(1,WinIdx);
         
             TestLabels.Valence(tempCount,1)=...
             ValenceWinLabel{VidIdx,UserLeaveIdx}(1,WinIdx);
         
             tempCount=tempCount+1;
             
             end
             
             
 end
        
end   

  
 