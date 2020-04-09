 function step_dict =createStepDictionary(TimeSig)
%     step_dict=[];
%     time=T/L:T/L:T;
%     unitStep=[];
%     colIdx=1;
%     for si=s
%         for t0i=t0
%             unitStep=shiftedUnitStep(time,t0i);
%             tmp=[];
%             for it=1:numel(time)
%             tmp(it)=1*unitStep(it);
%             end
%      tmp=tmp/norm(tmp,L);
%      step_dict(:,colIdx)=tmp';
%      colIdx=colIdx+1;
%        end
%    end
% end
t=1:1:length(TimeSig);
Amp=-2:0.5:2; % amplitude of the time signal. 
for i=1:length(TimeSig)
    t0=i;
    for a=1:length(Amp)
    tempstep(i,:)=t>=t0;
    unitstep(i,:)= Amp(a)*tempstep(i,:);
    end
end
step_dict=double(unitstep(:,:));
