%%% Leave one video out validation scheme %%% 

%%% TestMat--- Feature Matrix for the test data..
%%% TrainMat --- Feature Matrix for the Train data..
%%% TrainLabels --- Labels of the individual windows 


function [TestMat,TrainMat,TrainLabels,TrainRatings]=...
    LeaveOneVideoOut(NumVideos,NumUsers,NumWindows,NumPredictors,...
    VidLeaveIdx);

load('FeatureMatr');

%VidLeaveIdx=1;

%tempprary counter
tempCount=1;

for VidIdx=setdiff(1:NumVideos,VidLeaveIdx)
    
%#################### For Orginal Tachogram ###################

    VectNPR.LoV.Original=...
         NPRmat.Original(VidIdx,:);
     
     VectPowerRatio.LoV.Original=...
         PowerRatioMat.Original(VidIdx,:);
     
     VectHFnu.LoV.Original=...
         HFnuMat.Original(VidIdx,:);
     
     VectLFnu.LoV.Original=...
         LFnuMat.Original(VidIdx,:);
     
     VectSDNN.LoV.Original=...
         SDNNmat.Original(VidIdx,:);
     
     VectAVNN.LoV.Original=...
         AVNNmat.Original(VidIdx,:);
     
     VectCV.LoV.Original=...
         CVmat.Original(VidIdx,:);
     
     VectSDSD.LoV.Original=...
         SDSDmat.Original(VidIdx,:);
     
     VectRMSSDD.LoV.Original=...
         RMSSDDmat.Original(VidIdx,:);
     
     VectSDRR.LoV.Original=...
         SDRRmat.Original(VidIdx,:);
     
 %################# Feature Matrix #####################%

 FeatureMat.LoV.Original{tempCount}=...
 [VectNPR.LoV.Original',VectPowerRatio.LoV.Original',...
 VectHFnu.LoV.Original',VectLFnu.LoV.Original',...
 VectSDNN.LoV.Original',VectAVNN.LoV.Original',...
 VectCV.LoV.Original',VectSDSD.LoV.Original',...
 VectRMSSDD.LoV.Original',VectSDRR.LoV.Original'];
       
% %############## For Residual Tachogram ######################
 
   VectNPR.LoV.Residual=...
         NPRmat.Residual(VidIdx,:);
     
     VectPowerRatio.LoV.Residual=...
         PowerRatioMat.Residual(VidIdx,:);
     
     VectHFnu.LoV.Residual=...
         HFnuMat.Residual(VidIdx,:);
     
     VectLFnu.LoV.Residual=...
         LFnuMat.Residual(VidIdx,:);
     
     VectSDNN.LoV.Residual=...
         SDNNmat.Residual(VidIdx,:);
     
     VectAVNN.LoV.Residual=...
         AVNNmat.Residual(VidIdx,:);
     
     VectCV.LoV.Residual=...
         CVmat.Residual(VidIdx,:);
     
     VectSDSD.LoV.Residual=...
         SDSDmat.Residual(VidIdx,:);
     
     VectRMSSDD.LoV.Residual=...
         RMSSDDmat.Residual(VidIdx,:);
     
     VectSDRR.LoV.Residual=...
         SDRRmat.Residual(VidIdx,:);
     
 %%% Feature Matrix %%%

 FeatureMat.LoV.Residual{tempCount}=...
 [VectNPR.LoV.Residual',VectPowerRatio.LoV.Residual',...
 VectHFnu.LoV.Residual',VectLFnu.LoV.Residual',...
 VectSDNN.LoV.Residual',VectAVNN.LoV.Residual',...
 VectCV.LoV.Residual',VectSDSD.LoV.Residual',...
 VectRMSSDD.LoV.Residual',VectSDRR.LoV.Residual'];

 tempCount=tempCount+1;

    
end

%Number of videos left  
VideosLeft = size(FeatureMat.LoV.Original,2);
 
%Num of Predictors(Features)
NumPredictors= size(FeatureMat.LoV.Original{1,1},2);

%%%%%%%%%%% Index of the FeatureMatrix %%%%%%%%%%%%%%%%%%
%FeatureMat.LoV.Original{1,VidIdx}{UserIdx,PredIdx}(1,WinIdx)

%#################### Original Tachgram ########################

stPos=1;
enPosPrime=0;
tempMat=[];
tempPrimeMat=[];
tempDoublePrimeMat=[];
tempMat1=[];
tempMat2=[];

for VidIdx=1:VideosLeft
    
tempPrimeMat=FeatureMat.LoV.Original{1,VidIdx};

tempDoublePrimeMat=FeatureMat.LoV.Residual{1,VidIdx};

    
 for UserIdx=1:NumUsers
        
        for WinIdx=1:NumWindows
            
            for PredIdx=1:NumPredictors
                
              tempMat1(WinIdx,PredIdx)=...
              tempPrimeMat{UserIdx,PredIdx}(1,WinIdx);
           
              tempMat2(WinIdx,PredIdx)=...
              tempDoublePrimeMat{UserIdx,PredIdx}(1,WinIdx);
           
            end
            
        end
        
    enPos= size(tempMat1,1)*UserIdx + enPosPrime;
    
    TrainMat.LoV.Original(stPos:enPos,:)=tempMat1;
    
    TrainMat.LoV.Residual(stPos:enPos,:)=tempMat2;
    
    stPos = enPos+1;
 end
 
 enPosPrime=enPos;
    
end



