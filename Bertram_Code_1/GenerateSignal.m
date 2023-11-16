

fprintf("Running Generate Signal.m \n");

% This will choose to generate the correct type of signal specified by the
% Global Specs
if TypeOfSignal == "tone"
    fprintf('TypeOfSignal is rect \n');
    [rect,TimeVector] = generate_rect(TotalDuration,SamplingFrequency, Periodicity);
    %plot(TimeVector,rect);
elseif TypeOfSignal == "tone"
    fprintf('TypeOfSignal is tone \n');
    [tone,TimeVector] = generate_tone(TotalDuration,SamplingFrequency,ToneFrequencies(1));
    %plot(TimeVector,tone);
elseif TypeOfSignal == "tone-complex"
    fprintf('TypeOfSignal is tone-complex \n');
    [toneComplex,TimeVector] = generate_toneComplex(TotalDuration,SamplingFrequency,ToneFrequencies);
    %plot(TimeVector,toneComplex);
elseif TypeOfSignal == "noise"
    fprintf('TypeOfSignal is noise \n');
    [noise,TimeVector] = generate_noice(TotalDuration,SamplingFrequency);
    %plot(TimeVector,noise);
else
    % if the Type of signal do not match our expected inputs, throw a
    % warning
    warning('ERROR In Generate Signal.m \n');
    warning('not valid TypeOfSignal \n');
end

GenerateZeroSignal = zeros(1,SamplingFrequency*TotalDuration);
fprintf("Done Generate Signal.m \n");






















% Generate Signal Functions

function [rect,TimeVector] = generate_rect(TDur,Fs,PD)
% This function generates a squarewave signal, with length
% TotalDuration,sampling Frequency and Periodicity.

% Check for roundings 
N = TDur/(1/Fs);

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
    N=round(N);
end


TimeVector = (0:1/Fs:TDur-1/Fs);

% Create a array with ones and zeroes, with the amount equals to the
% peridecity duration
A = ones(1,Fs*PD);
B = zeros(1,Fs*PD);
C = [A B];

% repeat looping the array to be longer then the total signal duration
for N = 0:PD:TDur
    C = [C C];
end

% return the neede part
rect = C(1:TDur*Fs);
end

function [tone,TimeVector] = generate_tone(TDur,Fs,TFs)
%This function generates a tone wave signal, with length TotalDuration, and
%sampling frequency SamplingFrequency.

% Check for roundings 
N = TDur/(1/Fs);

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
    N=round(N);
end

%makes a tone vector.
TimeVector = [0:1/Fs:TDur-1/Fs];
tone = sin(2*pi*TFs.*TimeVector);

end

function [toneComplex,TimeVector] = generate_toneComplex(TDur,Fs,TFs)

% Check for roundings 
N = TDur/(1/Fs);

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
    N=round(N);
end

TimeVector = [0:1/Fs:TDur-1/Fs];

% Make mulitble tones listed as collomn arrays.
for N = 1:numel(TFs)
    tone(:,N) = sin(2*pi*TFs(N).*TimeVector);
end

% Sum the tones generatied ind the collomn array
toneComplex = sum(tone,2);
end

function [noise,TimeVector] = generate_noice(TDur,Fs)
%this function generates a random noise wave signal, with length TotalDuration
%and sampling frequency SamplingFrequency.


% Check for roundings 
N = TDur/(1/Fs);

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
    N=round(N);
end

TimeVector = [0:1/Fs:TDur-1/Fs];

% Noise is generated from rand function
noise = transpose(rand(Fs*TDur,1));
end







