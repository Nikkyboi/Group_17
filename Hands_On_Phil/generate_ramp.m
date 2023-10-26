function [Ramp] = generate_ramp(TDur,Fs)
%Denne funktion laver et ramp wave signal, med længden TDur og med
%samplingsfrekvensen Fs.
N = TDur/Fs;

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N));
    N=round(N);
end

%Laver square vektor.
Ramp = 0:Fs:TDur;

end