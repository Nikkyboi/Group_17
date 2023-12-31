%   Important notes:
%   To do windowing in time domain we do multiplication:   S[n]*W[n]
%   To do windowing in frequency domain we do convolution: conv(S[n],W[n])
%%  DFT below uses the entire signal
    
%   FFT of the whole signal
freq = abs(fft(Signal))/max(abs(fft(Signal)));
   
n = length(freq)
frequency_vec = linspace(0, TargetSamplingFrequency/2, (n/2));
frequency_spec = linspace(-TargetSamplingFrequency/2, TargetSamplingFrequency/2, n);
 
Pos_Freq = freq(1:end/2);
Pos_Freq = fliplr(Pos_Freq);

figure(1)
subplot(2,1,1)
plot(frequency_vec, Pos_Freq)
title("Positive frequency")
xlabel("Frequency [Hz]")
subplot(2,1,2)
plot(frequency_spec, freq)
title("The whole frequency spectrum")
xlabel("Frequency [Hz]")

%   Assuming time domain:
if WindowType == "hann";
    N = ceil(TargetSamplingFrequency/SpectralRes);
    fprintf('FilterType is hann \n');
    W = hann(N);
    s = "Hann"

elseif WindowType == "hamming";
    N = ceil(TargetSamplingFrequency/SpectralRes);
    fprintf('WindowType is hamming \n');
    W = hamming(N);
    s = "Hamming"

elseif WindowType == "rect";
    N = ceil(TargetSamplingFrequency/SpectralRes)
    fprintf('WindowType is rect \n');
    W = rectwin(N);
    s = "Rectangular"
end

% Time Vector:
t = 0:1/TargetSamplingFrequency:(N/TargetSamplingFrequency - 1/TargetSamplingFrequency);

% If signal size does not match then create new array
time_difference = length(Signal) - N;
if time_difference > 0
    New_signal = zeros(1, N);
    for i = 1:N-1
        New_signal(i) = Signal(i);
    end
    Windowed_Signal = New_signal.*W';
elseif time_difference == 0
    Windowed_Signal = signal.*W';
else
    warning('The window is longer than the actual signal')
    Windowed_Signal = zeros(1, N);
    Signal = [Signal, zeros(1, N-length(Signal))];
    for i = 1:length(Signal)-1
        Windowed_Signal(i) = Signal(i)*W(i)';
    end
    NewTimeAxis = t;
end


% Calulating the frequency resolution
dF = TargetSamplingFrequency/length(Windowed_Signal);

% Plotting:
wLine = 1;
figure(2)
subplot(3, 1, 1);
plot(NewTimeAxis, Signal)
title("Original Signal");
xlabel('Sampels');
subplot(3, 1, 2);
plot(t, W, 'k', 'LineWidth', wLine);
legend(s);
xlabel('time (s)');
title("Window: " + s);
subplot(3, 1, 3);
plot(t, Windowed_Signal)
title("Windowed Signal");
xlabel('time (s)');

% Compute and plot frequency domain spectrums
xx = abs(fft(Windowed_Signal, N))/max(abs(fft(Windowed_Signal, N)));
Windowed_Signal_FQ = fftshift(20*log10(xx));

% Plot frequency domain spectrum for Window
figure(3)
subplot(2, 1, 1);

% Frequency spectrum
frequencies_spec = linspace(-TargetSamplingFrequency/2, TargetSamplingFrequency/2, length(xx));

% Frequency vector
frequeny_vec = linspace(0, TargetSamplingFrequency/2, length(xx));

subplot(2, 1, 1);
plot(frequencies_spec, Windowed_Signal_FQ, 'k', 'LineWidth', wLine);
title('Windowed Signal Spectrum', "New Spectral Resolution " + string(dF));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% STFT analysis where we split the signal up into chunks
%   Overlap: 
    
Overlap_perc = Overlap/100;

%   Hopsize:
hop_size = ceil(N*Overlap_perc);

%   Length of signal
sig_len = length(Signal);


subplot(2, 1, 2);
[s, f, t] = stft(Signal, TargetSamplingFrequency, 'Window', W, 'OverlapLength', hop_size, 'FFTLength', length(W));

p = "Short Term Fourier Transform [Overlap = " + string(Overlap) + "%]";
title(p)  
