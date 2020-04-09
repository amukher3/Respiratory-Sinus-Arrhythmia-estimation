close all
clear all
load('C:\Users\Abhishek Mukherjee\Downloads\s01');

%Extracting the data
 dataPrime=data(:,39,:);
 respData(:,:)=dataPrime;
 for i=1:size(respData,1)
    Data.Resp(i,:)= respData(i,:);
    [~,Idx{i}]=findpeaks(Data.Resp(i,:),'MinPeakDistance',100)
 end
 % Creating the TimeDiff Series
 
 for j=1:size(Idx,2)
 temp=Idx{j};
 for i=1:length(temp)-1
     diffTemp(i)=temp(i+1)-temp(i); % samples difference between peaks
 end
 diffVect{j}=diffTemp;
 Fs=128; % Sampling frequency for the PPG signal
 IntrpFact=round(length(Data.Resp(1,:))/length(diffTemp)); %InterpolatingFactor
 RR_series{j} = interp(diffTemp/Fs,IntrpFact);
 clear temp diffTemp;
 end
 UserSeries=[RR_series{1:length(RR_series)/10}];
 %plot([RR_series{:}])
 