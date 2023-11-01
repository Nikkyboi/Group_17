%Read the Global Specs File.
GS = readlines('global_specs.txt');
% Use input signal or generated signal? Possible: wav, generate
InputSignal = GS(3,1);
% WAV-filename
FileName = GS(5,1);
% Target sampling frequency (Hz) of the .wav file
SamplingFrequency_input = str2double(GS(7,1));
% Type of signal. Possible: rect, tone, tone-complex, noise
TypeOfSignal = GS(10,1);
% Sampling frequency (Hz)
SamplingFrequency = str2double(GS(12,1));
% Overall duration of the signal (in s)
TotalDuration = str2double(GS(14,1));
% Periodicity (s) - only applicable for "rect". The width of each rectangle should be half the period.
Periodicity = str2double(GS(16,1));
% Frequency/-ies of the tone/tone complex (only first if 'tone'
Frequencies_String = strsplit(GS(18,1),', ');
ToneFrequencies = zeros(0,numel(Frequencies_String));
for NumFrequencies = 1:numel(Frequencies_String)
    ToneFrequencies(NumFrequencies) = str2double(Frequencies_String(NumFrequencies));
end
% Spectral resolution (Hz)
SpectralRes = str2double(GS(21,1));
% Window type for time frame DFT/STFT. Possible: hann, hamming, rect
WindowType = GS(23,1);
% Overlap for STFT (%)
Overlap = str2double(GS(25,1));
% FILTERING
% Use FIR or IIR?
FilterType = GS(28,1);
% filter order
FilterOrder = str2double(GS(30,1));
% Approximation method. Possible: butterworth, chebychevI, chebychevII, cauer
ApproxMethod = GS(32,1);
% type. Possible: lp, hp, bp, bs
ApproxType = GS(34,1);
%cut-off frequency/-ies (Hz)
Frequencies_String = strsplit(GS(36,1),', ');
CutOffFrequencies = zeros(0,numel(Frequencies_String));
for NumFrequencies = 1:numel(Frequencies_String)
    CutOffFrequencies(NumFrequencies) = str2double(Frequencies_String(NumFrequencies));
end
% PLOTTING
% Limits of axis in time and spectrum.
% xlim - time (s)
xLimTime = str2double(GS(40,1));
% ylim - amplitude (a.u.)
ylimAmplityde = str2double(GS(42,1));
% frequency on linear or log axis?
% log in x? Possible: lin, log
XAxType = GS(45,1);
% log in y? Possible: lin, log
YAxType = GS(47,1);
% xlim - frequency (Hz) - we go only positive frequencies. If nyquist, then fs/2
xlimFrequency = GS(49,1);
% ylim - (a.u.) 
ylim = str2double(GS(42,1));
