% This script takes care of the resample of the input signal interms of
% fixing it to the specified target sampling frequency. 

% we make a time vector of the input signal
Tx = 0:1/InputFs:length(InputSignal)/InputFs-1/InputFs;

% This part check for interpolation, If the signal frequency is not a derivative of
% the taget frequency, we will have interpolation.
if TargetSamplingFrequency < InputFs && mod(InputFs/TargetSamplingFrequency,1) ~= 0
    warning('Resample, Downsampling but with interpolation');
elseif TargetSamplingFrequency > InputFs && mod(TargetSamplingFrequency/InputFs,1) ~= 0
    warning('Resample, Upsampling but with interpolation');
end

% Then we resample the inputsignal to the target sampling frequency
[Signal, NewTimeAxis] = resample(InputSignal,Tx,TargetSamplingFrequency);

% Then we plot it, to verify a successful resample, visually. 
figure()
hold on;
plot(Tx,InputSignal,'r');
plot(NewTimeAxis,Signal,'b');
xlim([0.2 0.4]);