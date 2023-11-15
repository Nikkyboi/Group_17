
Tx = 0:1/InputFs:length(InputSignal)/InputFs-1/InputFs;
[y, ty] = resample(InputSignal,Tx,TargetSamplingFrequency);

figure()
hold on;
plot(Tx,InputSignal,'r');
plot(ty,y,'b');
xlim([0.2 0.4]);