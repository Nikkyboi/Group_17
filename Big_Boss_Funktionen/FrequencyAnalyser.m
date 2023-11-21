%   Important notes:
%   To do windowing in time domain we do multiplication:   S[n]*W[n]
%   To do windowing in frequency domain we do convolution: conv(S[n],W[n])
   
%%  DFT below uses the entire signal

%   Generate an example cos signal with same frequency but time t = 10s
    T0 = 0;
    T1 = 10;
    Ts = 1.0 / SamplingFrequency;
    t = T0:Ts:T1;
    %t = 0:1/SamplingFrequency:TotalDuration;   % New signal
    s0 = ((1 - 1.005037815.*exp(-0.5*t).*sin(25*t + 1.470628906)) - 1);

%   Window Size:
    N = length(0:1/SamplingFrequency:TotalDuration);

%   Ved ikke hvordan jeg sætter denne parameter:
    N1 = SamplingFrequency;

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

% Zero Padding
time_difference = length(t) - N;
if time_difference > 0
    New_W = [W; zeros(time_difference, 1)];
    Windowed_Signal = s0.*New_W';
else
    Windowed_Signal = s0.*W';
end

wLine = 1;
figure(1)
subplot(3, 1, 1);
plot(t, New_W, 'k', 'LineWidth', wLine);
legend(s);
xlabel('time (s)');
title("Window ", s);
subplot(3, 1, 2);
plot(t,s0)
title("Signal of 10 sec ");
xlabel('time (s)');
subplot(3, 1, 3);
plot(t, Windowed_Signal)
title("Windowed Signal to 4 sec ");
xlabel('time (s)');

% Compute and plot frequency domain spectrums
xx = abs(fft(W, N1))/max(abs(fft(W, N1)));
W = fftshift(20*log10(xx));

% Plot frequency domain spectrum for Window
figure(2)
subplot(2, 2, 1);
frequencies = linspace(-SamplingFrequency/2, SamplingFrequency/2, N1);
plot(frequencies, W, 'k', 'LineWidth', wLine);
title('window Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% Repeat the process for the zero padded window
yy = abs(fft(New_W, N1))/max(abs(fft(New_W, N1)));
New_W = fftshift(20*log10(yy));

subplot(2, 2, 2);
plot(frequencies, New_W, 'k', 'LineWidth', wLine);
title('Zero padded window Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% Repeat the process for the signal
yy = abs(fft(s0, N1))/max(abs(fft(s0, N1)));
s00 = fftshift(20*log10(yy));

subplot(2, 2, 3);
plot(frequencies, s00, 'k', 'LineWidth', wLine);
title('Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% Repeat the process for the Windowed_signal
yy = abs(fft(Windowed_Signal, N1))/max(abs(fft(Windowed_Signal, N1)));
Windowed_Signal_FQ = fftshift(20*log10(yy));

subplot(2, 2, 4);
plot(frequencies, Windowed_Signal_FQ, 'k', 'LineWidth', wLine);
title('Windowed Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

%% STFT analysis where we split the signal up into chunks
%   Generate an example cos signal with same frequency but time t = 10s
    T0 = 0;
    T1 = 10;
    Ts = 1.0 / SamplingFrequency;
%   Length of Signal
    t = T0:Ts:T1;
    N = length(t);
    M = length(0:1/SamplingFrequency:TotalDuration);
%   Generate random signal
    s0 = ((1 - 1.005037815.*exp(-0.5*t).*sin(25*t + 1.470628906)) - 1);
    
%   Overlap:
%    Overlap_size = round(M*(Overlap/100));

%   Hopsize:
%    hop_size = M - Overlap_size;

%   Number of frames:
%    Number_Of_Frames = round((N-M) / hop_size) + 1;
    
%   Assuming time domain:
if WindowType == "hann";
    fprintf('FilterType is hann \n');
    W = hann(M);
    s = "Hann"

elseif WindowType == "hamming";
    fprintf('WindowType is hamming \n');
    W = hamming(M);
    s = "Hamming"

elseif WindowType == "rect";
    fprintf('WindowType is rect \n');
    W = rectwin(M);
    s = "Rectangular"
end
    
    stft(s0, SamplingFrequency, Window= W, OverlapLength=Overlap, FFTLength=SamplingFrequency)
%%
% Zero Padding
time_difference = length(t) - N;
arr = [];
for i = 1:Number_Of_Frames
if i == 0
    New_W = [W; zeros(time_difference, 1)];
    Windowed_Signal = s0.*New_W';
elseif i == Number_Of_Frames
    Windowed_Signal = s0.*W';
else 
    
end


    arr = [arr, ]

%%
end




% Converts to descibles
function descible = convert_descible(signal)
    descible = 20*log10.(abs.(signal));
end

% Creates the frequency axis
function delta = frequency_vector(f, fs)
    T = length(f)/fs
    delta = 1/T
end


