

%Code for generating plots related to time signal.
if XAxType=="lin"
    TimeAxis;
elseif XAxType=="log"
    TimeAxis = log10(TimeAxis);
end

if YAxType == "lin"
    Signal;
    FilteredSignal;
elseif YAxType == "log"
    Signal = log10(Signal);
    FilteredSignal = log10(FilteredSignal);
end

figure()
hold on
plot(TimeAxis,Signal,'r')
plot(TimeAxis,FilteredSignal,'b')
xlim([0 xLimTime])
ylim([-ylimSig ylimSig]) 
xlabel('Time in '+XAxType+'(s)')
ylabel('Time in '+YAxType+'(Amplitude)')
legend('Orginal signal','Filtered Signal')
title('Orginal signal vs. filteret signal')
ax = gca; 
ax.FontSize = 13; 
%Code for generation plots related to fourier spectrum.

%Code for generateing plots related to filter.
figure()
hold on
zplane(Bn,An);
title('Pole-zero plot for filter, specified from global\_specs.txt')
figure()
hold on
freqz(Bn,An,10000,TargetSamplingFrequency)
title('Frequency response of filter, specified from global\_specs.txt')
