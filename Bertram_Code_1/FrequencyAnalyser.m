%   Important notes:
%   To do windowing in time domain we do multiplication:   S[n]*W[n]
%   To do windowing in frequency domain we do convolution: conv(S[n],W[n])
   
%%  DFT below uses the entire signal

%   Generate an example cos signal with same frequency but time t = 10s
    T0 = 0;
    T1 = 10;
    Ts = 1.0 / TargetSamplingFrequency;
    t = T0:Ts:T1;
    %t = 0:1/SamplingFrequency:TotalDuration;   % New signal
    s0 = ((1 - 1.005037815.*exp(-0.5*t).*sin(25*t + 1.470628906)) - 1);

%   Window Size:
    N = length(0:1/TargetSamplingFrequency:TotalDuration);

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
frequencies = linspace(-TargetSamplingFrequency/2, TargetSamplingFrequency/2, N1);
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
    Ts = 1.0 / TargetSamplingFrequency;
%   Length of Signal
    t = T0:Ts:T1;
    window_l = length(0:1/TargetSamplingFrequency:TotalDuration);
    M = TargetSamplingFrequency/SpectralRes;
%   Generate random signal
    s0 = ((1 - 1.005037815.*exp(-0.5*t).*sin(25*t + 1.470628906)) - 1);
    %s0 = InputSignalType;
%   Overlap:
%    Overlap_size = round(M*(Overlap/100));

%   Hopsize:
%    hop_size = M - Overlap_size;

%   Number of frames:
%    Number_Of_Frames = round((N-M) / hop_size) + 1;
    
%   Assuming time domain:
if WindowType == "hann";
    fprintf('FilterType is IIR \n');
    W = hann(window_l);
    s = "Hann"

elseif WindowType == "hamming";
    fprintf('WindowType is hamming \n');
    W = hamming(window_l);
    s = "Hamming"

elseif WindowType == "rect";
    fprintf('WindowType is rect \n');
    W = rectwin(window_l);
    s = "Rectangular"
end
    %   Overlap:
    Overlap_perc = Overlap/100;

%   Hopsize:
    hop_size = round((window_l)*Overlap_perc);

    stft(s0, TargetSamplingFrequency, Window= W, OverlapLength=hop_size, FFTLength=window_l)

%%  Self made STFT
%   Generate an example cos signal with same frequency but time t = 10s
    T0 = 0;
    T1 = 10;
    Ts = 1.0 / TargetSamplingFrequency;
%   Length of Signal
    t = T0:Ts:T1;
    N = 0:1/TargetSamplingFrequency:TotalDuration;
    M = TargetSamplingFrequency/SpectralRes;
%   Generate random signal
    s0 = ((1 - 1.005037815.*exp(-0.5*t).*sin(25*t + 1.470628906)) - 1);
 
% Define STFT parameters
window_length = length(N) - 1;

% Total length of signal:
tot_l = length(s0) - 1;

%   Assuming time domain:
if WindowType == "hann";
    fprintf('FilterType is IIR \n');
    W = hann(window_length);
    s = "Hann"

elseif WindowType == "hamming";
    fprintf('WindowType is hamming \n');
    W = hamming(window_length);
    s = "Hamming"

elseif WindowType == "rect";
    fprintf('WindowType is rect \n');
    W = rectwin(window_length);
    s = "Rectangular"
end

% Initialize STFT matrix
STFT = [];

%   Overlap:
    Overlap_perc = Overlap/100;

%   Hopsize:
    hop_size = window_length*Overlap_perc;

%   Number of frames:
    Number_Of_Frames = round(tot_l/(hop_size));
    
% Loop over the signal with overlapping windows
for i = 0:Number_Of_Frames-1
    % Extract the current window
    x_windowed = s0(i*hop_size + 1:(i*hop_size+window_length)) .* W;
    
    % Compute the FFT of the windowed signal
    X = fft(x_windowed);
    
    % Append the result to the STFT matrix
    STFT = [STFT, X];
end

% Compute the time and frequency axes
time_axis = (window_length/2:overlap_points:length(s0)-window_length/2) / TargetSamplingFrequency;
frequency_axis = (0:window_length-1) * TargetSamplingFrequency / window_length;

% Plot the magnitude spectrogram
figure;
imagesc(time_axis, frequency_axis, 10*log10(abs(STFT)));
axis xy;
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Manually Calculated STFT');

%%
clear;
% Create chirp

%   Generate an example cos signal with same frequency but time t = 10s
    T0 = 0;
    T1 = 10;
    Ts = 1.0 / 10000;
%   Length of Signal
    t = T0:Ts:T1;
    N = 0:1/10000:4;
    M = 10000/1;
%   Generate random signal
    x = ((1 - 1.005037815.*exp(-0.5*t).*sin(25*t + 1.470628906)) - 1);

%lx = 2048;
%n = 0:lx-1;
%x = cos(2*pi*(n/128).^2)';

% Create w[n]
Nfft = length(N)-1; % size of DFT
R = 2; % overlap factor
L = Nfft-R+1; % frame size (length of w[n]) 
h = hann(L); % make w[n]
h = 2 * h / sum(h); % normalize

% Compute STFT
D = (L-1)/R; % frame overlap
nFrames = floor((T1-L)/D+1); % number of frames of STFT data Xwm = zeros(Nfft, nFrames); % allocate STFT ...
Xwm = zeros(Nfft, nFrames);
for m = 1:nFrames % ... and calculate it
    indx = (m-1)*D + 1;
Xwm(:, m) = fft(x(indx:indx+L-1).*h, Nfft); % this is x[n]w[n-mD] end
end

% Plot spectrogram
wmax = 0.5; % max freq = pi/2
npts = Nfft*wmax/2+1; % select part of FFT
x = (0:D:(nFrames)*D);
y = linspace(0, wmax, npts);
z = db(abs(Xwm(1:npts, :)));
noff = (L-1)/2; % offset of center of time window 
surf(x+noff, y, z, 'EdgeColor', 'none');
hold on;
plot([0 Nfft], [0 Nfft], 'k')
zl = -50; % minimum magnitude to display
set(gca, 'View', [0 90 ], 'XLim', [0 10000 ], 'ZLim', [zl 0 ],'CLim', [zl 0] )

%%

% Converts to descibles
function descible = convert_descible(signal)
    descible = 20*log10.(abs.(signal));
end

% Creates the frequency axis
function delta = frequency_vector(f, fs)
    T = length(f)/fs
    delta = 1/T
end


