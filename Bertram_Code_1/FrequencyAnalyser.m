%   Important notes:
%   To do windowing in time domain we do multiplication:   S[n]*W[n]
%   To do windowing in frequency domain we do convolution: conv(S[n],W[n])
%%  DFT below uses the entire signal
    
%   FFT of the whole signal
    freq = fft(y)
    n = length(freq)

    %T = length(y)/TargetSamplingFrequency
    %delta = 1/T
    %frequency_axis = 0:delta:TargetSamplingFrequency/2
    frequencies = TargetSamplingFrequency*(0:(n/2))/n;
   
    positive_frequencies = frequencies(1:end/2+1);

    %f = abs(fft(y))/n;
    subplot(2,1,1)
    plot(positive_frequencies)
    subplot(2,1,2)
    plot(freq)
    %frequency_axis = linspace(0, TargetSamplingFrequency/2, length(signal_F))
    %plot(frequency_axis, signal_F)
    %%
%   Window Size:
    t = 0:1/TargetSamplingFrequency:(TotalDuration - 1/TargetSamplingFrequency)
    N = length(t);
    
%   Ved ikke hvordan jeg sætter denne parameter:
%    N1 = TargetSamplingFrequency/SpectralRes;

%   Assuming time domain:
if WindowType == "hann";
    fprintf('FilterType is hann \n');
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
time_difference = length(y) - N;
if time_difference > 0
    New_signal = zeros(1, N);
    for i = 1:N-1
        New_signal(i) = y(i);
    end
    Windowed_Signal = New_signal.*W';
elseif time_difference == 0
    Windowed_Signal = New_signal.*W';
else
    warning('The window is longer than the actual signal')
    %Windowed_Signal = y'.*W;
end

wLine = 1;
figure(1)
subplot(3, 1, 1);
plot(ty, y)
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
xx = abs(fft(Windowed_Signal))/max(abs(fft(Windowed_Signal)));
Windowed_Signal_FQ = fftshift(20*log10(xx));

% Plot frequency domain spectrum for Window
figure(2)
subplot(2, 1, 1);

% Frequency spectrum
frequencies_spec = linspace(-TargetSamplingFrequency/2, TargetSamplingFrequency/2, length(xx));

% Frequency vector
frequeny_vec = linspace(0, TargetSamplingFrequency/2, length(xx))


subplot(2, 1, 1);
plot(frequencies_spec, Windowed_Signal_FQ, 'k', 'LineWidth', wLine);
title('Windowed Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% STFT analysis where we split the signal up into chunks
%   Overlap: 
    
    Overlap_perc = Overlap/100;

%   Hopsize:
    hop_size = round((N)*Overlap_perc);

%   Length of signal
    sig_len = length(y);


    subplot(2, 1, 2);
    stft(y, TargetSamplingFrequency, Window= W, OverlapLength=hop_size, FFTLength=length(xx))
    

