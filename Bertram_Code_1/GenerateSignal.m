

fprintf("Running Generate Signal.m");

TypeOfSignal
TotalDuration
Periodicity
ToneFrequencies


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
    warning('ERROR In Generate Signal.m \n');
    warning('not valid TypeOfSignal \n');
end

fprintf("Done Generate Signal.m");

% Generate Signal Functions
function [rect,TimeVector] = generate_rect(TDur,Fs,PD)
% This function generates a rect wave signal, with length TotalDuration and
% sampling Frequency SamplingFrequency. 
N = TDur/Fs;

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
    N=round(N);
end
TimeVector = (0:1/Fs:TDur-1/Fs);
% Makes a rect vector. N+1 when 0 need to be included.

A = ones(1,Fs*PD);
B = zeros(1,Fs*PD);
C = [A B];
for N = 1:TDur
    C = [C C];
end

rect = C(1:TDur*Fs);
end

function [tone,TimeVector] = generate_tone(TDur,Fs,TFs)
%This function generates a tone wave signal, with length TotalDuration, and
%sampling frequency SamplingFrequency.
N = TDur/(1/Fs);

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
end

%makes a tone vector.
TimeVector = [0:1/Fs:TDur-1/Fs];
tone = sin(2*pi*TFs.*TimeVector);

end

function [toneComplex,TimeVector] = generate_toneComplex(TDur,Fs,TFs)

TimeVector = [0:1/Fs:TDur-1/Fs];
for N = 1:numel(TFs)
    tone(:,N) = sin(2*pi*TFs(N).*TimeVector);
end
toneComplex = sum(tone,2);
end

function [noise,TimeVector] = generate_noice(TDur,Fs)
%this function generates a random noise wave signal, with length TotalDuration
%and sampling frequency SamplingFrequency.
TimeVector = [0:1/Fs:TDur-1/Fs];
noise = transpose(rand(Fs*TDur,1));
end

function [TimeVec,SignalVec] = generate_sinusoid(Amp,fhz,phase,fs,Tdur)
%Denne funktion laver et sinusoidalt signal, udfra 5 parametre, som her er
%beskrevet. Amp er amplituden af det genererede signal, fhz er frekvensen
%af signalet, phase er fasen på signalet i "multipels" af 2*pi, fs er
%sampling frekvensen, Tdur er tidslængden af signalet. Outputtet er først
%en tidsvektor, med en tilhørende signal vektor. tidsvektoren indeholder
%alle de korresponderende tidspunkter hvor der er genereret et signal
%punkt / blevet samplet.

%Først genereres en vektor med alle tidspunkterne.
%Finder størrelsen af tidsskridtne.
dT = 1/fs;
%Laver tidsvektor.
TimeVec = 0:dT:Tdur-dT;
%Generere signal.
SignalVec = Amp*sin(2*pi*fhz.*TimeVec+phase);


%Vend gerne tilbage til funktionen senere, da dannelsen af tidssvektoren
%kan være upræcis pga. afrundinger.


end






