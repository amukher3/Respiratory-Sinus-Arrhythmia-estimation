%%% Regression model for Leave one user %%%

NumVideos=40;
NumUsers=32;
NumWindows=5;
NumPredictors=10;

%Extracting the ratings 
[ArousalMat,ValenceMat,ArousalRatings,ValenceRatings]= ...
    ExtractingRatings(participantratings);

for UserLeaveIdx=1:NumUsers
    
 [TestMat,TrainMat,TrainLabels,TrainRatings]=...
 LeaveOneVideoOut(NumVideos,NumUsers,NumWindows,NumPredictors,...
  UserLeaveIdx);

%#####################################################
%############### Original Tachoram ###################
%#####################################################

%Arousal rating for the left out video
TestRatings.LoU.Arousal=...
    ArousalRatings(:,UserLeaveIdx);

% Table for the Training matrix %
DesignMat.LoU.Original=...
    TrainMat.LoU.Original;

% ResponseVariable(Arousal)%
RespVar.LoU.Original=...
    TrainRatings.LoU.Arousal

% Building the Linear model %
mdl = LinearModel.fit(DesignMat.LoU.Original,RespVar.LoU.Original);

%Testing Matrix
TestMatrix.LoU.Original=TestMat.LoU.Original;

%Predicting the model
yPred.LoU.Original.Arousal =...
    predict(mdl,TestMatrix.LoU.Original);

%%% Putting the labels in Matrix form %%%
stPos=1;
for VidIdx=1:NumVideos
     
    enPos=VidIdx*NumWindows;
    
    MeanScore.LoV.Original.Arousal(1,VidIdx)=...
    mean(yPred.LoV.Original.Arousal(stPos:enPos));

    stPos=enPos+1;
    
end

RMSE.LoV.Original(UserLeaveIdx)=...
    sqrt(mean((TestRatings.LoV.Arousal - ...
    MeanScore.LoV.Original.Arousal).^2));


    
end
