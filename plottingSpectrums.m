%##############################
%Plotting the spectrums
%##############################

function plottingSpectrums(rrIntervals,yfit,samplingFreqn)

% Normalized frequency bins
f=0:0.01:1; 

%calculating the spectrum of the fitted IBI time series:
pyy=pwelch(yfit,[],[],f,samplingFreqn);

%calculating the spectrum of the original IBI time series:
pxx=pwelch(rrIntervals,[],[],f,samplingFreqn);

%plotting the spectrums
figure;
plot(f,pyy,'*');
hold
plot(f,pxx,'--');
legend('Spectrum of the RSA component','Spectrum of the Original Tachogram');
xlim([0 0.6])
ylim([0, 1])
xlabel('Frequency in Hz');
ylabel('Power in S^2/Hz');

end