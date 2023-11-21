




%Code for generateing plots related to filter.
figure()
hold on
zplane(Bn,An);
title('Pole-zero plot for filter, specified from global\_specs.txt')
figure()
hold on
freqz(Bn,An,10000,TargetSamplingFrequency)
title('Frequency response of filter, specified from global\_specs.txt')
