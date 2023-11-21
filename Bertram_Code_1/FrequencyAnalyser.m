%   Important notes:
%   To do windowing in time domain we do multiplication:   S[n]*W[n]
%   To do windowing in frequency domain we do convolution: conv(S[n],W[n])
   
%%  DFT below uses the entire signal

%   Window Size:
    t = 0:1/TargetSamplingFrequency:TotalDuration
    N = length(t);
    
%   Ved ikke hvordan jeg sætter denne parameter:
    N1 = TargetSamplingFrequency/SpectralRes;

%   Assuming time domain:
if WindowType == "hann";
    fprintf('FilterType is IIR \n');
    %hann_window = hann(SamplingFrequency);
    W = hann(N);
    s = "Hann"

elseif WindowType == "hamming";
    fprintf('WindowType is hamming \n');
    %hamming_window = hamming(SamplingFrequency);
    W = hamming(N);
    s = "Hamming"

elseif WindowType == "rect";
    fprintf('WindowType is rect \n');
    %rectangular_window = rectwin(SamplingFrequency);
    W = rectwin(N);
    s = "Rectangular"
end

% If signal size does not match then create new array
time_difference = length(InputSignal) - N;
if time_difference > 0

    New_signal = zeros(1, N);
    for i = 1:N-1
        New_signal(i) = InputSignal(i);
    end
    Windowed_Signal = New_signal.*W';
else
    Windowed_Signal = s0.*W';
end

wLine = 1;
figure(1)
subplot(3, 1, 1);
plot(InputSignal)
title("Original Signal");
xlabel('Sampels');
subplot(3, 1, 2);
plot(t, W, 'k', 'LineWidth', wLine);
legend(s);
xlabel('time (s)');
title("Window ", s);
subplot(3, 1, 3);
plot(t, Windowed_Signal)
title("Windowed Signal");
xlabel('time (s)');

% Compute and plot frequency domain spectrums
xx = abs(fft(W, N1))/max(abs(fft(W, N1)));
Ws = fftshift(20*log10(xx));

% Plot frequency domain spectrum for Window
figure(2)
subplot(2, 1, 1);
frequencies = linspace(-TargetSamplingFrequency/2, TargetSamplingFrequency/2, N1);
plot(frequencies, Ws, 'k', 'LineWidth', wLine);
title('Window Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% Repeat the process for the Windowed_signal
yy = abs(fft(Windowed_Signal, N1))/max(abs(fft(Windowed_Signal, N1)));
Windowed_Signal_FQ = fftshift(20*log10(yy));

subplot(2, 1, 2);
plot(frequencies, Windowed_Signal_FQ, 'k', 'LineWidth', wLine);
title('Windowed Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% STFT analysis where we split the signal up into chunks
    %   Overlap:
    Overlap_perc = Overlap/100;

%   Hopsize:
    hop_size = round((N)*Overlap_perc);

    figure(3)
    stft(InputSignal, TargetSamplingFrequency, Window= W, OverlapLength=hop_size, FFTLength=N)
    %InputSignal


