

[toneComplex,TimeVector] = generate_toneComplex(5,15000,[500 1000 3000 5000 8000]);

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