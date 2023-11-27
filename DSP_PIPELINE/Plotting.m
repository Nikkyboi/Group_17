

%Code for generating plots related to time signal.

%If the frequency given is nyquist, then we calculate the highest frequency
%and use that as our limit in the graph, if not, we just use the number
%given.
%Doing fft of filtered signal:
FFTFilteredSignal = fft(FilteredSignal);
FFTFilteredSignal = FFTFilteredSignal(1:end/2);

if xlimFrequencyEnd == 'nyquist'
    xlimFrequencyEnd = TargetSamplingFrequency/2;
else
    xlimFrequencyEnd = str2double(xlimFrequencyEnd);%Just the number given.
end

if XAxType=="lin"
    frequency_vec;
elseif XAxType=="log"
    frequency_vec = log10(frequency_vec(2:end));%(2:end) as the first frequency is 0, which gives inf.
    frequency_vec =  [0 frequency_vec]; %Putting 0 back.
    xlimFrequencyEnd = log10(xlimFrequencyEnd);
    if xlimFrequencyStart>0
        xlimFrequencyStart = log10(xlimFrequencyStart);
    else 
        xlimFrequencyStart=0;
    end
end

if YAxType == "lin"
    Mag_FFT_Sig = abs(Pos_FFT_Sig);
    Mag_FFTFilteredSignal = abs(FFTFilteredSignal);
elseif YAxType == "log"
    Mag_FFT_Sig  = log10(abs(Pos_FFT_Sig));
    Mag_FFTFilteredSignal = log10(abs(FFTFilteredSignal));
end

%Finder alle magnituder der er under 10^-10, og sætter dem lig nul, mht.
%fase og magnitude.
fase = angle(Pos_FFT_Sig);
IdxIrrelevant = find(10^-10>abs(Pos_FFT_Sig));
fase(IdxIrrelevant) = 0;
% Mag_FFT_Sig(IdxIrrelevant) = 0;
fase_Filtered = angle(FFTFilteredSignal);

% A plot to verify a successful resample, visually. 
if InputSignalType == "wav"
figure()
hold on;
plot(Tx,InputSignal,'r');
plot(NewTimeAxis,Signal,'b');
xlim([xTimelimStart xTimeLimEnd])
ylim([-ylimAmplityde ylimAmplityde])
xlabel('Time in (s)')
ylabel('Time in (Amplitude)')
legend('Orginal signal','Resampled Signal')
title('Plot of signal vs. Resampled Signal')
ax = gca; 
ax.FontSize = 13; 
saveas(gcf,'Resample plot.png')
end

figure()
hold on
plot(NewTimeAxis,Signal,'r')
plot(NewTimeAxis,FilteredSignal,'b')
xlim([xTimelimStart xTimeLimEnd])
ylim([-ylimAmplityde ylimAmplityde]) 
xlabel('Time in (s)')
ylabel('Time in (Amplitude)')
legend('Orginal signal','Filtered Signal')
title('Orginal signal vs. filteret signal')
ax = gca; 
ax.FontSize = 13; 
saveas(gcf,'TimeSignalPlot.png')

%Code for generation plots related to fourier spectrum.
figure()
tiledlayout('flow')
nexttile
hold on
plot(frequency_vec,Mag_FFT_Sig,'g')
xlabel(XAxType+'[Frequency (Hz)]')
ylabel(YAxType+'(Magnitude)')
xlim([xlimFrequencyStart xlimFrequencyEnd])
ylim([-ylimEnd ylimEnd]) 
title('Magnitude plot of Signal')
ax = gca; 
ax.FontSize = 13; 
hold off
nexttile
hold on
plot(frequency_vec,fase,'r');
xlabel(XAxType+'[Frequency (Hz)]')
ylabel('Phase (radians)')
xlim([xlimFrequencyStart xlimFrequencyEnd])
title('Phase plot of Signal')
ax = gca; 
ax.FontSize = 13; 
hold off
saveas(gcf,'FourierSpectrumPlot.png')


%Plotting imagniary part and real part of signal.
figure()
tiledlayout('flow')
nexttile
hold on
plot(frequency_vec,real(Pos_FFT_Sig),'g')
xlabel(XAxType+'[Frequency (Hz)]')
ylabel(YAxType+'Real part of signal')
xlim([xlimFrequencyStart xlimFrequencyEnd])
title('Real part of Signal')
ax = gca; 
ax.FontSize = 13; 
hold off
nexttile
hold on
plot(frequency_vec,imag(Pos_FFT_Sig),'r');
xlabel(XAxType+'[Frequency (Hz)]')
ylabel('Imagniary part of Signal')
xlim([xlimFrequencyStart xlimFrequencyEnd])
title('Imagniary part Signal')
ax = gca; 
ax.FontSize = 13; 
hold off
saveas(gcf,'ImagniaryRealPartSignal.png')

%Code for generateing plots related to filter.
figure()
hold on
zplane(Bn,An);
title('Pole-zero plot for filter, specified from global\_specs.txt')
saveas(gcf,'PoleZeroPlot.png')
figure()
hold on
freqz(Bn,An,10000,TargetSamplingFrequency)
title('Frequency response of filter, specified from global\_specs.txt')
saveas(gcf,'Frequency_response_of_filter.png')


% Code for generating plot for STFT.
figure();
hold on
imagesc(t, f, 20*log10(abs(s))); 
axis xy; 
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
axis tight
title('Spectrogram from STFT');
ax = gca; 
ax.FontSize = 13; 
hold off
saveas(gcf,'Spectrogram_STFT.png')



%Code for generating DFT of filtered signal with magnitude phase:
%Remove % to run.
% figure()
% tiledlayout('flow')
% nexttile
% hold on
% plot(frequency_vec,Mag_FFTFilteredSignal,'g')
% xlabel(XAxType+'[Frequency (Hz)]')
% ylabel(YAxType+'(Magnitude)')
% xlim([xlimFrequencyStart xlimFrequencyEnd])
% ylim([-ylimEnd ylimEnd]) 
% title('Magnitude plot of Filtered Signal')
% ax = gca; 
% ax.FontSize = 13; 
% hold off
% nexttile
% hold on
% plot(frequency_vec,fase_Filtered,'r');
% xlabel(XAxType+'[Frequency (Hz)]')
% ylabel('Phase (radians)')
% xlim([xlimFrequencyStart xlimFrequencyEnd])
% title('Phase plot of filtered Signal')
% ax = gca; 
% ax.FontSize = 13; 
% hold off
% 
% %Code for generating DFT real and imagniary parts.
% figure()
% tiledlayout('flow')
% nexttile
% hold on
% plot(frequency_vec,real(FFTFilteredSignal),'g')
% xlabel(XAxType+'[Frequency (Hz)]')
% ylabel(YAxType+'Real part of signal')
% xlim([xlimFrequencyStart xlimFrequencyEnd])
% title('Real part of filtered Signal')
% ax = gca; 
% ax.FontSize = 13; 
% hold off
% nexttile
% hold on
% plot(frequency_vec,imag(FFTFilteredSignal),'r');
% xlabel(XAxType+'[Frequency (Hz)]')
% ylabel('Imagniary part of Signal')
% xlim([xlimFrequencyStart xlimFrequencyEnd])
% title('Imagniary part filtered Signal')
% ax = gca; 
% ax.FontSize = 13; 
% hold off

