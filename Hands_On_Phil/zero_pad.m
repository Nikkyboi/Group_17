function [SigTot] = zero_pad(TDur,Sig,Fs)
%Denne funktion tilføjer zeros således at signalet i Sig passer med den
%indikerede længde fra TDur og Fs.
N = TDur/Fs;

if abs(N-round(N))>0
    warning('Length of vector not integer, N has been rounded off to %i',round(N))
    N=round(N);
end


%Tilføjer zeros så lægnden af vektoren med signalet passer med længden af
%TDur. Tilføjer N+1 da nul også skal være med i intervallet.
SigTot = zeros(1,N+1);
%Tilføjer error, hvis TDur er kortere end signal længden.
if length(Sig)>length(SigTot)
    error('Cannot add zero padding, length of input vector longer than new zero padded vector')
end
%Tilføjer signalet til zeros vektoren.
SigTot(1:length(Sig)) = Sig(1:end);


end