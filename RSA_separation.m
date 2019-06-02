clear all
close all
load('C:\Users\Abhishek Mukherjee\Desktop\Meditation.mat')
%x1=[Yoga_RR(:,2);Yoga_RR2_med(:,2);Yoga_RR3_med(:,2)];
x1=TaskRR_series;
%t=0:1:length(Yoga_RR(:,2))-1;
%x2=randn(length(Yoga_RR(:,2)),1);
%x2=(sin(t))';
%x1=(cos(t))';
%mixdata=x1+x2;
mixdata=x1;
mixdata = prewhitenAndCenter(mixdata);
q=3;
Mdl = rica(mixdata,q,'NonGaussianityIndicator',ones(q,1));
unmixed = transform(Mdl,mixdata);
figure;
plot(unmixed(:,1))
figure
plot(unmixed(:,2))
figure
plot(unmixed(:,3))
