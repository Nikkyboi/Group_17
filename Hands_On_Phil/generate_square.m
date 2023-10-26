function [Square] = generate_square(TDur,Fs)
%Denne funktion laver et square wave signal, med længden TDur og med
%samplingsfrekvensen Fs.
N = TDur/Fs;

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
    N=round(N);
end

%Laver square vektor. N+1 da nul også gerne skal med.
Square = ones(1,N+1).*1/TDur;

end

