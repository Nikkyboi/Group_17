

%Code for generating plots related to time signal.

%If the frequency given is nyquist, then we calculate the highest frequency
%and use that as our limit in the graph, if not, we just use the number
%given.
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
elseif YAxType == "log"
    Mag_FFT_Sig  = log10(abs(Pos_FFT_Sig));
end

%Finder alle magnituder der er under 10^-10, og sætter dem lig nul, mht.
%fase og magnitude.
fase = angle(Pos_FFT_Sig);
IdxIrrelevant = find(10^-10>abs(Pos_FFT_Sig));
fase(IdxIrrelevant) = 0;
% Mag_FFT_Sig(IdxIrrelevant) = 0;
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
save('TimeSignalPlot.mat', 'gcf', '-v7.3');

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
save('FourierSpectrumPlot.mat', 'gcf', '-v7.3');

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

%Code for generateing plots related to filter.
figure()
hold on
zplane(Bn,An);
title('Pole-zero plot for filter, specified from global\_specs.txt')
save('PoleZeroPlot.mat', 'gcf', '-v7.3');
figure()
hold on
freqz(Bn,An,10000,TargetSamplingFrequency)
title('Frequency response of filter, specified from global\_specs.txt')
save('MagnitudePhasePlot.mat', 'gcf', '-v7.3');

% Code for generating plot for Real Imaginary Part
figure()
hold on

save('RealImaginaryPlot.mat', 'gcf', '-v7.3');