%% 
%##########################################################################     
%########### PREPARING THE FEATURE MATRIX FOR THE LEFT OUT USER ###########
%##########################################################################
 
 
 
 %######################## FOR ORIGINAL TACHOGRAM ########################
 
     
     testNPR.LoV.Original=...
         NPRmat.Original(VidLeaveIdx,:);
     
     testPowerRatio.LoV.Original=...
         PowerRatioMat.Original(VidLeaveIdx,:);
     
     testHFnu.LoV.Original=...
         HFnuMat.Original(VidLeaveIdx,:);
     
     testLFnu.LoV.Original=...
         LFnuMat.Original(VidLeaveIdx,:);
     
     testSDNN.LoV.Original=...
         SDNNmat.Original(VidLeaveIdx,:);
     
     testAVNN.LoV.Original=...
         AVNNmat.Original(VidLeaveIdx,:);
     
     testCV.LoV.Original=...
         CVmat.Original(VidLeaveIdx,:);
     
     testSDSD.LoV.Original=...
         SDSDmat.Original(VidLeaveIdx,:);
     
     testRMSSDD.LoV.Original=...
         RMSSDDmat.Original(VidLeaveIdx,:);
     
     testSDRR.LoV.Original=...
         SDRRmat.Original(VidLeaveIdx,:);
     

  testFeatureMat.LoV.Original=...
     [testNPR.LoV.Original',testPowerRatio.LoV.Original',...
     testHFnu.LoV.Original',testLFnu.LoV.Original',...
     testSDNN.LoV.Original',testAVNN.LoV.Original',...
     testCV.LoV.Original',testSDSD.LoV.Original',...
     testRMSSDD.LoV.Original',testSDRR.LoV.Original'];
 
 
 %######################## FOR RESIDUAL TACHOGRAM ########################
 
     testNPR.LoV.Residual=...
         NPRmat.Residual(VidLeaveIdx,:);
     
     testPowerRatio.LoV.Residual=...
         PowerRatioMat.Residual(VidLeaveIdx,:);
     
     testHFnu.LoV.Residual=...
         HFnuMat.Residual(VidLeaveIdx,:);
     
     testLFnu.LoV.Residual=...
         LFnuMat.Residual(VidLeaveIdx,:);
     
     testSDNN.LoV.Residual=...
         SDNNmat.Residual(VidLeaveIdx,:);
     
     testAVNN.LoV.Residual=...
         AVNNmat.Residual(VidLeaveIdx,:);
     
     testCV.LoV.Residual=...
         CVmat.Residual(VidLeaveIdx,:);
     
     testSDSD.LoV.Residual=...
         SDSDmat.Residual(VidLeaveIdx,:);
     
     testRMSSDD.LoV.Residual=...
         RMSSDDmat.Residual(VidLeaveIdx,:);
     
     testSDRR.LoV.Residual=...
         SDRRmat.Residual(VidLeaveIdx,:);
     
     testFeatureMat.LoV.Residual=...
     [testNPR.LoV.Residual',testPowerRatio.LoV.Residual',...
     testHFnu.LoV.Residual',testLFnu.LoV.Residual',...
     testSDNN.LoV.Residual',testAVNN.LoV.Residual',...
     testCV.LoV.Residual',testSDSD.LoV.Residual',...
     testRMSSDD.LoV.Residual',testSDRR.LoV.Residual'];
     

 
  %%%%%%%%%%%%%%%%%%%%%% In Matrix form %%%%%%%%%%%%%%%%%%%%%%%%%
  
    stPos=1; 
    tempMat=[];
    tempPrimeMat=[];
    
    for UserIdx=1:NumUsers
        
        for WinIdx=1:NumWindows
            
             for PredIdx=1:NumPredictors
                 
             tempMat(WinIdx,PredIdx)=...
             testFeatureMat.LoV.Original{UserIdx,PredIdx}(1,WinIdx);
         
             tempPrimeMat(WinIdx,PredIdx)=...
             testFeatureMat.LoV.Residual{UserIdx,PredIdx}(1,WinIdx);
         
             end
             
        end
        
        
       enPos= size(tempMat,1)*UserIdx;
        
       TestMat.LoV.Original(stPos:enPos,:)=...
            tempMat;
        
       TestMat.LoV.Residual(stPos:enPos,:)=...
            tempPrimeMat;
        
       stPos=enPos+1;
        
    end
    
%#######################################################################
%################# PREPARING THE LABELS FOR TRAINING #################
%#######################################################################

tempCount=1;

for VidIdx=setdiff(1:NumVideos,VidLeaveIdx)
        
        for UserIdx=1:NumUsers
            
             for WinIdx=1:NumWindows
                 
%--------------------- Labels for training ------------------------%

             % Arousal
             TrainLabels.LoV.Arousal(tempCount,1)=...
             ArousalWinLabel{VidIdx,UserIdx}(1,WinIdx);
         
             % Valence        
             TrainLabels.LoV.Valence(tempCount,1)=...
             ValenceWinLabel{VidIdx,UserIdx}(1,WinIdx);
         
%------------------ Ratings for Traning ---------------------------%
              
             % Arousal
             TrainRatings.LoV.Arousal(tempCount,1)=...
             ArousalWinRatings{VidIdx,UserIdx}(1,WinIdx);
         
             % Valence         
             TrainRatings.LoV.Valence(tempCount,1)=...
             ValenceWinRatings{VidIdx,UserIdx}(1,WinIdx);
         
%-----------------------------------------------------------------%
         
             tempCount=tempCount+1;
             
            end
             
        end
        
        
end

end
  